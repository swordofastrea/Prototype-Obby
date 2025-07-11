--!strict
local CameraManager = {}
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace:WaitForChild("Camera")

function CameraManager.Initialize()
	player.CharacterAdded:Connect(function(character)
		local hrp: BasePart = character:WaitForChild("HumanoidRootPart")
		local camOffsets = {
			basePosOffset = Vector3.new(0, 9.2, 4.2),
			baseLookOffset = Vector3.new(0, -1.5, -4)
		}
		local camPos = hrp.CFrame:PointToWorldSpace(camOffsets.basePosOffset)
		local lookOverThere = camPos + hrp.CFrame:VectorToWorldSpace(camOffsets.baseLookOffset)
		camera.CFrame = CFrame.new(camPos, lookOverThere)
	end)
end

return CameraManager
