concommand.Add("cs_debug_pos", function(ply)
    local pos = ply:GetPos()

    local output = "Vector("..pos.x..", "..pos.y..", "..pos.z..")"
    chat.AddText(output)

    SetClipboardText(output)
end)

concommand.Add("cs_debug_eyepos", function(ply)
    local pos = ply:EyePos()

    local output = "Vector("..pos.x..", "..pos.y..", "..pos.z..")"
    chat.AddText(output)

    SetClipboardText(output)
end)

concommand.Add("cs_debug_ang", function(ply)
    local pos = ply:EyeAngles()

    local output = "Angle("..pos.p..", "..pos.y..", "..pos.r..")"
    chat.AddText(output)

    SetClipboardText(output)
end)

concommand.Add("cs_debug_getbones", function(ply)
    local ent = ply:GetEyeTrace().Entity
    if not ( ent and IsValid(ent) ) then
        print("Invalid entity")
        return
    end
    
    for i = 0, ent:GetBoneCount() - 1 do
        local bonepos = ent:GetBonePosition(i)
        print("Bone "..i.."\nName: "..ent:GetBoneName(i).."\nVector("..bonepos.x..", "..bonepos.y..", "..bonepos.z..")")
    end
end)

concommand.Add("cs_debug_getattachments", function(ply)
    local ent = ply:GetEyeTrace().Entity
    if not ( ent and IsValid(ent) ) then
        print("Invalid entity")
        return
    end
    
    PrintTable(ent:GetAttachments())
end)