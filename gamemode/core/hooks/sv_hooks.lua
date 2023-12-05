function GM:PlayerInitialSpawn(ply)
    ply.isSpectator = true
    ply.items = {}

    if ( ply:IsBot() ) then
        local randomTeam = table.Random({FACTION_CTERRORIST, FACTION_TERRORIST})
        local randomModel = table.Random(cs.faction.stored[randomTeam].models)

        ply:SetTeam(randomTeam)
        ply:SetNWInt("faction", randomTeam)
        ply:SetNWInt("model", randomModel)
    end
end

function GM:PlayerSpawn(ply)
    ply:UnSpectate()
    ply:SetupHands()
end

function GM:PlayerHurt(ply)
end

function GM:GetGameDescription()
    return "Counter-Strike"
end

function GM:SetupPlayerVisibility(ply, viewEntity)
    local mapConfig = cs.mapConfig[game.GetMap()]

    if ( ply.bInMainMenu and mapConfig and mapConfig.menuView ) then
        AddOriginToPVS(mapConfig.menuView.origin)
    end
end

function GM:InitPostEntity()
    local mapConfig = cs.mapConfig[game.GetMap()]

    if ( mapConfig and mapConfig.initPostEntity ) then
        mapConfig.initPostEntity()
    end
end

function GM:CanPlayerSuicide()
    return false
end

function GM:PlayerCanHearPlayersVoice()
    return true
end

function GM:PlayerShouldTakeDamage(ply, attacker)
    return true
    
    /*
    if not ( IsValid(attacker) and attacker:IsPlayer() ) then
        return
    end
    
    if ( attacker:Team() == ply:Team() ) then
        return false
    else
        return true
    end
    */
end

function GM:PlayerSwitchFlashlight()
    return true
end

function GM:PlayerSpray()
    return true
end

function GM:GetFallDamage(ply, speed)
    return speed / 8
end

function GM:OnDamagedByExplosion()
    return true
end

function GM:DoPlayerDeath(ply)
    for k, v in pairs(ply.items) do
        local data = cs.shop.Get(k)
        if not ( data ) then
            continue
        end

        cs.shop.SpawnDroppedItem(v, ply:EyePos())
    end
end

function GM:PlayerDeath(ply)
    ply.isSpectator = true
end

function GM:ScalePlayerDamage(ply, hitgroup, dmginfo)
end

function GM:PlayerSelectSpawn(ply)
    local team = ply:Team()
    local spawns = ents.FindByClass("info_player_counterterrorist")
    if ( team == FACTION_TERRORIST ) then
        spawns = ents.FindByClass("info_player_terrorist")
    end

    return table.Random(spawns)
end

function GM:PlayerSelectTeamSpawn(ply)
    local team = ply:Team()
    local spawns = ents.FindByClass("info_player_counterterrorist")
    if ( team == FACTION_TERRORIST ) then
        spawns = ents.FindByClass("info_player_terrorist")
    end

    return table.Random(spawns)
end

function GM:SpectatorThink(ply)
    ply:Spectate(OBS_MODE_ROAMING)
    ply:SpectateEntity(nil)
end

GM.PlayerDeathThink = GM.SpectatorThink

local tm = nil
local ply = nil
local plys = nil
function GM:Tick()
    // three cheers for micro-optimizations
    plys = player.GetAll()
    for i = 1, #plys do
        ply = plys[i]
        if ( ply.isSpectator ) then
            // if spectators are alive, ie. they picked spectator mode, then
            // DeathThink doesn't run, so we have to SpecThink here
            if ( ply:Alive() ) then
                self:SpectatorThink(ply)
            end
        end
    end
end

function GM:PlayerChangedTeam(ply, oldTeam, newTeam)
    if ( #team.GetPlayers(FACTION_TERRORIST) >= 1 and #team.GetPlayers(FACTION_CTERRORIST) >= 1 ) then
        cs.rounds.Win()
    end
end

if ( timer.Exists("cs.NetworkUpdateTimer") ) then
    timer.Remove("cs.NetworkUpdateTimer")
end

// expensive, ik
timer.Create("cs.NetworkUpdateTimer", 0.75, 0, function()
    for k, v in ipairs(player.GetAll()) do
        if not ( v.items ) then
            continue
        end

        local itemReference = {}
        for k2, v2 in pairs(v.items) do
            itemReference[k2] = v2.name
        end

        v:SetNetVar("cs.Items", itemReference)
    end
end)