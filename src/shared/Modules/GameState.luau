--!strict
local GameState = {}

function GameState:GetStage(player: Player): IntValue?
    local leaderstats = player:FindFirstChild("leaderstats") :: Folder
    if leaderstats then
        local stageStat = leaderstats:FindFirstChild("Stage") :: IntValue
        if stageStat then
            return stageStat
        end
    end
	return nil
end

return GameState
