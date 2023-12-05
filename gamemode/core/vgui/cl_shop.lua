local PANEL = {}

function PANEL:Init()
    if ( IsValid(cs.ui.shop) ) then
        cs.ui.shop:Remove()
    end

    cs.ui.shop = self

    self.padding = ScreenScale(16)

    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:Center()

    self:DockPadding(self.padding, self.padding, self.padding, self.padding)

    local label = self:Add("DLabel")
    label:Dock(TOP)
    label:DockMargin(0, 0, 0, self.padding * 0.5)
    label:SetTextColor(cs.config["color"])
    label:SetText("Shop")
    label:SetFont("Font-Elements-ScreenScale30")
    label:SizeToContents()

    self.categoriesScroller = self:Add("EditablePanel")
    self.categoriesScroller:Dock(LEFT)
    self.categoriesScroller:SetWide(self:GetWide() * 0.35 - self.padding * 2)

    self:PopulateCategories()
end

function PANEL:PopulateCategories()
    self.categoriesScroller:Clear()

    self.categories = {}

    for k, v in ipairs(cs.shop.GetAll()) do
        if ( table.HasValue(self.categories, v.category) ) then
            continue
        end

        if ( v.canBuy and v.canBuy(LocalPlayer()) != true ) then
            continue
        end

        table.insert(self.categories, v.category)
    end

    for k, v in ipairs(self.categories) do
        local button = self.categoriesScroller:Add("cs.Button")
        button:Dock(TOP)
        button:SetText(k.." "..v)
        button:SetFont("Font-Elements-ScreenScale14")
        button.DoClick = function(this)
            self.category = v

            self:PopulateItems()
        end
    end

    local button = self.categoriesScroller:Add("cs.Button")
    button:Dock(BOTTOM)
    button:SetText("0 Cancel")
    button:SetFont("Font-Elements-ScreenScale14")
    button.DoClick = function(this)
        self:Remove()
    end
end

function PANEL:PopulateItems()
    self.categoriesScroller:Clear()

    self.items = {}

    for k, v in ipairs(cs.shop.GetAll()) do
        if ( string.lower(v.category) != string.lower(self.category) ) then
            continue
        end

        if ( v.canBuy and v.canBuy(LocalPlayer()) != true ) then
            continue
        end

        self.items[#self.items + 1] = v
    end

    for k, v in ipairs(self.items) do
        local button = self.categoriesScroller:Add("cs.Button")
        button:Dock(TOP)
        button:SetText(k.." "..v.name)
        button:SetFont("Font-Elements-ScreenScale14")
        button.DoClick = function(this)
            net.Start("cs.ShopBuyItem")
                net.WriteUInt(v.index, 8)
            net.SendToServer()
        end
    end

    local button = self.categoriesScroller:Add("cs.Button")
    button:Dock(BOTTOM)
    button:SetText("0 Cancel")
    button:SetFont("Font-Elements-ScreenScale14")
    button.DoClick = function(this)
        self.category = nil

        self:PopulateCategories()
    end
end

local backgroundAlpha = 0
function PANEL:Paint(width, height)
    local frameTime = FrameTime()

    if ( self.bMoving or #cs.ui.notificationTab.notifs >= 1 ) then
        backgroundAlpha = Lerp(frameTime * 4, backgroundAlpha, 0)
    else
        backgroundAlpha = Lerp(frameTime * 4, backgroundAlpha, 250)
    end

    surface.SetDrawColor(0, 0, 0, backgroundAlpha)
    surface.DrawRect(0, 0, width, height)

    cs.util.DrawBlur(self, backgroundAlpha / 100, nil, backgroundAlpha)
end

vgui.Register("cs.Shop", PANEL, "EditablePanel")

if ( IsValid(cs.ui.shop) ) then
    cs.ui.shop:Remove()

    timer.Simple(0, function()
        cs.util.OpenVGUI("cs.Shop")
    end)
end