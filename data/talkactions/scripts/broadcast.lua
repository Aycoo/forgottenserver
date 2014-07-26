function onSay(cid, words, param)
	local player = Player(cid)
	print("> " .. player:getName() .. " broadcasted: \"" .. param .. "\".")
	for _, tmpPlayer in ipairs(Game.getPlayers()) do
		tmpPlayer:sendPrivateMessage(player, param, TALKTYPE_BROADCAST)
	end
	return false
end
