local PANEL = {}

function PANEL:Init()
	if ( IsValid(cs.ui.scoreboard) ) then
		cs.ui.scoreboard:Remove()
	end

	cs.ui.scoreboard = self

	self:SetSize(ScrW() / 2, ScrH() / 1.2)
	self:Center()
	self:SetTitle("Scoreboard")
	self:ShowCloseButton(false)
	self:SetDraggable(false)
	self:MakePopup()
	self:MoveToFront()

	self.scrollPanel = vgui.Create("DScrollPanel", self)
	self.scrollPanel:Dock(FILL)

	local playerList = player.GetAll()
	table.sort(playerList, function(a, b)
		return a:Team() > b:Team()
	end)
	
	for k, v in pairs(playerList) do
		local playerCard = self.scrollPanel:Add("cs.ScoreboardCard")
		playerCard:SetTall(ScreenScale(20))
		playerCard:Dock(TOP)
		playerCard:SetPlayer(v)
	end
end

vgui.Register("cs.Scoreboard", PANEL, "DFrame")

if ( IsValid(cs.ui.scoreboard) ) then
	cs.ui.scoreboard:Remove()
end