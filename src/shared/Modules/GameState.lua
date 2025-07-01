local GameState = {}
local currentStage = 1

function GameState:SetStage(stage)
	currentStage = stage
end

function GameState:GetStage()
	return currentStage
end

return GameState
