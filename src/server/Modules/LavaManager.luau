local LavaManager = {}
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local debounce = {}

--you know technically this should be called KillblockManager or smth but naw im too lazy lol
function LavaManager:Initialize()
	for _, lava in ipairs(CollectionService:GetTagged("Lava")) do
		if lava:IsA("BasePart") then
			lava.Touched:Connect(function(hit)
				self:HandleLavaTouch(hit)
			end)
		end
	end
end

function LavaManager:HandleLavaTouch(hit)
	local character = hit:FindFirstAncestorOfClass("Model")
	local humanoid = character and character:FindFirstChild("Humanoid")
	local player = Players:GetPlayerFromCharacter(character)
	if humanoid and humanoid.Health > 0 and not debounce[player] then
		debounce[player] = true
		humanoid.Health = 0
		task.wait(2)
		debounce[player] = nil
	end
end

return LavaManager

