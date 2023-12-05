local PANEL = {}

function PANEL:Init()
	if ( IsValid(cs.ui.radial) ) then
		cs.ui.radial:Remove()
	end

    cs.ui.radial = self
    
    self.padding = ScreenScale(16)

    self:SetSize(ScrW(), ScrH())
    self:ParentToHUD()
    self:MakePopup()

    self:SetKeyboardInputEnabled(true)
    self:SetMouseInputEnabled(true)

    local label = self:Add("DLabel")
    label:Dock(BOTTOM)
    label:DockMargin(0, self.padding, 0, self.padding)
    label:SetContentAlignment(5)
    label:SetFont("Font-Elements-ScreenScale8")
    label:SetText("Press Space or Escape to Exit the Menu!")
    label:SizeToContents()

    self.buttons = {}
    
    self.centerX = ScrW() / 2
    self.centerY = ScrH() / 2
    self.radius = self.padding * 8

    self:UpdateButtons()
end

function PANEL:UpdateButtons()
    local numButtons = #self.buttons
    local angleIncrement = 360 / numButtons

    for i, button in ipairs(self.buttons) do
        local angle = ( i - 1 ) * angleIncrement - 90

        button:SizeToContents()
        
        local x = self.centerX + math.cos(math.rad(angle)) * self.radius - button:GetWide() / 2
        local y = self.centerY + math.sin(math.rad(angle)) * self.radius - button:GetTall() / 2

        button:SetPos(x, y)
    end
end

function PANEL:AddButton(text, font, color, callback)
    local button = self:Add("cs.Button")
    button:SetText(text)
    button:SetTextColor(color)
    button:SetTextInset(0, 0)
    button:SetFont(font or "Font-Elements-ScreenScale12")
    button:SetContentAlignment(5)
    button:SizeToContents()
    button.Paint = function()
        // background feels weird
    end
    button.DoClick = function()
        callback()
    end
    
    table.insert(self.buttons, button)
end

function PANEL:Think()
    if ( input.IsKeyDown(KEY_ESCAPE) or input.IsKeyDown(KEY_SPACE) ) then
        self:Remove()
    end
end

function PANEL:Paint(width, height)
    cs.util.DrawFilledCircle(width / 2, height / 2, self.radius, self.radius, ColorAlpha(color_black, 100))
end

vgui.Register("cs.Radial", PANEL, "EditablePanel")

if ( IsValid(cs.ui.radial) ) then
    cs.ui.radial:Remove()
end