function onSay(cid, words, param)
	local player = Player(cid)
	local position = player:getPosition()
	position.z = position.z - 1
	player:teleportTo(position)
	return false
end
