local COLOR_GREY = Color( 150, 150, 150, 255 )
local COLOR_DARK_GREY = Color( 41, 41, 41, 255 )
local COLOR_HIGHLIGHT = Color( 255, 230, 75, 255 )

net.Receive( CFCAdverts.HOOK_URL, function()
    chat.Close()
    gui.OpenURL( net.ReadString() )
end )

net.Receive( CFCAdverts.HOOK_IGNORE_GROUP, function()
    if not CFCNotifications then return end

    local groupCount = net.ReadInt( 10 )
    local groupName = net.ReadString()
    local permIgnores = CFCNotifications._permIgnores
    local tempIgnores = CFCNotifications._tempIgnores

    for _ = 1, groupCount do
        local notifID = net.ReadString()

        CFCNotifications._removePopupByNotificationID( notifID )

        permIgnores[notifID] = true
        tempIgnores[notifID] = nil
    end

    CFCNotifications.saveIgnores()
    CFCNotifications._reloadIgnoredPanels()

    chat.AddText(
        COLOR_DARK_GREY, "[",
        COLOR_GREY, "Notifications",
        COLOR_DARK_GREY, "] ",
        color_white, "You will never see notifications from the ",
        COLOR_HIGHLIGHT, groupName,
        color_white, " group again."
    )
end )
