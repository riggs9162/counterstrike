local gradientUp = cs.util.GetMaterial("vgui/gradient-u")
local gradient = cs.util.GetMaterial("vgui/gradient-d")

local PANEL = {}

function PANEL:Init()
    if ( IsValid(cs.ui.settings) ) then
        cs.ui.settings:Remove()
    end

    cs.ui.settings = self
    
    self:SetSize(ScrW() / 1.4, ScrH() / 1.1)
    self:MakePopup()
    self:Center()

    self.title = self:Add("DLabel")
    self.title:Dock(TOP)
    self.title:DockMargin(ScreenScale(16), ScreenScale(8), 0, 0)
    self.title:SetTextColor(color_white)
    self.title:SetText("Settings")
    self.title:SetFont("Font-Elements-ScreenScale40")
    self.title:SizeToContents()

    self.returnButton = self:Add("cs.Button")
    self.returnButton:SetText("Return")
    self.returnButton:SetFont("Font-Elements-ScreenScale18")
    self.returnButton:SetContentAlignment(4)
    self.returnButton:SetSize(self:GetWide() / 1.25, ScreenScale(20))
    self.returnButton:SetPos(0, self:GetTall() - self.returnButton:GetTall())
    self.returnButton.DoClick = function(this)
        cs.ui.menu:Show()

        self:Close()
    end

    self.resetButton = self:Add("cs.Button")
    self.resetButton:SetText("Reset")
    self.resetButton:SetFont("Font-Elements-ScreenScale18")
    self.resetButton:SetContentAlignment(6)
    self.resetButton:SetSize(self:GetWide() - self.returnButton:GetWide(), ScreenScale(20))
    self.resetButton:SetPos(self:GetWide() - self.resetButton:GetWide(), self:GetTall() - self.resetButton:GetTall())
    self.resetButton.DoClick = function(this)
    end

    self.container = self:Add("DPanel")
    self.container:Dock(FILL)
    self.container:DockMargin(ScreenScale(16), ScreenScale(8), ScreenScale(16), ScreenScale(32))
    self.container.Paint = function(this, width, height)
        surface.SetDrawColor(0, 0, 0, 80)
        surface.DrawRect(0, 0, width, height)
    end
end

function PANEL:Close()
    self:Remove()
end

local backgroundAlpha = 0
function PANEL:Paint(width, height)
    surface.SetDrawColor(ColorAlpha(color_black, backgroundAlpha))
    surface.SetMaterial(gradientUp)
    surface.DrawTexturedRect(0, 0, width, height)

    if ( self.bMoving or #cs.ui.notificationTab.notifs >= 1 ) then
        backgroundAlpha = Lerp(0.1, backgroundAlpha, 0)
    else
        backgroundAlpha = Lerp(0.005, backgroundAlpha, 200)
    end

    surface.SetDrawColor(0, 0, 0, backgroundAlpha)
    surface.DrawRect(0, 0, width, height)

    cs.util.DrawBlur(self, backgroundAlpha / 100, nil, backgroundAlpha)
end

vgui.Register("cs.Settings", PANEL, "EditablePanel")

if ( IsValid(cs.ui.settings) ) then
    cs.ui.settings:Remove()
end