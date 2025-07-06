--!strict
local ProfileStore = require(game:GetService("ReplicatedStorage").Modules:WaitForChild("ProfileStore"))
local Players = game:GetService("Players")
local RemoteEvents = require(game:GetService("ReplicatedStorage").Modules.RemoteEvents)
local LeaderstatsManager = require(script.Parent.LeaderstatsManager)
local Kicker = require(game:GetService("ReplicatedStorage").Modules.Kicker)
local DataManager = {}
local DataStore
local Profiles = {}

local Template = {
	CurrentStage = 1
}

function DataManager.Initialize()
	DataStore = ProfileStore.New("PlayerData", Template) :: any
	Players.PlayerAdded:Connect(function(player: Player)
		DataManager.LoadProfile(player)
	end)
	Players.PlayerRemoving:Connect(function(player: Player)
		DataManager.SaveProfile(player)
	end)
	for _, player: Player in pairs(Players:GetPlayers()) do
		DataManager.LoadProfile(player)
	end
end

function DataManager.LoadProfile(player: Player)
	local profile = DataStore:StartSessionAsync("Player_" .. player.UserId, {
		Cancel = function()
			return player.Parent == nil
		end
	})

	if profile then
		Profiles[player] = profile
		profile:AddUserId(player.UserId)
		profile:Reconcile()
		DataManager.UpdateData(player, "CurrentStage", profile.Data.CurrentStage)
		RemoteEvents.DataLoaded:FireClient(player, profile.Data)
		print("Loaded profile with data:", profile.Data.CurrentStage)
		print("Data loaded for client successfully!")
	else
		Kicker.KickPlayer(player, "Your data was unable to load successfully. Please try rejoining.")
	end
end

function DataManager.SaveProfile(player: Player)
	local profile = Profiles[player]
	if profile then
		profile:EndSession()
		Profiles[player] = nil
		print("Saving profile with data:", profile.Data.CurrentStage)
		print("Data saved for client successfully!")
	end
end

function DataManager.GetProfile(player: Player)
	return Profiles[player]
end

function DataManager.UpdateData(player: Player, key: string, value: number)
	local profile = DataManager.GetProfile(player)
	if profile then
		profile.Data[key] = value
		RemoteEvents.DataUpdate:FireClient(player, profile.Data)
		if key == "CurrentStage" and player then
			LeaderstatsManager.UpdateStage(player, value)
		end
	end
end

return DataManager
