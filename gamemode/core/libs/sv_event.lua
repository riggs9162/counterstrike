cs.event = cs.event or {}

util.AddNetworkString("cs.PlaySound")
util.AddNetworkString("cs.StopSound")
util.AddNetworkString("cs.ViewPunch")
    
function cs.util.PlaySound(caller, soundData)
    if not ( IsValid(caller) and soundData.sound ) then
        return
    end

    net.Start("cs.PlaySound")
        net.WriteTable({
            sound = soundData.sound,
            db = soundData.db or 75,
            pitch = soundData.pitch or 100,
            volume = soundData.volume or 1,
            delay = soundData.delay or nil,
        })
    net.Send(caller)
end

function cs.util.PlaySoundGlobal(soundData)
    if not ( soundData.sound ) then
        return
    end

    net.Start("cs.PlaySound")
        net.WriteTable({
            sound = soundData.sound,
            db = soundData.db or 75,
            pitch = soundData.pitch or 100,
            volume = soundData.volume or 1,
            delay = soundData.delay or nil,
        })
    net.Broadcast()
end

function cs.util.StopSoundGlobal(soundString, delay)
    if not ( soundString ) then
        return
    end

    timer.Simple(delay or 0, function()
        net.Start("cs.StopSound")
            net.WriteString(soundString)
        net.Broadcast()
    end)
end

function cs.util.EmitShake(amplitute, frequency, duration, delay)
    timer.Simple(delay or 0, function()
        for k, v in ipairs(player.GetAll()) do
            if ( IsValid(v) ) then
                util.ScreenShake(v:GetPos(), amplitute, frequency, duration, 64)
            end
        end
    end)
end

function cs.util.EmitViewPunch(angle, delay)
    timer.Simple(delay or 0, function()
        for k, v in ipairs(player.GetAll()) do
            if ( IsValid(v) ) then
                v:ViewPunch(angle)
            end
        end

        net.Start("cs.ViewPunch")
            net.WriteAngle(angle)
        net.Broadcast()
    end)
end

concommand.Add("cs_stopsoundall", function(ply, cmd, args)
    if ( ply:IsSuperAdmin() ) then
        return
    end
    
    for k, v in pairs(player.GetAll()) do
        v:ConCommand("stopsound")
    end
end)

concommand.Add("cs_playsoundall", function(ply, cmd, args)
    if ( ply:IsSuperAdmin() ) then
        return
    end

    cs.util.PlaySoundGlobal({sound = args[1]})
end)