function onSay(cid, words, param)
	local player = Player(cid)
	local town = Town(param)
	if town == nil then
		player:sendCancelMessage("Town not found.")
		return false
	end

	player:teleportTo(town:getTemplePosition())
	return false
end
