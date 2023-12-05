net.Receive("cs.Notification.Notify", function()
    local message = net.ReadString()
    local time = net.ReadUInt(8)
    local color = net.ReadColor()

    cs.notification.Notify(message, time, color)
end)

net.Receive("cs.OpenVGUI", function()
    local ui = net.ReadString()

    vgui.Create(ui)
end)