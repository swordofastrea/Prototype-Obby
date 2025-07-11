--!strict
local CheckpointManager = {}
local CollectionService = game:GetService("CollectionService")
local ServerNetwork = require(game:GetService("ReplicatedStorage").Network.servernet)
local GameState = require(game:GetService("ReplicatedStorage").Modules.GameState)
local DataManager = require(script.Parent.DataManager)
local Players = game:GetService("Players")
local checkpoints = {}

function CheckpointManager.Initialize()
	for _, checkpoint in ipairs(CollectionService:GetTagged("Checkpoint")) do
		local stageNumber = tonumber(checkpoint.Name) :: number
		if stageNumber then
			checkpoints[stageNumber] = checkpoint
			checkpoint.Touched:Connect(function(hit: BasePart)
				local character = hit:FindFirstAncestorOfClass("Model") :: Model
				local humanoid = character and character:FindFirstChild("Humanoid") :: Humanoid
				if humanoid and humanoid.Health > 0 then
					local player = Players:GetPlayerFromCharacter(character) :: Player
					if player then
						local leaderstats = player:FindFirstChild("leaderstats") :: Folder
						if leaderstats then
							local stageStat = GameState:GetStage(player)
							if stageStat and stageNumber == stageStat.Value + 1 then
								DataManager.UpdateData(player, "CurrentStage", stageNumber)
							end
							end
						end
					end
				end)
			end
		end

	ServerNetwork.StartSpawn.on(function(player: Player)
		if player.Character then
			CheckpointManager.teleportCharacter(player)
		end

		player.CharacterAdded:Connect(function()
			CheckpointManager.teleportCharacter(player)
		end)
	end)
end

function CheckpointManager.teleportCharacter(player: Player)
	local character = player.Character :: Model
	if character then
		local stageStat = GameState:GetStage(player)
		if stageStat then
			local checkpoint: BasePart = checkpoints[stageStat.Value]
			if checkpoint then
				local hrp = character:WaitForChild("HumanoidRootPart") :: BasePart
				if hrp then
					local spawnOffset = Vector3.new(0, 3, 0)
					hrp.CFrame = checkpoint.CFrame + spawnOffset
				end
			end
		end
	end
end

return CheckpointManager
