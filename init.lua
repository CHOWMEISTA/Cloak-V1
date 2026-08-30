--!strict
-- Cl0/\K-\/1 Admin System
local Players = game:GetService("Players")

local BASE_URL = "https://raw.githubusercontent.com/YOUR_USERNAME/Cloak-V1/main/"

local function loadModule(fileName: string)
	local content = game:HttpGet(BASE_URL .. fileName)
	local fn, err = loadstring(content)
	if not fn then
		error("[Cl0/\\K-\\v1 Error] Failed to compile " .. fileName .. ": " .. tostring(err))
	end
	return fn()
end

-- Load sub-modules from GitHub
local Config = loadModule("Config.luau")
local Utils = loadModule("Utils.luau")
local CommandFactory = loadModule("Commands.luau")

local commands = CommandFactory(Utils)

-- Command Processing Logic
local function parseCommand(player: Player, message: string)
	if not Utils.isAdmin(player, Config) then return end
	if string.sub(message, 1, #Config.Prefix) ~= Config.Prefix then return end
	
	local rawContent = string.sub(message, #Config.Prefix + 1)
	local args = string.split(rawContent, " ")
	local cmdName = string.lower(table.remove(args, 1) or "")
	
	if commands[cmdName] then
		commands[cmdName](player, args)
	end
end

-- Hook Player Events
local function onPlayerAdded(player: Player)
	player.Chatted:Connect(function(message)
		parseCommand(player, message)
	end)
end

for _, plr in Players:GetPlayers() do
	onPlayerAdded(plr)
end
Players.PlayerAdded:Connect(onPlayerAdded)

print([[
=======================================
   Cl0/\K-\/1 Admin System Loaded!
=======================================
]])
