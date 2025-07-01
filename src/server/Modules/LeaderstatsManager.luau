local LeaderstatsManager = {}
local Players = game:GetService("Players")
local GameState = require(game:GetService("ReplicatedStorage").Modules.GameState)

function LeaderstatsManager:Initialize()
	game.Players.PlayerAdded:Connect(function(player)
		
		local leaderstats = Instance.new("Folder", player)
		leaderstats.Name = "leaderstats"

		local stage = Instance.new("IntValue", leaderstats)
		stage.Name = "Stage"
		stage.Value = 1
	end)
end

function LeaderstatsManager:UpdateStage(player, stage)
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		local stageStat = leaderstats:FindFirstChild("Stage")
		if stageStat then
			stageStat.Value = stage
		end
	end
end

return LeaderstatsManager

