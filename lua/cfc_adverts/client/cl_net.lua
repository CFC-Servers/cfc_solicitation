net.Receive( CFCAdverts.HOOK_URL, function()
    chat.Close()
    gui.OpenURL( net.ReadString() )
end )

net.Receive( CFCAdverts.HOOK_IGNORE_GROUP, function()
    if not CFCNotifications then return end

    local groupCount = net.ReadInt( 10 )
    local permIgnores = CFCNotifications._permIgnores
    local tempIgnores = CFCNotifications._tempIgnores

    for i = 1, groupCount do
        local notifID = net.ReadString()

        CFCNotifications._removePopupByNotificationID( notifID )

        permIgnores[notifID] = true
        tempIgnores[notifID] = nil
    end

    CFCNotifications.saveIgnores()
    CFCNotifications._reloadIgnoredPanels()
end )
