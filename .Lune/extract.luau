-- MIT License

-- Copyright (c) 2021 osyrisrblx

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

local fs = require("@lune/fs")
local process = require("@lune/process")
local roblox = require("@lune/roblox")

local placePath = process.args[1]
local outputPath = process.args[2]

assert(outputPath, "Output path is required")
local placeInstance = roblox.deserializePlace(fs.readFile(placePath))

local SERVICE_LOOKUP = {
    "Workspace",
    "ReplicatedStorage",
    "ServerScriptService",
    "StarterPlayer",
    "Lighting",
}

fs.writeDir(outputPath)

local function writeChildren(path, parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("Folder") or child:IsA("Model") or child:IsA("ScreenGui") or child:IsA("PluginGui") then
            fs.writeDir(path .. "/" .. child.Name)
            writeChildren(path .. "/" .. child.Name, child)
        else
            local model = roblox.serializeModel({child})
            print("Writing " .. path .. "/" .. child.Name .. ".rbxm")
            fs.writeFile(path .. "/" .. child.Name .. ".rbxm", model)
        end
    end
end

for _, serviceName in ipairs(SERVICE_LOOKUP) do
    local service = placeInstance:GetService(serviceName)
    if service then
        local servicePath = outputPath .. "/" .. serviceName
        fs.writeDir(servicePath)

        if serviceName == "StarterPlayer" then
            local starterPlayerScripts = service:FindFirstChild("StarterPlayerScripts")
            if starterPlayerScripts then
                local spsPath = servicePath .. "/StarterPlayerScripts"
                fs.writeDir(spsPath)
                writeChildren(spsPath, starterPlayerScripts)
            end
        else
            writeChildren(servicePath, service)
        end
    end
end
