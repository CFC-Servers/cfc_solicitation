CFCAdverts = CFCAdverts or {}

local advertCount = 0
local curAdvert = 1
local advertKeys = {}
local timerName = CFCAdverts.HOOK_BASE .. "_SendAdvert"

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
    advertCount = table.Count( CFCAdverts.adverts )
    advertKeys = table.GetKeys( CFCAdverts.adverts )

    if advertCount == 0 then
        timer.Simple( 30, CFCAdverts.updateAdverts ) -- Prevent CFC Adverts from dying forever if the list goes empty
        return
    end

    curAdvert = math.min( curAdvert, advertCount )
    local advertGap = CFCAdverts.cycleTime / advertCount

    timer.Create( timerName, advertGap, 0, function()
        local plys = player.GetHumans()

        if table.IsEmpty( plys ) then return end

        local advertName = advertKeys[curAdvert] or ""
        local advert = CFCAdverts.adverts[advertName] or {}

        if table.IsEmpty( advert ) or table.Count( CFCAdverts.adverts ) ~= advertCount then
            timer.Remove( timerName ) -- Redundant, but just in case
            CFCAdverts.updateAdverts()
            return
        end

        local notifName = CFCAdverts.HOOK_BASE .. "_" .. advertName
        CFCNotifications.new( notifName, advert.type, true )
        local notif = CFCNotifications.get( notifName )

        buildNotif( notif, advert )

        notif:Send( plys )

        curAdvert = curAdvert % advertCount + 1
    end )
end

-- Start adverting once the server is fully loaded or done changing levels
hook.Add( "InitPostEntity", CFCAdverts.HOOK_BASE .. "_StartAdverting", function()
    timer.Remove( timerName )
    timer.Simple( 30, CFCAdverts.updateAdverts )
end )
