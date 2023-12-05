local PANEL = {}

function PANEL:Init()
	self.Colour = Color(60, 255, 105, 150)
	self.Ping = 0
	self:SetCursor("hand")
	self:SetTooltip("Left click to open info card. Right click to copy SteamID.")
end

function PANEL:SetPlayer(player)
	self.Colour = team.GetColor(player:Team()) -- Store colour and name micro optomization, other things can be calculated on the go.
	self.Player = player

	self.modelIcon = vgui.Create("SpawnIcon", self)
	self.modelIcon:Dock(LEFT)
	self.modelIcon:SetTall(self:GetTall())
	self.modelIcon:SetModel(player:GetModel(), player:GetSkin())
	self.modelIcon:SetTooltip(false)
	self.modelIcon:SetDisabled(true)

	timer.Simple(0, function()
		if not IsValid(self) then
			return
		end

		local ent = self.modelIcon.Entity

		if IsValid(ent) and IsValid(self.Player) then
			for v,k in pairs(self.Player:GetBodyGroups()) do
				ent:SetBodygroup(k.id, self.Player:GetBodygroup(k.id))
			end
		end
	end)

	function self.modelIcon:PaintOver() -- remove that mouse hover effect
		return false
	end
end

local gradient = Material("vgui/gradient-l")
local outlineCol = Color(190,190,190,240)
local darkCol = Color(30,30,30,200)

function PANEL:Paint(width, height)
	if not ( IsValid(self.Player) ) then
		return
	end

	surface.SetDrawColor(self.Colour)
	surface.SetMaterial(gradient)
	surface.DrawTexturedRect(0, 0, width, height)

	if ( self.Player == LocalPlayer() ) or ( self.Player:GetFriendStatus() == "friend" ) then
		surface.SetDrawColor(255, 255, 255, (50 + math.sin(RealTime() * 2) * 50) * .4)
		surface.DrawRect(0, 0, width, height)
	end

	surface.SetMaterial(gradient)
	surface.SetDrawColor(darkCol)
	surface.DrawTexturedRect(0, 0, width, height)

	surface.SetFont("Font-Elements-ScreenScale10")
	surface.SetTextColor(color_white)

	surface.SetTextPos(65,10)
	surface.DrawText(self.Player:Nick())

	surface.SetTextPos(width-30,10)
	surface.DrawText(self.Player:Ping())

	surface.SetFont("Font-Elements-ScreenScale10")
	surface.SetTextPos(65,30)
	surface.DrawText(team.GetName(self.Player:Team()))
end

function PANEL:OnMousePressed(key)
	if not IsValid(self.Player) then
		return false
	end

	if ( key == MOUSE_RIGHT ) then
		LocalPlayer():Notify("You have copied "..self.Player:Nick().."'s Steam ID.")
		SetClipboardText(self.Player:SteamID())
	else
		if ( IsValid(cs.ui.infoCard) ) then 
			cs.ui.infoCard:Remove() 
		end
		
		cs.ui.infoCard = vgui.Create("cs.PlayerInfoCard")
		cs.ui.infoCard:SetPlayer(self.Player)
	end
end

vgui.Register("cs.ScoreboardCard", PANEL, "DPanel")