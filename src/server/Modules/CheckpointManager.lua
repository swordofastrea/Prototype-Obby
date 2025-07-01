local CheckpointManager = {}
local CollectionService = game:GetService("CollectionService")
local LeaderstatsManager = require(script.Parent.LeaderstatsManager)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameState = require(game:GetService("ReplicatedStorage").Modules.GameState)
local DataManager = require(script.Parent.DataManager)
local Players = game:GetService("Players")
local checkpoints = {}

function CheckpointManager:Initialize()
	for _, checkpoint in ipairs(CollectionService:GetTagged("Checkpoint")) do
		local stageNumber = tonumber(checkpoint.Name)
		if stageNumber then
			checkpoints[stageNumber] = checkpoint
			checkpoint.Touched:Connect(function(hit)
				local character = hit:FindFirstAncestorOfClass("Model")
				local humanoid = character and character:FindFirstChild("Humanoid")
				if humanoid and humanoid.Health > 0 then
					local player = Players:GetPlayerFromCharacter(character)
					if player then
						local leaderstats = player:FindFirstChild("leaderstats")
						if leaderstats then
							local stageStat = GameState:GetStage()
							if stageNumber == stageStat + 1 then
								DataManager:UpdateData(player, "CurrentStage", stageNumber)
							end
						end
					end
				end
			end)
		end
	end

	ReplicatedStorage.Events.StartSpawn.OnServerEvent:Connect(function(player)
		function CheckpointManager:teleportCharacter(character)
			local leaderstats = player:WaitForChild("leaderstats")
			local stageStat = GameState:GetStage()
			local checkpoint = checkpoints[stageStat]
			if checkpoint and checkpoint:IsA("BasePart") then
				local hrp = player.Character:WaitForChild("HumanoidRootPart")
				hrp.CFrame = checkpoint.CFrame + Vector3.new(0, 3, 0)
			end
		end
		
		if player.Character then
			self:teleportCharacter(player.Character)
		end
		
		player.CharacterAdded:Connect(function(character)
			self:teleportCharacter(character)
		end)
	end)
end

return CheckpointManager


