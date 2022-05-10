local QBCore = exports['qb-core']:GetCoreObject() 
local PlayerData = {}
local PlayerGang = {}
local PlayerJob = {}

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerGang = PlayerData.gang
    PlayerJob = PlayerData.job
end)

AddEventHandler('QBCore:Client:OnGangUpdate', function(gang) 
	PlayerGang = gang
end)


CreateThread(function()
	while true do
		inRange = false
		Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		for k, v in pairs(Config.StashCoords) do
			if #(coords - Config.StashCoords[k].coords) < 3.0 then
				inRange = true
				DrawText3D(Config.StashCoords[k].coords.x,Config.StashCoords[k].coords.y,Config.StashCoords[k].coords.z, "[E] Stash")
				if IsControlJustPressed(0, 38) then

					-- gang check
					for i=1, #Config.StashCoords[k].gang do
						if Config.StashCoords[k].gang[i] == PlayerGang.name then hasAccess = true else hasAccess = false end 
					end

					-- job check
					for i=1, #Config.StashCoords[k].gang do
						if Config.StashCoords[k].job[i] == PlayerJob.name then hasAccess = true else hasAccess = false end 
					end

					if hasAccess then 
						TriggerEvent("inventory:client:SetCurrentStash", Config.StashCoords[k].name)
						TriggerServerEvent("inventory:server:OpenInventory", "stash", Config.StashCoords[k].name, {
							maxweight = 4000000,
							slots = 500,
						})
					else
						QBCore.Functions.Notify("Not authorized", "error")
					end
				end
			end
		end
		if not inRange then
			Wait(3000)
		end
	end
end)


function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
