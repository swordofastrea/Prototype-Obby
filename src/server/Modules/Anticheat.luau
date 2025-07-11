--!strict
local Anticheat = {}
local Players = game:GetService("Players")
local AirTimeTracker = require(game:GetService("ReplicatedStorage").Modules.AirTimeTracker)
local Kicker = require(game:GetService("ReplicatedStorage").Modules.Kicker)
local ServerNetwork = require(game:GetService("ReplicatedStorage").Network.servernet)
local MaxAirTime = 10

function Anticheat.Initialize()
    local Trackers = {}
    ServerNetwork.StartSpawn.on(function(player: Player)
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
