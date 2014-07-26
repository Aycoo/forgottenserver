function onSay(cid, words, param)
	local player = Player(cid)
	player:getPosition():sendMagicEffect(tonumber(param))
	return false
end
