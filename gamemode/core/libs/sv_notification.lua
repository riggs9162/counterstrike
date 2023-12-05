cs.notification = cs.notification or {}

function cs.notification.Notify(ply, message, time, color)
    net.Start("cs.Notification.Notify")
        net.WriteString(message)
        net.WriteUInt(time or 4, 8)
        net.WriteColor(color or color_black)
    net.Send(ply)
end