ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
        Citizen.Wait(0)
        
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        PlayerData = ESX.GetPlayerData()
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

_menuPool = NativeUI.CreatePool()
local isNearZone = false
local isAtZone = false
local indexChanged = nil

-- Citizen.CreateThread(function()
--     for k, e in pairs(Config.Elevators) do
--         for k, t in pairs(e.location) do 
--             if e.enableBlip == true then
--                 local blip = AddBlipForCoord(t.x, t.y, t.z)
--                 SetBlipSprite (blip, e.blipId)
--                 SetBlipScale  (blip, e.blipSize)
--                 SetBlipDisplay(blip, 4)
--                 SetBlipColour (blip, e.blipColor)
--                 SetBlipAsShortRange(blip, e.blipShortRange)
--                 BeginTextCommandSetBlipName('STRING') 
--                 AddTextComponentString(e.blipName)
--                 EndTextCommandSetBlipName(blip)  
--             end
--         end
--     end
-- end)

Citizen.CreateThread(function()
	while true do

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        isNearZone = false
        isAtZone = false
		
        for k, v in pairs(Config.Elevators) do
            for l, i in pairs(v.stagelabel) do
                local distance = Vdist(playerCoords, v[i].x, v[i].y, v[i].z)

                if distance < 1.1 then
                    isNearZone = true
                    isAtZone = true 
                    currentelevator = v 
                elseif distance < 1.1 + 5 then
                    isNearZone = true
                    currentelevator = v
                    if _menuPool:IsAnyMenuOpen() then
                        _menuPool:CloseAllMenus()
                    end
                end
            end
        end
        Citizen.Wait(350)
	end
end)

local playerPed = PlayerPedId()

Citizen.CreateThread(function()
    while true do

        if _menuPool:IsAnyMenuOpen() then 
            _menuPool:ProcessMenus()
        end

		if isNearZone then
            -- for i, l in pairs(currentelevator.location) do
            for i, l in pairs(currentelevator.stagelabel) do
			    DrawMarker(currentelevator.markerID, currentelevator[l].x, currentelevator[l].y, currentelevator[l].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 0, 255, 0, 50, false, false, 2, false, false, false, false)
            end
        else 
            Citizen.Wait(350)
        end
        if isAtZone then
            
            -- print(currentelevator.RequiredJob)
            showInfobar(currentelevator.openMenu)
            if IsControlJustReleased(0, Config.ElevatorKey) and not _menuPool:IsAnyMenuOpen() then
                if (ESX.PlayerData.job and ESX.PlayerData.job.name == currentelevator.RequiredJob) or currentelevator.RequiredJob == '' then
                    openMenu()
                else 
                    PlaySoundFrontend(-1, "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET")
                    ShowNotification(Translation[Config.Locale]['wrong_job']..' ~y~'..currentelevator.RequiredJob_label)
                end
            end
        end
        Citizen.Wait(1)
    end
end)

function openMenu()
        
        mainMenu = NativeUI.CreateMenu(currentelevator.elevator_name, '')
        _menuPool:Add(mainMenu)

        local indexChanged = currentelevator.stagelabel[1]

        stage = UIMenuListItem.New(currentelevator.elevator_name, currentelevator.stagelabel, 1)
        mainMenu:AddItem(stage)
        
        mainMenu.OnListChange = function(sender, item, index)
            if item == stage then 
                indexChanged = item:IndexToItem(index)
            end
        end 

        confirm_stage = NativeUI.CreateItem('Confirm', '')
        mainMenu:AddItem(confirm_stage)

        confirm_stage.Activated = function (index, item, Sender)
            if item == confirm_stage then 
                if currentelevator.UseElevatorSound == true then 
                    PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET")
                    
                end
                -- Citizen.Wait(500)
                for u, b in ipairs(currentelevator.stagelabel) do
                    print(currentelevator[indexChanged])
                    
                    DoScreenFadeOut(700)
                    Citizen.Wait(700)
                    SetPedCoordsKeepVehicle(playerPed, currentelevator[indexChanged].x, currentelevator[indexChanged].y, currentelevator[indexChanged].z)
                    SetEntityHeading(playerPed, currentelevator[indexChanged].heading)
                    if _menuPool:IsAnyMenuOpen() then
                        _menuPool:CloseAllMenus()
                    end
                    
                    DoScreenFadeIn(700)
                    
                end
                -- Citizen.Wait(300)
                if currentelevator.UseElevatorSound == true then 
                    PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET")
                   
                end
                Citizen.Wait(500)
                ShowNotification(Translation[Config.Locale]['teleported']..' '..indexChanged)
            end
        end
     
    mainMenu:Visible(true)
    _menuPool:RefreshIndex()
    _menuPool:MouseControlsEnabled (false)
    _menuPool:MouseEdgeEnabled (false)
    _menuPool:ControlDisablingEnabled(false)
end

function showInfobar(msg)
	CurrentActionMsg  = msg
	SetTextComponentFormat('STRING')
	AddTextComponentString(CurrentActionMsg)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function CreateDialog(DisplayTitle)
	AddTextEntry(DisplayTitle, DisplayTitle)
	DisplayOnscreenKeyboard(1, DisplayTitle, "", "", "", "", "", 32)
	while (UpdateOnscreenKeyboard() == 0) do
		DisableAllControlActions(0);
		Wait(0);
	end
	if (GetOnscreenKeyboardResult()) then
		local displayResult = GetOnscreenKeyboardResult()
		return displayResult
	end
end

RegisterNetEvent('life_seller:Notification')
AddEventHandler('life_seller:Notification', function(msg)
	ShowNotification(msg)
end)

function ShowNotification(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(false, false)
end
