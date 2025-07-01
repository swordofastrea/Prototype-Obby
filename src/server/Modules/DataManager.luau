local ProfileStore = require(game:GetService("ReplicatedStorage").Modules:WaitForChild("ProfileStore"))
local Players = game:GetService("Players")
local RemoteEvents = require(game:GetService("ReplicatedStorage").Modules.RemoteEvents)
local GameState = require(game:GetService("ReplicatedStorage").Modules.GameState)
local LeaderstatsManager = require(script.Parent.LeaderstatsManager)
local DataManager = {}
local DataStore
local Profiles = {}

local Template = {
	CurrentStage = 1
}

function DataManager:Initialize()
	DataStore = ProfileStore.New("PlayerData", Template)
	Players.PlayerAdded:Connect(function(player)
		self:LoadProfile(player)
	end)
	Players.PlayerRemoving:Connect(function(player)
		self:SaveProfile(player)
	end)
	for _, player in pairs(Players:GetPlayers()) do
		self:LoadProfile(player)
	end
end

function DataManager:LoadProfile(player)
	local profile = DataStore:StartSessionAsync("Player_" .. player.UserId, {
		Cancel = function()
			return player.Parent == nil
		end
	})

	if profile then
		Profiles[player] = profile
		profile:AddUserId(player.UserId)
		profile:Reconcile()
		self:UpdateData(player, "CurrentStage", profile.Data.CurrentStage)
		RemoteEvents.DataLoaded:FireClient(player, profile.Data)
		print("Loaded profile with data:", profile.Data.CurrentStage)
		print("Data loaded for client successfully!")
	else
		player:Kick("Your data was unable to load successfully. Please try rejoining.")
	end
end

function DataManager:SaveProfile(player)
	local profile = Profiles[player]
	if profile then
		profile:EndSession()
		Profiles[player] = nil
		print("Saving profile with data:", profile.Data.CurrentStage)
		print("Data saved for client successfully!")
	end
end

function DataManager:GetProfile(player)
	return Profiles[player]
end

function DataManager:UpdateData(player, key, value)
	local profile = self:GetProfile(player)
	if profile then
		profile.Data[key] = value
		RemoteEvents.DataUpdate:FireClient(player, profile.Data)
		if key == "CurrentStage" and player then
			GameState:SetStage(value)
			LeaderstatsManager:UpdateStage(player, value)
		end
	end
end

return DataManager