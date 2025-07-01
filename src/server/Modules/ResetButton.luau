local ResetButton = {}
local DataManager = require(script.Parent.DataManager)
local CheckpointManager = require(script.Parent.CheckpointManager)

function ResetButton:Initialize()
	local resetPart = workspace:WaitForChild("ResetPart")
	
	local clickDetector = resetPart:FindFirstChildOfClass("ClickDetector")
	if not clickDetector then
		clickDetector = Instance.new("ClickDetector")
		clickDetector.Parent = resetPart
	end
	
	clickDetector.MouseClick:Connect(function(player)
		DataManager:UpdateData(player, "CurrentStage", 1)
		CheckpointManager:teleportCharacter(player.Character)
	end)
end

return ResetButton
