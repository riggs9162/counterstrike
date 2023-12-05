local gradientRight = cs.util.GetMaterial("vgui/gradient-l")

local PANEL = {}

function PANEL:Init()
    if ( IsValid( cs.ui.notificationTab ) ) then
        cs.ui.notificationTab:Remove()
    end

    cs.ui.notificationTab = self

    self:SetSize(ScrW() / 3, ScrH() / 3)
    self:SetPos(ScrW() - ( ScrW() / 3 ), 0)

    self.notifs = {}
end

function PANEL:AddNotification(message, finish, color)
    finish = finish or string.len(message) * 0.15

    local thisW, thisH = self:GetSize()
    local thisX, thisY = self:GetPos()

    if ( #self.notifs >= 3 ) then
        local panel = self.notifs[1]
        table.remove(self.notifs, 1)
        panel:Remove()

        self:Repost()
    end

    local nextPos = #self.notifs + 1

    local size = thisH / 8

    local panel = self:Add("DLabel")
    panel:SetTextColor(color_white)
    panel:SetFont("Font-Elements-ScreenScale10")
    panel:SetText("  "..message)
    panel:SetSize(thisW, size)
    panel:SetPos(15, -size)
    panel:MoveTo(15, size * ( nextPos - 1 ), 2, 0, 0.1)
    panel.removeTime = CurTime() + finish

    function panel:Paint(w, h)
        cs.util.DrawBlur(self, 1)

		surface.SetDrawColor(ColorAlpha(color or color_black, 190))
		surface.SetMaterial(gradientRight)
		surface.DrawTexturedRect(0, 0, w, h)
    end

    surface.PlaySound(cs.config["notificationSound"])

    self.notifs[nextPos] = panel
end

function PANEL:Repost()
    local thisW, thisH = self:GetSize()
    local size = thisH / 8
    for i, v in ipairs(self.notifs) do
        v:MoveTo(15, size * ( i - 1 ), 2, 0, 0.1)
    end
end

function PANEL:Think()
    local size = self:GetTall() / 8

    for i = 1, 8 do
        local panel = self.notifs[i]
        
        if not ( panel ) then
            continue
        end

        if ( panel.removeTime < CurTime() ) then
            table.remove(self.notifs, i)
            panel:Remove()
            self:Repost()
        end
    end

    self:MoveToFront()
end

vgui.Register("cs.NotificationTab", PANEL, "EditablePanel")

if ( IsValid(cs.ui.notificationTab) ) then
    cs.ui.notificationTab:Remove()

    vgui.Create("cs.NotificationTab")
end