cs.notification = cs.notification or {}

function cs.notification.Notify(message, time, color)
    if ( IsValid(cs.ui.notificationTab) ) then
        cs.ui.notificationTab:AddNotification(message, time, color)
    end
end