CFCAdverts = CFCAdverts or {}

CFCAdverts.HOOK_BASE = "CFC_Adverts"
CFCAdverts.HOOK_URL = CFCAdverts.HOOK_BASE .. "_OpenURL"

if CLIENT then
    include( "cfc_adverts/client/cl_net.lua" )
    return
end

util.AddNetworkString( CFCAdverts.HOOK_URL )

CFCAdverts.advertGap = CreateConVar( "cfc_adverts_gap", 120, FCVAR_NONE, "The time in seconds between adverts (default 120)", 1, 50000 )

CFCAdverts.colors = {
    cfcInfoBlue = Color( 0, 168, 243 ),
    lavender = Color( 155, 145, 255 ),
    softBlue = Color( 125, 165, 255 ),
    paleBlue = Color( 200, 220, 245 ),
    linkBlue = Color( 120, 220, 255 ),
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
        timed = true
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
        timed = true
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
    CollectionInfo = {
        type = "Buttons",
        title = "CFC Info",
        text = "Looking for our server content?\n" ..
               "The button below will bring you to our addon list.",
        textColor = CFCAdverts.colors.softBlue,
        displayTime = 20,
        priority = CFCNotifications.PRIORITY_MIN,
        closeable = true,
        ignoreable = true,
        timed = true,
        buttons = {
            {
                text = "cfcservers.org/cfc3/collection",
                buttonColor = CFCAdverts.colors.linkBlue,
                data = {},
                func = function( ply )
                    net.Start( CFCAdverts.HOOK_URL )
                    net.WriteString( "https://cfcservers.org/cfc3/collection" )
                    net.Send( ply )
                end
            }
        }
    },
    RulesInfo = {
        type = "Buttons",
        title = "CFC Info",
        text = "Looking for the rules?\n" ..
               "View them by typing !motd in chat or pressing the button below.",
        textColor = CFCAdverts.colors.softBlue,
        displayTime = 20,
        priority = CFCNotifications.PRIORITY_MIN,
        closeable = true,
        ignoreable = true,
        timed = true,
        buttons = {
            {
                text = "Read the Rules",
                buttonColor = CFCAdverts.colors.paleBlue,
                data = {},
                func = function( ply )
                    ply:Say( "!motd" )
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
        timed = true
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
        timed = true
    },
    DupeInfo = {
        type = "Text",
        title = "CFC Info",
        text = "This server has Advanced Duplicator 2 (Adv Dupe 2)\n" ..
               "It is less laggy for the server than other dupe methods.\n" ..
               "Adv Dupe 2 doesn't support your default duplications, but they can be transferred over in singleplayer!\n" ..
               "The Adv Dupe 2 tool is in the 'Construction' category.",
        textColor = CFCAdverts.colors.softBlue,
        displayTime = 30,
        priority = CFCNotifications.PRIORITY_MIN,
        closeable = true,
        ignoreable = true,
        timed = true
    },
}

include( "cfc_adverts/server/sv_adverts.lua" )
