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

    local groupName = advert.groupName
    local hasButtons = false

    if advert.type == "Buttons" then
        hasButtons = true

        for i, button in pairs( advert.buttons ) do
            notif:AddButton( button.text, button.buttonColor, i )
        end
    end

    if groupName then
        if hasButtons then
            notif:NewButtonRow()
        end

        notif:AddButton( string.format( CFCAdverts.IGNORE_GROUP_TEXT, groupName ), CFCAdverts.colors.ignoreGroup, groupName )

        hasButtons = true
    end

    if not hasButtons then return end

    function notif:OnButtonPressed( ply, index, ... )
        if index == groupName then
            local group = CFCAdverts.GROUPS[groupName]

            if not group then return end

            local groupCount = group.count or 0

            if groupCount == 0 then return end

            net.Start( CFCAdverts.HOOK_IGNORE_GROUP )
            net.WriteInt( groupCount, 10 )

            for i = 1, groupCount do
                net.WriteString( group[i] )
            end

            net.Send( ply )

            return
        end

        local button = advert.buttons[index]

        button.func( ply, ... )
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

    timer.Create( CFCAdverts._timerName, CFCAdverts.advertGap:GetFloat(), 0, function()
        local plys = player.GetHumans()

        if table.IsEmpty( plys ) then return end

        local advertName = CFCAdverts._advertKeys[CFCAdverts._curAdvert] or ""
        local advert = CFCAdverts.adverts[advertName]

        if not advert or table.Count( CFCAdverts.adverts ) ~= CFCAdverts._advertCount then
            timer.Remove( CFCAdverts._timerName ) -- Redundant, but just in case
            CFCAdverts.updateAdverts()
            return
        end

        local effectiveType = advert.groupName and "Buttons" or advert.type -- Promote type to Buttons if advert is part of a group
        local notifName = CFCAdverts.HOOK_BASE .. "_" .. advertName
        local notif = CFCNotifications.new( notifName, effectiveType, true )

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

cvars.AddChangeCallback( "cfc_adverts_gap", function( _, old, new )
    if old == new then return end

    timer.Create( CFCAdverts.HOOK_BASE .. "_UpdateAdverts", 1, 1, CFCAdverts.updateAdverts )
end )
