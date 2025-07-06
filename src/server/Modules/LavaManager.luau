--!strict
local LavaManager = {}
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local debounce = {}

--you know technically this should be called KillblockManager or smth but naw im too lazy lol
function LavaManager.Initialize()
	for _, lava in ipairs(CollectionService:GetTagged("Lava")) do
		if lava:IsA("BasePart") then
			lava.Touched:Connect(function(hit: BasePart)
				LavaManager.HandleLavaTouch(hit)
			end)
		end
	end
end

function LavaManager.HandleLavaTouch(hit: BasePart)
	local character = hit:FindFirstAncestorOfClass("Model") :: Model
	local humanoid = character and character:FindFirstChild("Humanoid") :: Humanoid
	local player = Players:GetPlayerFromCharacter(character) :: Player
	if humanoid and humanoid.Health > 0 and not debounce[player] then
		debounce[player] = true
		humanoid.Health = 0
		task.wait(2)
		debounce[player] = nil
	end
end

return LavaManager
