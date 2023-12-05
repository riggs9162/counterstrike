function PLAYER:Notify(message)
    cs.notification.Notify(message, self)
end

function PLAYER:OpenVGUI(ui)
    cs.util.OpenVGUI(ui, self)
end

function PLAYER:GetFactionTable()
    return cs.faction.stored[self:Team()]
end

function PLAYER:DropItem(item)
    local data = cs.shop.Get(item)
    if not ( data ) then
        error("Couldn't find item "..tostring(item).."!")
    end

    if ( data.onDrop ) then
        data.onDrop(self)
    end

    self:EmitSound("items/itempickup.wav")
end

if ( SERVER ) then
    concommand.Add("cs_dropweapon", function(ply, cmd, args)
        local item = tonumber(args[1])
        local data = cs.shop.Get(item)
        if not ( data ) then
            cs.notification.Notify(ply, "Couldn't find item "..tostring(item).."!")
            return
        end

        ply:DropItem(item)
    end)
end