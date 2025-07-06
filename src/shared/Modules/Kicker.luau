--!strict
local Kicker = {}
local Players = game:GetService("Players")

function Kicker.KickPlayer(player: Player, reason: string)
    player:Kick(reason)
end

function Kicker.KickAll(reason: string)
    for _, player: Player in pairs(Players:GetPlayers()) do
        player:Kick(reason)
    end
end

return Kicker
