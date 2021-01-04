CFCAdverts = CFCAdverts or {}

CFCAdverts._advertCount = 0
CFCAdverts._curAdvert = 1
CFCAdverts._advertKeys = {}
CFCAdverts._timerName = CFCAdverts.HOOK_BASE .. "_SendAdvert"

local function buildNotif( notif, advert )
    notif:SetTitle( advert.title )
    notif:SetText( advert.text )
    notif:SetTextColor( advert.textColor )
    notif:SetDisplayTime( advert.displayTime )
    notif:SetPriority( advert.priority )
    notif:SetCloseable( advert.closeable )
    notif:SetIgnoreable( advert.ignoreable )
    notif:SetTimed( advert.timed )

    if advert.type == "Buttons" then
        for i, button in pairs( advert.buttons ) do
            notif:AddButton( button.text, button.buttonColor, i )
        end

        function notif:OnButtonPressed( ply, index, ... )
            local button = advert.buttons[index]

            button.func( ply, arg )

            if not button.closeOnPress then return end

            notif:RemovePopup( notif:GetCallingPopupID(), ply )
        end
    end
end

function CFCAdverts.updateAdverts()
    CFCAdverts._advertCount = table.Count( CFCAdverts.adverts )
    CFCAdverts._advertKeys = table.GetKeys( CFCAdverts.adverts )

    if CFCAdverts._advertCount == 0 then
        timer.Simple( 30, CFCAdverts.updateAdverts ) -- Prevent CFC Adverts from dying forever if the list goes empty
        return
    end

    CFCAdverts._curAdvert = math.min( CFCAdverts._curAdvert, CFCAdverts._advertCount )
    local advertGap = CFCAdverts.cycleTime / CFCAdverts._advertCount

    timer.Create( CFCAdverts._timerName, advertGap, 0, function()
        local plys = player.GetHumans()

        if table.IsEmpty( plys ) then return end

        local advertName = CFCAdverts._advertKeys[CFCAdverts._curAdvert] or ""
        local advert = CFCAdverts.adverts[advertName] or {}

        if table.IsEmpty( advert ) or table.Count( CFCAdverts.adverts ) ~= CFCAdverts._advertCount then
            timer.Remove( CFCAdverts._timerName ) -- Redundant, but just in case
            CFCAdverts.updateAdverts()
            return
        end

        local notifName = CFCAdverts.HOOK_BASE .. "_" .. advertName
        CFCNotifications.new( notifName, advert.type, true )
        local notif = CFCNotifications.get( notifName )

        buildNotif( notif, advert )

        notif:Send( plys )

        CFCAdverts._curAdvert = CFCAdverts._curAdvert % CFCAdverts._advertCount + 1
    end )
end

-- Start adverting once the server is fully loaded or done changing levels
hook.Add( "InitPostEntity", CFCAdverts.HOOK_BASE .. "_StartAdverting", function()
    timer.Remove( CFCAdverts._timerName )
    timer.Simple( 30, CFCAdverts.updateAdverts )
end )
