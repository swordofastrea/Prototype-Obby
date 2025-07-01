local RemoteEvents = {}
local eventsFolder = game:GetService("ReplicatedStorage"):WaitForChild("Events")

RemoteEvents.DataUpdate = eventsFolder:WaitForChild("DataUpdate")
RemoteEvents.StageReached = eventsFolder:WaitForChild("StageReached")
RemoteEvents.DataLoaded = eventsFolder:WaitForChild("DataLoaded")
RemoteEvents.StartSpawn = eventsFolder:WaitForChild("StartSpawn")

return RemoteEvents
