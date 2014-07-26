function onSay(cid, words, param)
	local player = Player(cid)
	player:setHiddenHealth(not player:isHealthHidden())
	return false
end
