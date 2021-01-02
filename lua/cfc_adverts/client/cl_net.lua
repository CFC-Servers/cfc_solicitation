net.Receive( CFCAdverts.HOOK_URL, function()
    chat.Close()
    gui.OpenURL( net.ReadString() )
end )
