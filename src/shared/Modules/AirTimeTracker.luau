--!strict
local AirTimeTracker = {}
local RunService = game:GetService("RunService")

function AirTimeTracker.trackAirTime(player: Player, onAirTimeExceeded: ((number) -> ()))
    local humanoid = player:FindFirstChildOfClass("Humanoid") :: Humanoid
    if not humanoid then
        return function() end
    end

    local inAir = false
    local airStart = 0
    local airTimeExceeded = false
    local heartbeatTrack: RBXScriptConnection = nil
    local StateChangedConnection: RBXScriptConnection = nil
    local DiedConnection: RBXScriptConnection = nil
    local function stopHeartbeatTrack()
        if heartbeatTrack then
            heartbeatTrack:Disconnect()
        end
    end

    StateChangedConnection = humanoid.StateChanged:Connect(function(_, newState: Enum.HumanoidStateType)
        if (newState == Enum.HumanoidStateType.Freefall or newState == Enum.HumanoidStateType.Jumping) and not inAir then
            inAir = true
            airStart = tick()
            airTimeExceeded = false
            heartbeatTrack = RunService.Heartbeat:Connect(function()
                if inAir then
                    local airTime = tick() - airStart
                    if airTime > 5 and not airTimeExceeded then
                        airTimeExceeded = true
                        onAirTimeExceeded(airTime)
                    end
                end
            end)
        elseif (newState == Enum.HumanoidStateType.Landed or newState == Enum.HumanoidStateType.Running) and inAir then
            inAir = false
            stopHeartbeatTrack()
        end
    end)

    DiedConnection = humanoid.Died:Connect(function()
        if inAir then
            inAir = false
            stopHeartbeatTrack()
        end
    end)

    return function()
        stopHeartbeatTrack()
        if StateChangedConnection then
            StateChangedConnection:Disconnect()
        end
        if DiedConnection then
            DiedConnection:Disconnect()
        end
    end
end

return AirTimeTracker
