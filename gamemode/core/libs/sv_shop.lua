cs.shop = cs.shop or {}

function cs.shop.SpawnDroppedItem(itemData, pos)
    local item = ents.Create("cs_droppeditem")

    item:SetModel(itemData.model)
    item:SetItemIndex(itemData.index)

    item:PhysicsInit(SOLID_VPHYSICS) 
    item:SetSolid(SOLID_VPHYSICS)
    item:SetUseType(SIMPLE_USE)

    item:SetPos(pos)
    item:Spawn()

    local physObj = item:GetPhysicsObject()

    if ( IsValid(physObj) ) then
        physObj:EnableMotion(true)
        physObj:Wake()
    end

    return item
end