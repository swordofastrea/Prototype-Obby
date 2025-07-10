local PhysicsService = game:GetService("PhysicsService")
local ServerNetwork = require(game:GetService("ReplicatedStorage").Network.servernet)
local CollisionGroupName = "Players"
local PlayerCollisionManager = {}

function PlayerCollisionManager.Initialize()
    PhysicsService:RegisterCollisionGroup(CollisionGroupName)
    PhysicsService:CollisionGroupSetCollidable(CollisionGroupName, CollisionGroupName, false)

	ServerNetwork.StartSpawn.on(function(player: Player)
		if player.Character then
			PlayerCollisionManager.disableCollisions(player)
		end

		player.CharacterAdded:Connect(function()
			PlayerCollisionManager.disableCollisions(player)
		end)
	end)
end

function PlayerCollisionManager.disableCollisions(player: Player)
    local character = player.Character
    for _, descendant in character:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CollisionGroup = CollisionGroupName
        end
    end
end



return PlayerCollisionManager
