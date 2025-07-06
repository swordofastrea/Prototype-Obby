--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvents = require(ReplicatedStorage.Modules.RemoteEvents)
local CameraManager = require(script.Parent.Modules.CameraManager)

CameraManager.Initialize()

ReplicatedStorage.Events.DataLoaded.OnClientEvent:Connect(function(data: string)
	print("Client Loaded. Data recieved from server: ", data)
	RemoteEvents.StartSpawn:FireServer()
end)
