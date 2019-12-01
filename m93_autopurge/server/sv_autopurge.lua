local PurgeDone = false

local KickReason = "[M93-AutoPurge] Le serveur est actuellement en train de se purger, veuillez réessayer dans quelques secondes..."


AddEventHandler("onMySQLReady", function ()
    if not PurgeDone then
        local AvailableRequests = 0
        local FinishedRequests = 0
        
        print("[M93-AutoPurge] Started purge...")
        
        --------------------------------------------------------
        AvailableRequests = AvailableRequests + 1
        
        MySQL.Async.execute([[DELETE FROM user_inventory WHERE count < 1]], {}, function ()
            FinishedRequests = FinishedRequests + 1
        end)
        --------------------------------------------------------
        AvailableRequests = AvailableRequests + 1
        
        MySQL.Async.execute([[DELETE FROM addon_account_data WHERE (account_name = "caution" AND money < 1)]], {}, function ()
            FinishedRequests = FinishedRequests + 1
        end)
        --------------------------------------------------------
        AvailableRequests = AvailableRequests + 1
        
        MySQL.Async.execute([[DELETE FROM addon_account_data WHERE (account_name = "bank_savings" AND money < 1)]], {}, function ()
            FinishedRequests = FinishedRequests + 1
        end)
        --------------------------------------------------------
        AvailableRequests = AvailableRequests + 1
        
        MySQL.Async.execute([[DELETE FROM addon_account_data WHERE (account_name = "property_black_money" AND money < 1)]], {}, function ()
            FinishedRequests = FinishedRequests + 1
        end)
        --------------------------------------------------------
        AvailableRequests = AvailableRequests + 1
        
        MySQL.Async.execute([[DELETE FROM addon_inventory_items WHERE count < 1]], {}, function ()
            FinishedRequests = FinishedRequests + 1
        end)
        --------------------------------------------------------
        AvailableRequests = AvailableRequests + 1
        
        MySQL.Async.execute([[DELETE FROM datastore_data WHERE (name = "property" AND data = "{}")]], {}, function ()
            FinishedRequests = FinishedRequests + 1
        end)
        --------------------------------------------------------
        AvailableRequests = AvailableRequests + 1
        
        MySQL.Async.execute([[DELETE FROM datastore_data WHERE (name LIKE "%user_%" AND data = "{}")]], {}, function ()
            FinishedRequests = FinishedRequests + 1
        end)
        --------------------------------------------------------
        
        while FinishedRequests < AvailableRequests do
            Citizen.Wait(1000)
        end
        
        print("[M93-AutoPurge] Ended purge...")
        
        PurgeDone = true
    end
end)

AddEventHandler("playerConnecting", function (name, selfkickplayer, deferrals)
    if not PurgeDone then
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