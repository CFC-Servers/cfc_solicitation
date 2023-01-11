CFCAdverts = CFCAdverts or {}

CFCAdverts.HOOK_BASE = "CFC_Adverts"
CFCAdverts.HOOK_URL = CFCAdverts.HOOK_BASE .. "_OpenURL"
CFCAdverts.HOOK_IGNORE_GROUP = CFCAdverts.HOOK_BASE .. "_IgnoreGroup"
CFCAdverts.IGNORE_GROUP_TEXT = "Block all '%s' notifs"

if CLIENT then
    include( "cfc_adverts/client/cl_net.lua" )
    return
end

CFCAdverts.GROUPS = {}

util.AddNetworkString( CFCAdverts.HOOK_URL )
util.AddNetworkString( CFCAdverts.HOOK_IGNORE_GROUP )

CFCAdverts.advertGap = CreateConVar( "cfc_adverts_gap", 120, FCVAR_NONE, "The time in seconds between adverts (default 120)", 1, 50000 )

-- CONFIG:
CFCAdverts.colors = {
    cfcInfoBlue = Color( 0, 168, 243 ),
    lavender = Color( 155, 145, 255 ),
    softBlue = Color( 125, 165, 255 ),
    paleBlue = Color( 200, 220, 245 ),
    linkBlue = Color( 120, 220, 255 ),
    ignoreGroup = Color( 255, 145, 80 ),
}
CFCAdverts.adverts = {
    --[[          Default text advert:
    AdvertName = {
        type = "Text",
        title = "",
        text = "",
        textColor = Color( 255, 255, 255 ),
        displayTime = 20,
        priority = CFCNotifications.PRIORITY_MIN,
        closeable = true,
        ignoreable = true,
        timed = true,
        groupName = nil (string, don't include if you want ignoreable = false)
    },--]]
    --[[          Default button advert:
    AdvertName = {
        type = "Buttons",
        title = "",
        text = "",
        textColor = Color( 255, 255, 255 ),
        displayTime = 20,
        priority = CFCNotifications.PRIORITY_MIN,
        closeable = true,
        ignoreable = true,
        timed = true,
        groupName = nil (string, don't include if you want ignoreable = false),
        buttons = {
            {
                text = "",
                buttonColor = Color( 255, 255, 255 ),
                data = {},
                func = function( ply, data1, data2, ... )
                    
                end
            },
            {
                text = "",
                buttonColor = Color( 255, 255, 255 ),
                data = {},
                func = function( ply, data1, data2, ... )
                    
                end
            }
        }
    },--]]
    PvpInfo = {
        type = "Buttons",
        title = "CFC Info",
        text = "This server has a build/pvp mode system!\n" ..
               "You can type !pvp in chat to toggle your mode.\n" ..
               "You can also press the button below.",
        textColor = CFCAdverts.colors.softBlue,
        displayTime = 20,
        priority = CFCNotifications.PRIORITY_MIN,
        closeable = true,
        ignoreable = true,
        timed = true,
        groupName = "CFC Info",
        buttons = {
            {
                text = "Swap Mode",
                buttonColor = CFCAdverts.colors.paleBlue,
                data = {},
                func = function( ply )
                    ply:Say( "!pvp" )
                end
            }
        }
    },
    ContactStaffInfo = {
        type = "Text",
        title = "CFC Info",
        text = "Have questions, comments, or concerns?\n" ..
               "Need to report a player or a bug?\n" ..
               "You can get in touch with staff by opening the tab menu and pressing the Contact Staff button on the left.",
        textColor = CFCAdverts.colors.softBlue,
        displayTime = 30,
        priority = CFCNotifications.PRIORITY_MIN,
        closeable = true,
        ignoreable = true,
        timed = true,
        groupName = "CFC Info"
    },
    DiscordAdvert = {
        type = "Buttons",
        title = "CFC Info",
        text = "CFC has a Discord server!\n" ..
               "You can join by pressing the button below.",
        textColor = CFCAdverts.colors.softBlue,
        displayTime = 20,
        priority = CFCNotifications.PRIORITY_MIN,
        closeable = true,
        ignoreable = true,
        timed = true,
        groupName = "CFC Info",
        buttons = {
            {
                text = "cfcservers.org/discord",
                buttonColor = CFCAdverts.colors.linkBlue,
                data = {},
                func = function( ply )
                    net.Start( CFCAdverts.HOOK_URL )
                    net.WriteString( "https://cfcservers.org/discord" )
                    net.Send( ply )
                end
            }
        }
    },
    NotificationInfo = {
        type = "Text",
        title = "CFC Info",
        text = "Don't want to see a notification anymore?\n" ..
               "Press 'discard' to close it early.\n" ..
               "Press 'mute' to never show it until you rejoin.\n" ..
               "Press 'never show again' to never show it ever!\n\n" ..
               "To undo this, you can go to the top right of the spawn menu (Q by default), " ..
               "open the options tab, scroll down to the CFC category, and open the settings for Notifications.",
        textColor = CFCAdverts.colors.softBlue,
        displayTime = 40,
        priority = CFCNotifications.PRIORITY_MIN,
        closeable = true,
        ignoreable = true,
        timed = true,
        groupName = "CFC Info"
    },
    RestorePropsInfo = {
        type = "Text",
        title = "CFC Info",
        text = "We have a backup system in place for your builds!\n" ..
               "Type !restoreprops to load the latest backup.\n" ..
               "Backups will persist even if the server crashes!\n" ..
               "Backups are temporary and update often.",
        textColor = CFCAdverts.colors.softBlue,
        displayTime = 30,
        priority = CFCNotifications.PRIORITY_MIN,
        closeable = true,
        ignoreable = true,
        timed = true,
        groupName = "CFC Info"
    },
}
--END OF CONGFIG


for name, advert in pairs( CFCAdverts.adverts ) do
    local groupName = advert.groupName

    if not groupName then return end
    if type( groupName ) ~= "string" then
        -- groupName should only ever be nil or a string, but for just in case
        groupName = tostring( groupName )
        advert.groupName = groupName
    end

    name = CFCAdverts.HOOK_BASE .. "_" .. name

    local group = CFCAdverts.GROUPS[groupName]
    local groupCount

    if not group then
        group = {}
        group.count = 0

        CFCAdverts.GROUPS[groupName] = group
    end

    groupCount = group.count + 1

    group[groupCount] = name
    group.count = groupCount
end

include( "cfc_adverts/server/sv_adverts.lua" )
