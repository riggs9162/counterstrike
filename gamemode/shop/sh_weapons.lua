// I sincerly apologize for this shit shop system

// Pistols
WEAPON_GLOCK18 = cs.shop.Register({
    name = "Glock 18",
    model = "models/weapons/w_pist_glock18.mdl",
    category = "Pistols",
    price = 100,
    canPickup = function(ply, ent)
        if ( ply:HasWeapon("tfa_pist_glock") ) then
            return false, "You already have this weapon!"
        end

        for k, v in pairs(ply.items) do
            if ( table.HasValue(v, "Pistols") and cs.shop.Get(ent:GetItemIndex()).category == "Pistols" ) then
                return false, "You already have a weapon in this category!"
            end
        end

        return true
    end,
    onPickup = function(ply, ent)
        ply.items[WEAPON_GLOCK18] = cs.shop.Get(WEAPON_GLOCK18)
        ply:Give("tfa_pist_glock")

        if ( IsValid(ent) ) then
            ent:Remove()
        end
    end,
    onBuy = function(ply)
        if ( ply:HasWeapon("tfa_pist_glock") ) then
            cs.shop.SpawnDroppedItem(cs.shop.Get(WEAPON_GLOCK18), ply:EyePos() + ply:GetAngles():Forward() * 32)
            return
        end

        for k, v in pairs(ply.items) do
            if ( table.HasValue(v, "Pistols") ) then
                cs.shop.SpawnDroppedItem(cs.shop.Get(WEAPON_GLOCK18), ply:EyePos() + ply:GetAngles():Forward() * 32)
                return
            end
        end

        ply.items[WEAPON_GLOCK18] = cs.shop.Get(WEAPON_GLOCK18)
        ply:Give("tfa_pist_glock")
    end,
    onDrop = function(ply)
        if ( ply:HasWeapon("tfa_pist_glock") ) then
            cs.shop.SpawnDroppedItem(cs.shop.Get(WEAPON_GLOCK18), ply:EyePos() + ply:GetAngles():Forward() * 32)
            if ( IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "tfa_pist_glock" ) then
                ply:SelectWeapon("tfa_cs_knife")
            end
            ply:StripWeapon("tfa_pist_glock")
            ply.items[WEAPON_GLOCK18] = nil
        end
    end,
})

WEAPON_USP = cs.shop.Register({
    name = "USP Tactical",
    model = "models/weapons/w_pist_usp.mdl",
    category = "Pistols",
    price = 100,
    canPickup = function(ply, ent)
        if ( ply:HasWeapon("tfa_pist_usp") ) then
            return false, "You already have this weapon!"
        end

        for k, v in pairs(ply.items) do
            if ( table.HasValue(v, "Pistols") and cs.shop.Get(ent:GetItemIndex()).category == "Pistols" ) then
                return false, "You already have a weapon in this category!"
            end
        end

        return true
    end,
    onPickup = function(ply, ent)
        ply.items[WEAPON_USP] = cs.shop.Get(WEAPON_USP)
        ply:Give("tfa_pist_usp")

        if ( IsValid(ent) ) then
            ent:Remove()
        end
    end,
    onBuy = function(ply)
        if ( ply:HasWeapon("tfa_pist_usp") ) then
            cs.shop.SpawnDroppedItem(cs.shop.Get(WEAPON_USP), ply:EyePos() + ply:GetAngles():Forward() * 32)
            return
        end

        for k, v in pairs(ply.items) do
            if ( table.HasValue(v, "Pistols") ) then
                cs.shop.SpawnDroppedItem(cs.shop.Get(WEAPON_USP), ply:EyePos() + ply:GetAngles():Forward() * 32)
                return
            end
        end

        ply.items[WEAPON_USP] = cs.shop.Get(WEAPON_USP)
        ply:Give("tfa_pist_usp")
    end,
    onDrop = function(ply)
        if ( ply:HasWeapon("tfa_pist_usp") ) then
            cs.shop.SpawnDroppedItem(cs.shop.Get(WEAPON_USP), ply:EyePos() + ply:GetAngles():Forward() * 32)
            if ( IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "tfa_pist_usp" ) then
                ply:SelectWeapon("tfa_cs_knife")
            end
            ply:StripWeapon("tfa_pist_usp")
            ply.items[WEAPON_USP] = nil
        end
    end,
})

