--!strict
local ResetButton = {}
local DataManager = require(script.Parent.DataManager)
local CheckpointManager = require(script.Parent.CheckpointManager)
local Kicker = require(game:GetService("ReplicatedStorage").Modules.Kicker)
local clickDetector: ClickDetector = nil
local maxRetries = 5
local retryDelay = 0.1

function ResetButton.Initialize()
	local resetPart: BasePart = workspace:WaitForChild("ResetPart")
	clickDetector = resetPart:FindFirstChildOfClass("ClickDetector") :: ClickDetector
	if clickDetector then
		clickDetector.Parent = resetPart
	else
		for i = 1, maxRetries do
			if clickDetector then
				return
			end
			clickDetector = Instance.new("ClickDetector")
			if clickDetector then
				clickDetector.Parent = resetPart
				if not clickDetector.Parent then
					if i == maxRetries then
						warn("Failed to parent ClickDetector on last attempt, kicking players.")
						Kicker.KickAll("ResetButton failed to initialize. Please rejoin in a different server.")
					else
						warn("Failed to parent ClickDetector on attempt " .. i .. ", retrying..")
						task.wait(retryDelay)
						clickDetector:Destroy()
					end
				end
			end
		end
	end

	clickDetector.MouseClick:Connect(function(player: Player)
		DataManager.UpdateData(player, "CurrentStage", 1)
		CheckpointManager.teleportCharacter(player)
	end)
end

return ResetButton
