util.AddNetworkString("cs.Notification.Notify")
util.AddNetworkString("cs.OpenVGUI")
util.AddNetworkString("cs.Play")
util.AddNetworkString("cs.SelectFaction")
util.AddNetworkString("cs.SelectModel")
util.AddNetworkString("cs.ShopBuyItem")

net.Receive("cs.Play", function(len, ply)
    ply:Kill()
end)

net.Receive("cs.SelectFaction", function(len, ply)
    local uniqueID = net.ReadUInt(8)
    ply:SetTeam(uniqueID)
    ply:SetNWInt("faction", uniqueID)

    cs.util.OpenVGUI("cs.Models", ply)
end)

net.Receive("cs.SelectModel", function(len, ply)
    local model = net.ReadString()
    ply:SetNWInt("model", model)
end)

net.Receive("cs.ShopBuyItem", function(len, ply)
    local itemIndex = net.ReadUInt(8)
    local data = cs.shop.Get(itemIndex)
    if not ( data ) then
        error("Invalid Item")
    end

    if ( data.onBuy ) then
        data.onBuy(ply)
    end

    cs.notification.Notify(ply, "Bought Item "..data.name)
end)