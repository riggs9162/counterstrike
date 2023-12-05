AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:PhysicsInit(SOLID_VPHYSICS) 
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local physObj = self:GetPhysicsObject()

    if ( IsValid(physObj) ) then
        physObj:EnableMotion(true)
        physObj:Wake()
    end
end

function ENT:OnTakeDamage(dmg)
    self:TakePhysicsDamage(dmg)
end

function ENT:Use(ply)
    local data = cs.shop.Get(self:GetItemIndex())
    if not ( data ) then
        error("Invalid Item")
    end

    if ( data.canPickup ) then
        local canPickup, message = data.canPickup(ply, self)

        if ( canPickup ) then
            self:EmitSound("items/itempickup.wav")
            ply:EmitSound("items/itempickup.wav")

            if ( data.onPickup ) then
                data.onPickup(ply, self)
            end
        else
            if ( message ) then
                cs.notification.Notify(ply, message)
            end

            return false
        end
    end
end