// Rifles
WEAPON_AK47 = cs.shop.Register({
    name = "AK-47",
    model = "models/weapons/w_rif_ak47.mdl",
    category = "Rifles",
    price = 800,
    canBuy = function(ply)
        return ply:Team() == FACTION_TERRORIST
    end,
    canPickup = function(ply, ent)
        if ( ply:HasWeapon("tfa_rif_ak47") ) then
            return false, "You already have this weapon!"
        end

        for k, v in pairs(ply.items) do
            if ( table.HasValue(v, "Rifles") and cs.shop.Get(ent:GetItemIndex()).category == "Rifles" ) then
                return false, "You already have a weapon in this category!"
            end
        end

        return true
    end,
    onPickup = function(ply, ent)
        ply.items[WEAPON_AK47] = cs.shop.Get(WEAPON_AK47)
        ply:Give("tfa_rif_ak47")

        if ( IsValid(ent) ) then
            ent:Remove()
        end
    end,
    onBuy = function(ply)
        if ( ply:HasWeapon("tfa_rif_ak47") ) then
            cs.shop.SpawnDroppedItem(cs.shop.Get(WEAPON_AK47), ply:EyePos() + ply:GetAngles():Forward() * 32)
            return
        end

        for k, v in pairs(ply.items) do
            if ( table.HasValue(v, "Rifles") ) then
                cs.shop.SpawnDroppedItem(cs.shop.Get(WEAPON_AK47), ply:EyePos() + ply:GetAngles():Forward() * 32)
                return
            end
        end

        ply.items[WEAPON_AK47] = cs.shop.Get(WEAPON_AK47)
        ply:Give("tfa_rif_ak47")
    end,
    onDrop = function(ply)
        if ( ply:HasWeapon("tfa_rif_ak47") ) then
            cs.shop.SpawnDroppedItem(cs.shop.Get(WEAPON_AK47), ply:EyePos() + ply:GetAngles():Forward() * 32)
            if ( IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "tfa_rif_ak47" ) then
                ply:SelectWeapon("tfa_cs_knife")
            end
            ply:StripWeapon("tfa_rif_ak47")
            ply.items[WEAPON_AK47] = nil
        end
    end,
})

WEAPON_M4A1 = cs.shop.Register({
    name = "M4A1",
    model = "models/weapons/w_rif_m4a1.mdl",
    category = "Rifles",
    price = 800,
    canBuy = function(ply)
        return ply:Team() == FACTION_CTERRORIST
    end,
    canPickup = function(ply, ent)
        if ( ply:HasWeapon("tfa_rif_m4a1") ) then
            return false, "You already have this weapon!"
        end

        for k, v in pairs(ply.items) do
            if ( table.HasValue(v, "Rifles") and cs.shop.Get(ent:GetItemIndex()).category == "Rifles" ) then
                return false, "You already have a weapon in this category!"
            end
        end

        return true
    end,
    onPickup = function(ply, ent)
        ply.items[WEAPON_M4A1] = cs.shop.Get(WEAPON_M4A1)
        ply:Give("tfa_rif_m4a1")

        if ( IsValid(ent) ) then
            ent:Remove()
        end
    end,
    onBuy = function(ply)
        if ( ply:HasWeapon("tfa_rif_m4a1") ) then
            cs.shop.SpawnDroppedItem(cs.shop.Get(WEAPON_M4A1), ply:EyePos() + ply:GetAngles():Forward() * 32)
            return
        end

        for k, v in pairs(ply.items) do
            if ( table.HasValue(v, "Rifles") ) then
                cs.shop.SpawnDroppedItem(cs.shop.Get(WEAPON_M4A1), ply:EyePos() + ply:GetAngles():Forward() * 32)
                return
            end
        end

        ply.items[WEAPON_M4A1] = cs.shop.Get(WEAPON_M4A1)
        ply:Give("tfa_rif_m4a1")
    end,
    onDrop = function(ply)
        if ( ply:HasWeapon("tfa_rif_m4a1") ) then
            cs.shop.SpawnDroppedItem(cs.shop.Get(WEAPON_M4A1), ply:EyePos() + ply:GetAngles():Forward() * 32)
            if ( IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "tfa_rif_m4a1" ) then
                ply:SelectWeapon("tfa_cs_knife")
            end
            ply:StripWeapon("tfa_rif_m4a1")
            ply.items[WEAPON_M4A1] = nil
        end
    end,
})