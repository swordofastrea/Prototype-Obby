--!strict
local Anticheat = {}
local Players = game:GetService("Players")
local AirTimeTracker = require(game:GetService("ReplicatedStorage").Modules.AirTimeTracker)
local Kicker = require(game:GetService("ReplicatedStorage").Modules.Kicker)
local RemoteEvents = require(game:GetService("ReplicatedStorage").Modules.RemoteEvents)
local MaxAirTime = 10

function Anticheat.Initialize()
    local Trackers = {}
    RemoteEvents.StartSpawn.OnServerEvent:Connect(function(player: Player)
        Trackers[player.UserId] = AirTimeTracker.trackAirTime(player, function(airTime)
            if airTime > MaxAirTime then
                Kicker.KickPlayer(player, "Unusual airtime, possible exploit")
            end
        end)
    end)

    Players.PlayerRemoving:Connect(function(player: Player)
        if Trackers[player.UserId] then
            Trackers[player.UserId]()
        end
        Trackers[player.UserId] = nil
    end)
end


return Anticheat
