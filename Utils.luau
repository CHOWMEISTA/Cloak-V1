local Players = game:GetService("Players")

local Utils = {}

function Utils.isAdmin(player: Player, config): boolean
	if game.CreatorType == Enum.CreatorType.User and player.UserId == game.CreatorId then
		return true
	end
	return config.AdminIds[player.UserId] == true
end

function Utils.getTargets(targetName: string?, speaker: Player): { Player }
	if not targetName or targetName == "" or string.lower(targetName) == "me" then
		return { speaker }
	end
	
	targetName = string.lower(targetName)
	if targetName == "all" then
		return Players:GetPlayers()
	end
	
	local found: { Player } = {}
	for _, plr in Players:GetPlayers() do
		local nameMatch = string.find(string.lower(plr.Name), targetName, 1, true)
		local displayMatch = string.find(string.lower(plr.DisplayName), targetName, 1, true)
		if nameMatch or displayMatch then
			table.insert(found, plr)
		end
	end
	return found
end

return Utils
