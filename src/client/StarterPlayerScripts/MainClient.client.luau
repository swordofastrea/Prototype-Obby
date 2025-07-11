--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientNetwork = require(ReplicatedStorage.Network.clientnet)
local Players = game:GetService("Players")
local CameraManager = require(script.Parent.Modules.CameraManager)

CameraManager.Initialize()
ClientNetwork.DataToClient.DataLoaded.on(function(data: number)
	print("Client loaded successfully. Current Stage: ", data)
	ClientNetwork.StartSpawn.fire(Players.LocalPlayer)
end)

ClientNetwork.DataToClient.DataUpdate.on(function(data: number)
	print("Client data updated. Current Stage: ", data)
end)
