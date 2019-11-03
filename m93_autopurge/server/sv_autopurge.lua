MySQLPurged = false

local KickReason = "[M93-AutoPurge] Le serveur est actuellement en train de se purger, veuillez réessayer dans quelques secondes..."

Citizen.CreateThread(function ()
    Citizen.Wait(2500)
    
    if not MySQLPurged then
        print("[M93-AutoPurge] Started purge...")
        
        MySQL.Sync.execute("DELETE FROM user_inventory WHERE count < 1", {})
        MySQL.Sync.execute("DELETE FROM addon_account_data WHERE account_name = 'caution' AND money < 1", {})
        MySQL.Sync.execute("DELETE FROM addon_account_data WHERE account_name = 'bank_savings' AND money < 1", {})
        MySQL.Sync.execute("DELETE FROM addon_account_data WHERE account_name = 'property_black_money' AND money < 1", {})
        MySQL.Sync.execute("DELETE FROM addon_inventory_items WHERE count < 1", {})
        MySQL.Sync.execute("DELETE FROM datastore_data WHERE name = 'property' AND data = '{}'", {})
        MySQL.Sync.execute("DELETE FROM datastore_data WHERE name LIKE '%user_%' AND data = '{}'", {})
        
        print("[M93-AutoPurge] Ended purge...")
        
        MySQLPurged = true
    end
end)

AddEventHandler("playerConnecting", function (name, selfkickplayer, deferrals)
    if not MySQLPurged then
        selfkickplayer(KickReason)
        CancelEvent()
    end
end)

function KickAllPlayers ()
    local PlayerList = GetPlayers()
    
    for Player in pairs(PlayerList) do
        DropPlayer(PlayerList[Player], KickReason)
    end
end

KickAllPlayers()