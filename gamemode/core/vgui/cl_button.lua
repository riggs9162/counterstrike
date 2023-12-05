DEFINE_BASECLASS("DButton")

local PANEL = {}

function PANEL:Init()
    self.textInset = ScreenScale(6)
    self:SetContentAlignment(4)
    self:SetTextColor(Color(150, 150, 150))
    self:SetFont("Font-Elements-ScreenScale10")
    self:SetTextInset(self.textInset, 0)
    self:SizeToContents()
end

function PANEL:SetTextColorInternal(color)
    BaseClass.SetTextColor(self, color)
end

function PANEL:SetTextColor(color)
    BaseClass.SetTextColor(self, color)
    self.textColor = color
end

function PANEL:SetFont(font)
    BaseClass.SetFont(self, font)
    self:SizeToContents()
end

function PANEL:OnCursorEntered()
    if ( self:GetDisabled() ) then
        return
    end

    local textColor = self:GetTextColor()
    self:SetTextColorInternal(Color(textColor.r + 100, textColor.g + 100, textColor.b + 100))

    LocalPlayer():EmitSound("ui/buttonrollover.wav", nil, 100, 0.4)
end

function PANEL:OnCursorExited()
    if ( self:GetDisabled() ) then
        return
    end

    local textColor = self.textColor
    self:SetTextColorInternal(textColor)

    LocalPlayer():EmitSound("ui/buttonrollover.wav", nil, 80, 0.1)
end

function PANEL:OnMousePressed(key)
    BaseClass.OnMousePressed(self, key)

    if ( self:GetDisabled() ) then
        return
    end

    // this is for lerping in inventory
    self.bPressed = true
    timer.Simple(0.1, function()
        if ( IsValid(self) ) then
            self.bPressed = nil
        end
    end)

    LocalPlayer():EmitSound("ui/buttonclickrelease.wav", nil, 100, 0.5)
end

function PANEL:Think()
    if not ( self.bTextInsetMove ) then
        return
    end

    local ft = FrameTime()

    if ( self:IsHovered() ) then
        self.textInsetLerp = Lerp(ft * 10, self.textInsetLerp or self.textInset, self.textInset + self.textInset)
    else
        self.textInsetLerp = Lerp(ft * 10, self.textInsetLerp or self.textInset, self.textInset)
    end

    self:SetTextInset(self.textInsetLerp, 0)
end

local defaultAlpha = 80
function PANEL:Paint(width, height)
    local ft = FrameTime()

    if not ( self.defaultWidthBar ) then
        self.defaultWidthBar = self.textInset * 1.5
    end

    if ( self:IsHovered() ) then
        self.alpha = Lerp(ft * 10, self.alpha or defaultAlpha, defaultAlpha)

        if ( self.bTextInsetMove ) then
            self.widthBar = Lerp(ft * 10, self.widthBar or self.defaultWidthBar, self.defaultWidthBar)
        end
    else
        self.alpha = Lerp(ft * 10, self.alpha or defaultAlpha, 0)
        
        if ( self.bTextInsetMove ) then
            self.widthBar = Lerp(ft * 10, self.widthBar or self.defaultWidthBar, 0)
        end
    end

    surface.SetDrawColor(ColorAlpha(color_black, self.alpha))
    surface.DrawRect(0, 0, width, height)

    if ( self.bTextInsetMove ) then
        surface.SetDrawColor(ColorAlpha(self.insetColor or cs.config["color"], self.alpha * 2))
        surface.DrawRect(0, 0, self.widthBar, height)
    end

    if ( self.PaintOver ) then
        self.PaintOver(self, width, height)
    end
end

vgui.Register("cs.Button", PANEL, "DButton")