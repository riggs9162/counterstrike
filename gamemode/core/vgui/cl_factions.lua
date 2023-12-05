local gradientUp = cs.util.GetMaterial("vgui/gradient-u")

local PANEL = {}

function PANEL:Init()
    if ( IsValid(cs.ui.factions) ) then
        cs.ui.factions:Remove()
    end

    cs.ui.factions = self
    
    self:SetSize(ScrW() / 1.4, ScrH() / 1.1)
    self:MakePopup()
    self:Center()

    self.title = self:Add("DLabel")
    self.title:Dock(TOP)
    self.title:DockMargin(ScreenScale(16), ScreenScale(8), 0, 0)
    self.title:SetTextColor(color_white)
    self.title:SetText("Factions")
    self.title:SetFont("Font-Elements-ScreenScale40")
    self.title:SizeToContents()

    self.returnButton = self:Add("cs.Button")
    self.returnButton:SetText("Return")
    self.returnButton:SetFont("Font-Elements-ScreenScale18")
    self.returnButton:SetContentAlignment(4)
    self.returnButton:SetSize(self:GetWide(), ScreenScale(20))
    self.returnButton:SetPos(0, self:GetTall() - self.returnButton:GetTall())
    self.returnButton.DoClick = function(this)
        vgui.Create("cs.MainMenu")

        self:Close()
    end

    self.container = self:Add("DPanel")
    self.container:Dock(FILL)
    self.container:DockMargin(ScreenScale(16), ScreenScale(8), ScreenScale(16), ScreenScale(32))
    self.container.Paint = function(this, width, height)
        surface.SetDrawColor(0, 0, 0, 80)
        surface.DrawRect(0, 0, width, height)
    end

    for k, v in pairs(cs.faction.stored) do
        local button = self.container:Add("cs.Button")
        button:SetText(v.name)
        button:SetWide(self:GetWide() / 2 - ScreenScale(16) * 2 + ScreenScale(16))
        button:Dock(LEFT)
        button.DoClick = function(this)
            net.Start("cs.SelectFaction")
                net.WriteUInt(k, 8)
            net.SendToServer()

            self:Close()
        end

        local factionDescription = button:Add("RichText")
        factionDescription:SetText(v.description or "Undefined Description!")
        factionDescription:Dock(FILL)
        factionDescription:DockMargin(ScreenScale(8), ScreenScale(96), ScreenScale(8), ScreenScale(8))
        factionDescription:SetVerticalScrollbarEnabled(false)
        factionDescription:SetMouseInputEnabled(false)
        factionDescription.Think = function(this)
            this:SetFontInternal("Font-Elements-ScreenScale12")
        end
    end
end

function PANEL:Close()
    self:Remove()
end

local backgroundAlpha = 0
function PANEL:Paint(width, height)
    if ( self.bMoving or #cs.ui.notificationTab.notifs >= 1 ) then
        backgroundAlpha = Lerp(0.1, backgroundAlpha, 0)
    else
        backgroundAlpha = Lerp(0.005, backgroundAlpha, 150)
    end

    surface.SetDrawColor(0, 0, 0, backgroundAlpha)
    surface.DrawRect(0, 0, width, height)

    cs.util.DrawBlur(self, backgroundAlpha / 100, nil, backgroundAlpha)
end

vgui.Register("cs.Factions", PANEL, "EditablePanel")

if ( IsValid(cs.ui.factions) ) then
    cs.ui.factions:Remove()
end