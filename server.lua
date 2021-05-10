ESX = nil
local cuffed = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem("kabelbinder", function(source)
    TriggerClientEvent("esx_kabelbinder:checkCuff", source)
end)

ESX.RegisterUsableItem("schere", function(source)
    TriggerClientEvent("esx_kabelbinder:uncuff", source)
end)

RegisterServerEvent("esx_kabelbinder:uncuff")
AddEventHandler("esx_kabelbinder:uncuff",function(player)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.addInventoryItem("kabelbinder",1)
    cuffed[player]=false
    TriggerClientEvent('esx_kabelbinder:forceUncuff', player)
end)
--Für Beamte
RegisterServerEvent("esx_kabelbinder:uncufffürbeamte")
AddEventHandler("esx_kabelbinder:uncufffürbeamte",function(player)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    cuffed[player]=false
    TriggerClientEvent('esx_kabelbinder:forceUncuff', player)
end)

RegisterServerEvent("esx_kabelbinder:handcuff")
AddEventHandler("esx_kabelbinder:handcuff",function(player,state)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    cuffed[player]=state
    TriggerClientEvent('esx_kabelbinder:handcuff', player)
    if state then xPlayer.removeInventoryItem("kabelbinder",1) else xPlayer.addInventoryItem("kabelbinder",1) end
end)

ESX.RegisterServerCallback("esx_kabelbinder:isCuffed",function(source,cb,target)
    cb(cuffed[target]~=nil and cuffed[target])
end)