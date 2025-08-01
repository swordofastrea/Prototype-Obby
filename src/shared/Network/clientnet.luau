--!strict
--!native
--!optimize 2
--!nolint LocalShadow
--#selene: allow(shadowing)
-- File generated by Blink v0.17.4 (https://github.com/1Axen/Blink)
-- This file is not meant to be edited

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local BASE_EVENT_NAME = "BLINK"
local Invocations = 0

local SendSize = 64
local SendOffset = 0
local SendCursor = 0
local SendBuffer = buffer.create(64)
local SendInstances = {}

local RecieveCursor = 0
local RecieveBuffer = buffer.create(64)

local RecieveInstances = {}
local RecieveInstanceCursor = 0

local Null = newproxy()

type Entry = {
    value: any,
    next: Entry?
}

type Queue = {
    head: Entry?,
    tail: Entry?
}

type BufferSave = {
    Size: number, 
    Cursor: number, 
    Buffer: buffer, 
    Instances: {Instance}
}

local function Read(Bytes: number)
    local Offset = RecieveCursor
    RecieveCursor += Bytes
    return Offset
end

local function Save(): BufferSave
    return {
        Size = SendSize,
        Cursor = SendCursor,
        Buffer = SendBuffer,
        Instances = SendInstances
    }
end

local function Load(Save: BufferSave?)
    if Save then
        SendSize = Save.Size
        SendCursor = Save.Cursor
        SendOffset = Save.Cursor
        SendBuffer = Save.Buffer
        SendInstances = Save.Instances
        return
    end

    SendSize = 64
    SendCursor = 0
    SendOffset = 0
    SendBuffer = buffer.create(64)
    SendInstances = {}
end

local function Invoke()
    if Invocations == 255 then
        Invocations = 0
    end

    local Invocation = Invocations
    Invocations += 1
    return Invocation
end

local function Allocate(Bytes: number)
    local InUse = (SendCursor + Bytes)
    if InUse > SendSize then
        --> Avoid resizing the buffer for every write
        while InUse > SendSize do
            SendSize *= 1.5
        end

        local Buffer = buffer.create(SendSize)
        buffer.copy(Buffer, 0, SendBuffer, 0, SendCursor)
        SendBuffer = Buffer
    end

    SendOffset = SendCursor
    SendCursor += Bytes
    
    return SendOffset
end

local function CreateQueue(): Queue
    return {
        head = nil,
        tail = nil
    }
end

local function Pop(queue: Queue): any
    local head = queue.head
    if head == nil then
        return
    end

    queue.head = head.next
    return head.value
end

local function Push(queue: Queue, value: any)
    local entry: Entry = {
        value = value,
        next = nil
    }

    if queue.tail ~= nil then
        queue.tail.next = entry
    end

    queue.tail = entry

    if queue.head == nil then
        queue.head = entry
    end
end

local Calls = table.create(256)

local Events: any = {
    Reliable = table.create(256),
    Unreliable = table.create(256)
}

local Queue: any = {
    Reliable = table.create(256),
    Unreliable = table.create(256)
}

Queue.Reliable[0] = table.create(256)
Queue.Reliable[1] = table.create(256)
export type player = Player
export type DataToClient_returnedData = number
local function DataToClient_ReadEVENT_DataUpdate(): (number)
	-- Read BLOCK: 1 bytes
	local BLOCK_START = Read(1)
	local Value = buffer.readu8(RecieveBuffer, BLOCK_START + 0)
	return Value
end

local function DataToClient_ReadEVENT_DataLoaded(): (number)
	-- Read BLOCK: 1 bytes
	local BLOCK_START = Read(1)
	local Value = buffer.readu8(RecieveBuffer, BLOCK_START + 0)
	return Value
end

local function WriteEVENT_StartSpawn(Value: Player): ()
	-- Allocate BLOCK: 1 bytes
	local BLOCK_START = Allocate(1)
	buffer.writeu8(SendBuffer, BLOCK_START + 0, 2)
	table.insert(SendInstances, Value or Null)
end

if not RunService:IsRunning() then
	local NOOP = function() end
	local Returns = table.freeze({
	DataToClient = {
		DataUpdate = {
			on = NOOP
		},
		DataLoaded = {
			on = NOOP
		},
	},
	StartSpawn = {
		fire = NOOP
	},
	})
	return Returns :: BLINK_EVENTS_SYMBOL
end

if not RunService:IsClient() then
    error("Client network module can only be required from the client.")
end

local Reliable: RemoteEvent = ReplicatedStorage:WaitForChild(BASE_EVENT_NAME .. "_RELIABLE_REMOTE") :: RemoteEvent
local Unreliable: UnreliableRemoteEvent = ReplicatedStorage:WaitForChild(BASE_EVENT_NAME .. "_UNRELIABLE_REMOTE") :: UnreliableRemoteEvent

local function StepReplication()
    if SendCursor <= 0 then
        return
    end

    local Buffer = buffer.create(SendCursor)
    buffer.copy(Buffer, 0, SendBuffer, 0, SendCursor)
    Reliable:FireServer(Buffer, SendInstances)

    SendSize = 64
    SendCursor = 0
    SendOffset = 0
    SendBuffer = buffer.create(64)
    table.clear(SendInstances)
end
RunService.Heartbeat:Connect(StepReplication)
Reliable.OnClientEvent:Connect(function(Buffer: buffer, Instances: {Instance})
	RecieveCursor = 0
	RecieveBuffer = Buffer
	RecieveInstances = Instances
	RecieveInstanceCursor = 0
	local Size = buffer.len(RecieveBuffer)
	while (RecieveCursor < Size) do
		-- Read BLOCK: 1 bytes
		local BLOCK_START = Read(1)
		local Index = buffer.readu8(RecieveBuffer, BLOCK_START + 0)
		if Index == 0 then
			local Value: number = DataToClient_ReadEVENT_DataUpdate()
			if Events.Reliable[0] ~= nil then
				Events.Reliable[0](Value)
			else
				if #Queue.Reliable[0] > 256 then
					warn("[Blink]: Event queue of \"DataUpdate\" exceeded 256, did you forget to implement a listener?")
				end
				table.insert(Queue.Reliable[0], {Value} :: {any})
			end
		elseif Index == 1 then
			local Value: number = DataToClient_ReadEVENT_DataLoaded()
			if Events.Reliable[1] ~= nil then
				Events.Reliable[1](Value)
			else
				if #Queue.Reliable[1] > 256 then
					warn("[Blink]: Event queue of \"DataLoaded\" exceeded 256, did you forget to implement a listener?")
				end
				table.insert(Queue.Reliable[1], {Value} :: {any})
			end
		end
	end
end)
Unreliable.OnClientEvent:Connect(function(Buffer: buffer, Instances: {Instance})
	RecieveCursor = 0
	RecieveBuffer = Buffer
	RecieveInstances = Instances
	RecieveInstanceCursor = 0
	local Size = buffer.len(RecieveBuffer)
	while (RecieveCursor < Size) do
		-- Read BLOCK: 1 bytes
		local BLOCK_START = Read(1)
		local Index = buffer.readu8(RecieveBuffer, BLOCK_START + 0)
	end
end)


local Returns = table.freeze({
	stepReplication = StepReplication,

	DataToClient = {
		DataUpdate = {
			on = function(Listener: (Value: number) -> ()): () -> ()
				Events.Reliable[0] = Listener
				for Index, Arguments in Queue.Reliable[0] do
					Listener(table.unpack(Arguments))
				end
				Queue.Reliable[0] = {}
				return function (): ()
					if Events.Reliable[0] == Listener then
						Events.Reliable[0] = nil
					end
				end
			end
		},
		DataLoaded = {
			on = function(Listener: (Value: number) -> ()): () -> ()
				Events.Reliable[1] = Listener
				for Index, Arguments in Queue.Reliable[1] do
					Listener(table.unpack(Arguments))
				end
				Queue.Reliable[1] = {}
				return function (): ()
					if Events.Reliable[1] == Listener then
						Events.Reliable[1] = nil
					end
				end
			end
		},
	},
	StartSpawn = {
		fire = function(Value: Player): ()
			WriteEVENT_StartSpawn(Value)
		end
	},
})
type BLINK_EVENTS_SYMBOL = typeof(Returns)
return Returns :: BLINK_EVENTS_SYMBOL