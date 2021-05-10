ESX = nil
local IsHandcuffed2 = false


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
end)

RegisterNetEvent("esx_kabelbinder:checkCuff")
AddEventHandler("esx_kabelbinder:checkCuff", function()
    local player, distance = ESX.Game.GetClosestPlayer()
    if distance~=-1 and distance<=3.0 then
        ESX.TriggerServerCallback("esx_kabelbinder:isCuffed",function(cuffed)
            if not cuffed2 then
                TriggerServerEvent("esx_kabelbinder:handcuff",GetPlayerServerId(player),true)
            else
                TriggerServerEvent("esx_kabelbinder:handcuff",GetPlayerServerId(player),false)
            end
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.0, 'busted', 1.0)
        end,GetPlayerServerId(player))
    else
        exports['grv_notify']:SendAlert('error', 'Keine Spieler in der Nähe')
    end
end)
      

RegisterNetEvent("esx_kabelbinder:uncuff")
AddEventHandler("esx_kabelbinder:uncuff",function()
    local player, distance = ESX.Game.GetClosestPlayer()
    if distance~=-1 and distance<=3.0 then
        TriggerServerEvent("esx_kabelbinder:uncuff",GetPlayerServerId(player))
    else
        exports['grv_notify']:SendAlert('error', 'Keine Spieler in der Nähe')
    end
end)

RegisterNetEvent("esx_kabelbinder:uncufffürbeamte")
AddEventHandler("esx_kabelbinder:uncufffürbeamte",function()
    local player, distance = ESX.Game.GetClosestPlayer()
    if distance~=-1 and distance<=3.0 then
        TriggerServerEvent("esx_kabelbinder:uncufffürbeamte",GetPlayerServerId(player))
    else
        exports['grv_notify']:SendAlert('error', 'Keine Spieler in der Nähe')
    end
end)


RegisterNetEvent('esx_kabelbinder:forceUncuff')
AddEventHandler('esx_kabelbinder:forceUncuff',function()
    IsHandcuffed2 = false
    local playerPed = GetPlayerPed(-1)
    ClearPedSecondaryTask(playerPed)
    SetEnableHandcuffs(playerPed, false)
    DisablePlayerFiring(playerPed, false)
    SetPedCanPlayGestureAnims(playerPed, true)
    FreezeEntityPosition(playerPed, false)
    DisplayRadar(true)
end)

RegisterNetEvent("esx_kabelbinder:handcuff")
AddEventHandler("esx_kabelbinder:handcuff",function()
    local playerPed = GetPlayerPed(-1)
    IsHandcuffed2 = not IsHandcuffed2
    Citizen.CreateThread(function()
        if IsHandcuffed2 then
            ClearPedTasks(playerPed)
            SetPedCanPlayAmbientBaseAnims(playerPed, true)

            Citizen.Wait(10)
            RequestAnimDict('anim@move_m@prisoner_cuffed')
            while not HasAnimDictLoaded('anim@move_m@prisoner_cuffed') do
                Citizen.Wait(0)
            end
			Citizen.Wait(0)
            TaskPlayAnim(playerPed, 'anim@move_m@prisoner_cuffed', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

            SetEnableHandcuffs(playerPed, true)
            DisablePlayerFiring(playerPed, true)
            SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
            SetPedCanPlayGestureAnims(playerPed, false)
            DisplayRadar(false)
        end
    end)
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = GetPlayerPed(-1)
        if IsHandcuffed2 then
            SetEnableHandcuffs(playerPed, true)
            DisablePlayerFiring(playerPed, true)
            SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
            SetPedCanPlayGestureAnims(playerPed, false)
            DisplayRadar(false)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 74, true)
			DisableControlAction(0, 2, true) -- Disable pan
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job
            DisableControlAction(1, 254, true)
			DisableControlAction(0, 47, true)  -- Disable weapon
        end
        if not IsHandcuffed2 and not IsControlEnabled(0, 140) then EnableControlAction(0, 140, true)  end
        if not IsHandcuffed2 and not IsControlEnabled(0, 74) then EnableControlAction(0, 74, true)  end
    end
end)

