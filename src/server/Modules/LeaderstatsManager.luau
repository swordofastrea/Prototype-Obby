--!strict
local LeaderstatsManager = {}
local GameState = require(game:GetService("ReplicatedStorage").Modules.GameState)

function LeaderstatsManager.Initialize()
	game.Players.PlayerAdded:Connect(function(player: Player)

		local leaderstats = Instance.new("Folder")
		leaderstats.Parent = player
		leaderstats.Name = "leaderstats"

		local stage = Instance.new("IntValue")
		stage.Parent = leaderstats
		stage.Name = "Stage"
		stage.Value = 1
	end)
end

function LeaderstatsManager.UpdateStage(player: Player, stage: number)
	local leaderstats = player:FindFirstChild("leaderstats") :: Folder
	if leaderstats then
		local stageStat = GameState:GetStage(player)
		if stageStat then
			stageStat.Value = stage
		end
	end
end

return LeaderstatsManager
