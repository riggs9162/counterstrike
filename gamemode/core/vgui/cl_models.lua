local gradientUp = cs.util.GetMaterial("vgui/gradient-u")

local PANEL = {}

function PANEL:Init()
    if ( IsValid(cs.ui.models) ) then
        cs.ui.models:Remove()
    end

    cs.ui.models = self
    
    self:SetSize(ScrW() / 1.4, ScrH() / 1.1)
    self:MakePopup()
    self:Center()

    self.title = self:Add("DLabel")
    self.title:Dock(TOP)
    self.title:DockMargin(ScreenScale(16), ScreenScale(8), 0, 0)
    self.title:SetTextColor(color_white)
    self.title:SetText("Models")
    self.title:SetFont("Font-Elements-ScreenScale40")
    self.title:SizeToContents()

    self.container = self:Add("DPanel")
    self.container:Dock(FILL)
    self.container:DockMargin(ScreenScale(16), ScreenScale(8), ScreenScale(16), ScreenScale(32))
    self.container.Paint = function(this, width, height)
        surface.SetDrawColor(0, 0, 0, 80)
        surface.DrawRect(0, 0, width, height)
    end

    local models = self.container:Add("DScrollPanel")
    models:SetWide(ScrW() / 3)
    models:Dock(LEFT)

    timer.Simple(1, function()
        for k, v in pairs(cs.faction.list[LocalPlayer():Team()].models) do
            local button = models:Add("cs.Button")
            button:SetText(k)
            button:Dock(TOP)
            button.DoClick = function(this)
                net.Start("cs.SelectModel")
                    net.WriteString(v)
                net.SendToServer()
                
                net.Start("cs.Play")
                net.SendToServer()

                self:Close()
            end

            local modelDescription = button:Add("RichText")
            modelDescription:SetText(v.description or "Undefined Description!")
            modelDescription:Dock(FILL)
            modelDescription:DockMargin(ScreenScale(8), ScreenScale(96), ScreenScale(8), ScreenScale(8))
            modelDescription:SetVerticalScrollbarEnabled(false)
            modelDescription:SetMouseInputEnabled(false)
            modelDescription.Think = function(this)
                this:SetFontInternal("Font-Elements-ScreenScale12")
            end
        end
    end)
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

vgui.Register("cs.Models", PANEL, "EditablePanel")

if ( IsValid(cs.ui.models) ) then
    cs.ui.models:Remove()
end