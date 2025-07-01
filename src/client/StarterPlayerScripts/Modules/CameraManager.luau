--!strict
local CameraManager = {}
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera: Camera = workspace:WaitForChild("Camera")

function CameraManager:Initialize()
	player.CharacterAdded:Connect(function(character)
		local hrp: BasePart = character:WaitForChild("HumanoidRootPart")
		local camOffset: Vector3 = Vector3.new(0, 9.2, 4.2)
		local camLookOffset: Vector3 = Vector3.new(0, -1.5, -4)
		local camPos: Vector3 = hrp.CFrame:PointToWorldSpace(camOffset)
		local lookOverThere: Vector3 = camPos + hrp.CFrame:VectorToWorldSpace(camLookOffset)
		camera.CFrame = CFrame.new(camPos, lookOverThere)
	end)
end

return CameraManager
