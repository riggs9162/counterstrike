local PANEL = {}

local nextSG = 0
local quickTools = {
	{
		name = "Steam Profile",
		onRun = function(ply, steamid)
			gui.OpenURL("http://steamcommunity.com/profiles/"..ply:SteamID64())
		end
	},
	{
		name = "Copy Steam ID",
		onRun = function(ply, steamid)
			SetClipboardText(steamid)
			LocalPlayer():Notify("Copied SteamID.")
		end
	},
}

local adminQuickTools = {
	{
		name = "Goto",
		onRun = function(ply, steamid)
			LocalPlayer():ConCommand("say !goto "..steamid)
		end
	},
	{
		name = "Bring",
		icon = "icon16/arrow_inout.png",
		onRun = function(ply, steamid)
			LocalPlayer():ConCommand("say !bring "..steamid)
		end
	},
	{
		name = "Respawn",
		onRun = function(ply, steamid)
			LocalPlayer():ConCommand("say !respawn "..steamid)
		end
	},
	{
		name = "Set Team",
		onRun = function(ply, steamid)
			local teams = DermaMenu()
			
			for k, v in pairs(cs.faction.stored) do
				teams:AddOption(v.name, function()
					LocalPlayer():ConCommand("say /setteam "..steamid.." "..k)
				end)
			end

			teams:Open()
		end
	},
}

function PANEL:Init()
	self:Hide()

	timer.Simple(0, function() -- Time to allow SetPlayer to catch up
		if not IsValid(self) then
			return
		end
		
		self:Show()
		self:SetSize(ScrW() / 3, ScrH() / 2)
		self:Center()
		self:SetTitle("Player Information")
		self:MakePopup()

		-- 3d model
		self.model = vgui.Create("DModelPanel", self)
		self.model:Dock(RIGHT)
		self.model:SetWide(self:GetWide() / 2)
		self.model:SetFOV(45)
		self.model:SetModel(self.Player:GetModel(), self.Player:GetSkin())
		self.model:MoveToBack()
		self.model:SetCursor("arrow")
		function self.model:LayoutEntity(ent) 
			ent:SetAngles(Angle(0, 45, 0))
		end
		
		timer.Simple(0, function()
			if not IsValid(self.model) then
				return
			end

			local ent = self.model.Entity

			if IsValid(ent) and IsValid(self.Player) then
				for v,k in pairs(self.Player:GetBodyGroups()) do
					ent:SetBodygroup(k.id, self.Player:GetBodygroup(k.id))
				end
			end
		end)

		self.avatar = vgui.Create("AvatarImage", self)
		self.avatar:SetSize(70, 70)
		self.avatar:SetPos(10, 30)
		self.avatar:SetPlayer(self.Player, 64)

		self.name = vgui.Create("DLabel", self)
		self.name:SetFont("Font-Elements25")
		self.name:SetText(self.Player:Nick())
		self.name:SetTextColor(color_white)
		self.name:SizeToContents()
		self.name:SetPos(86,30)

		self.teamName = vgui.Create("DLabel", self)
		self.teamName:SetFont("Font-Elements25")
		self.teamName:SetText(team.GetName(self.Player:Team()))
		self.teamName:SetTextColor(team.GetColor(self.Player:Team()))
		self.teamName:SizeToContents()
		self.teamName:SetPos(86,60)

		if ( LocalPlayer():IsAdmin() ) then
			self.adminTools = vgui.Create("DCollapsibleCategory", self)
			self.adminTools:Dock(BOTTOM)
			self.adminTools:SetTall(self:GetTall() / 3)
			self.adminTools:SetExpanded(0)
			self.adminTools:SetLabel("Admin tools (click to expand)")

			self.adminToolsLayout = vgui.Create("DIconLayout", self.adminTools)
			self.adminToolsLayout:Dock(FILL)
		
			for k, v in pairs(adminQuickTools) do
				local action = self.adminToolsLayout:Add("cs.Button")
				action:SetSize(125, 30)
				action:SetFont("Font-Elements-ScreenScale8")
				action:SetText(v.name)
				action:SetContentAlignment(5)
				action:SizeToContents()

				action.runFunc = v.onRun
				local target = self.Player
				function action:DoClick()
					if not ( IsValid(target) ) then
						LocalPlayer():Notify("This player has disconnected.")
						return
					end

					self.runFunc(target, target:SteamID())
				end
			end
		end
		
		self.tools = vgui.Create("DCollapsibleCategory", self)
		self.tools:Dock(BOTTOM)
		self.tools:SetTall(self:GetTall() / 3)
		self.tools:SetExpanded(0)
		self.tools:SetLabel("Tools (click to expand)")

		self.toolsLayout = vgui.Create("DIconLayout", self.tools)
		self.toolsLayout:Dock(FILL)
	
		for k, v in pairs(quickTools) do
			local action = self.toolsLayout:Add("cs.Button")
			action:SetFont("Font-Elements-ScreenScale8")
			action:SetText(v.name)
			action:SetContentAlignment(5)
			action:SizeToContents()

			action.runFunc = v.onRun
			local target = self.Player
			function action:DoClick()
				if not ( IsValid(target) ) then
					LocalPlayer():Notify("This player has disconnected.")
					return
				end

				self.runFunc(target, target:SteamID())
			end
		end
	end)
end

function PANEL:SetPlayer(player)
	self.Player = player
end

vgui.Register("cs.PlayerInfoCard", PANEL, "DFrame")