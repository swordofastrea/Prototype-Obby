local DataManager = require(script.Parent.Modules.DataManager)
local CheckpointManager = require(script.Parent.Modules.CheckpointManager)
local LavaManager = require(script.Parent.Modules.LavaManager)
local LeaderstatsManager = require(script.Parent.Modules.LeaderstatsManager)
local ResetButton = require(script.Parent.Modules.ResetButton)

LeaderstatsManager:Initialize()
DataManager:Initialize()
CheckpointManager:Initialize()
LavaManager:Initialize()
ResetButton:Initialize()

