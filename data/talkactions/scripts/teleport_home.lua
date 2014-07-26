function onSay(cid, words, param)
	local player = Player(cid)
	player:teleportTo(player:getTown():getTemplePosition())
	return false
end
