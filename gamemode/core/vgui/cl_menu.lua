local gradientUp = cs.util.GetMaterial("vgui/gradient-u")

local PANEL = {}

function PANEL:Init()
    if ( IsValid(cs.ui.menu) ) then
        cs.ui.menu:Remove()
    end

    cs.ui.menu = self
    
    LocalPlayer():ConCommand("stopsound")
    
    self:SetSize(ScrW() / 1.4, ScrH() / 1.1)
    self:MakePopup()
    self:Center()

    self.title = self:Add("DLabel")
    self.title:Dock(TOP)
    self.title:DockMargin(ScreenScale(16), ScreenScale(8), 0, 0)
    self.title:SetTextColor(color_white)
    self.title:SetText("Garry's Mod")
    self.title:SetFont("Font-Elements-ScreenScale40")
    self.title:SizeToContents()

    self.subTitle = self:Add("DLabel")
    self.subTitle:Dock(TOP)
    self.subTitle:DockMargin(ScreenScale(32), 0, 0, 0)
    self.subTitle:SetTextColor(cs.config["color"])
    self.subTitle:SetText(GAMEMODE.Name)
    self.subTitle:SetFont("Font-Elements-ScreenScale26")
    self.subTitle:SizeToContents()

    self.buttonList = self:Add("DScrollPanel")
    self.buttonList:SetWide(ScrW() / 4)
    self.buttonList:Dock(LEFT)
    self.buttonList:DockMargin(ScreenScale(16), ScreenScale(32), ScreenScale(8), ScreenScale(16))
    self.buttonList.Paint = function(this, width, height)
    end

    local buttons = {
        {
            text = "Play",
            color = nil,
            func = function(this)
                vgui.Create("cs.Factions")

                self:Close()
            end
        },
        {
            text = "Settings",
            color = nil,
            func = function(this)
                cs.notification.Notify("Sorry, this is not a feature currently!")
                --vgui.Create("cs.Settings")

                --self:Close()
            end
        },
        {
            text = "Information",
            color = nil,
            func = function(this)
                vgui.Create("cs.Information")

                self:Close()
            end
        },
        {
            text = "Disconnect",
            color = Color(255, 0, 0),
            func = function(this)
                self:Close(function()
                    RunConsoleCommand("disconnect")
                end)
            end
        },
    }
    for k, v in SortedPairs(buttons) do
        local button = self.buttonList:Add("cs.Button")
        button:SetText(v.text)
        button:SetFont("Font-Elements-ScreenScale16")
        button:SetTextColor(v.color or color_white)
        button:SetTall(ScreenScale(18))
        button:Dock(TOP)
        button.insetColor = v.color or nil
        button.bTextInsetMove = true
        button.DoClick = v.func
    end
end

function PANEL:Close(func)
    self:Remove()

    if ( func ) then
        func()
    end
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

vgui.Register("cs.MainMenu", PANEL, "EditablePanel")

if ( IsValid(cs.ui.menu) ) then
    vgui.Create("cs.MainMenu")
end