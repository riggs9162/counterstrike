cs.rounds = cs.rounds or {}

function cs.rounds.Begin()
    for k, v in pairs(player.GetAll()) do
        v:SetWalkSpeed(cs.config["walkSpeed"])
        v:SetRunSpeed(cs.config["runSpeed"])
        v:GodDisable()
    end

    cs.util.PlaySoundGlobal({
        sound = "radio/letsgo.wav",
    })

    cs.rounds.roundover = nil
end

function cs.rounds.Reset()
    for k, v in pairs(player.GetAll()) do
        v.lastWeapons = {}
        v.lastItems = {}

        for k2, v2 in ipairs(v:GetWeapons()) do
            table.insert(v.lastWeapons, v2:GetClass())
        end

        for k2, v2 in ipairs(v.items) do
            v.lastItems[k2] = v2
        end
    end

    game.CleanUpMap()

    timer.Simple(0.1, function() // let everything else load...
        for k, v in ipairs(player.GetAll()) do
            v:SetTeam(v:GetNWInt("faction", table.Random({FACTION_CTERRORIST, FACTION_TERRORIST})))
            v:SetModel(v:GetNWInt("model", table.Random(cs.faction.stored[v:Team()].models)))
            
            v:Spawn()
            v:StripAmmo()
            v:StripWeapons()
            v:EmitSound("items/gift_drop.wav", 70)

            v:SetWalkSpeed(1)
            v:SetRunSpeed(1)

            v:GodEnable()

            v:Give("tfa_cs_knife")

            if ( v.isSpectator ) then
                for k2, v2 in ipairs(cs.faction.stored[v:Team()].weapons) do
                    v:Give(v2)
                end

                for k2, v2 in ipairs(cs.faction.stored[v:Team()].items) do
                    for k3, v3 in ipairs(cs.shop.GetAll()) do
                        if ( v3.name != v2 ) then
                            continue
                        end

                        v.items[k3] = cs.shop.Get(k3)
                    end
                end
            else
                for k2, v2 in ipairs(v.lastWeapons) do
                    v:Give(v2)
                end

                for k2, v2 in ipairs(v.lastItems) do
                    v.items[k2] = v2
                end
            end

            v.lastWeapons = {}
            v.lastItems = {}
            v.isSpectator = nil
        end
    end)

    timer.Simple(8, function()
        cs.rounds.Begin()
    end)
end

function cs.rounds.Win(team)
    if ( cs.rounds.roundover ) then
        return
    end
    
    cs.rounds.roundover = true

    if ( team == FACTION_CTERRORIST ) then
        cs.util.PlaySoundGlobal({
            sound = "radio/ctwin.wav",
        })
    elseif ( team == FACTION_TERRORIST ) then
        cs.util.PlaySoundGlobal({
            sound = "radio/terwin.wav",
        })
    else
        cs.util.PlaySoundGlobal({
            sound = "radio/rounddraw.wav",
        })
    end

    timer.Simple(6, function()
        cs.rounds.Reset()
    end)
end

local function GetAliveTeamPlayers(index)
    local peopleyeah = {}

    for k, v in pairs(team.GetPlayers(index)) do
        if ( v.isSpectator ) then
            continue
        end
        
        table.insert(peopleyeah, v)
    end

    return peopleyeah
end

function cs.rounds.StateChecker()
    if ( #team.GetPlayers(FACTION_TERRORIST) == 0 or #team.GetPlayers(FACTION_CTERRORIST) == 0 ) then
        return
    end

    if ( #GetAliveTeamPlayers(FACTION_TERRORIST) == 0 ) and ( #GetAliveTeamPlayers(FACTION_CTERRORIST) == 0 ) then
        cs.rounds.Win()
    elseif ( #GetAliveTeamPlayers(FACTION_TERRORIST) == 0 ) then
        cs.rounds.Win(FACTION_CTERRORIST)
    elseif ( #GetAliveTeamPlayers(FACTION_CTERRORIST) == 0 ) then
        cs.rounds.Win(FACTION_TERRORIST)
    end
end

if ( timer.Exists("cs.Rounds.StateChecker") ) then
    timer.Remove("cs.Rounds.StateChecker")
end

timer.Create("cs.Rounds.StateChecker", 1, 0, function()
    cs.rounds.StateChecker()
end)