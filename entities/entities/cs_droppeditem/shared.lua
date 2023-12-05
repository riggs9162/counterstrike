ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Dropped Item"
ENT.Author = "Riggs"
ENT.Spawnable = false

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "ItemIndex")
end