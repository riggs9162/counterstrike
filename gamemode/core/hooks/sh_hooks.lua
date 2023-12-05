function GM:PlayerFootstep(ply, position, foot, soundName, volume)
    if ( SERVER ) then
        if not ( ply:KeyDown(IN_SPEED) or ply:KeyDown(IN_DUCK) ) then
            ply:EmitSound(soundName, 80, math.random(90, 110))
        end
    end

    return true
end

function GM:ShouldCollide(ent1, ent2)
    if ( ent1:IsPlayer() and ent2:IsPlayer() ) then
        return false
    end
end

function GM:UpdateAnimation(ply, vel, maxGroundSpeed)
    local len = vel:Length()
    local rate = 1.0

    if ( len > 0.5 ) then
        rate = ( ( len * 0.8 ) / maxGroundSpeed )
    end

    ply:SetPlaybackRate(math.Clamp(rate, 0, 1.5))
end