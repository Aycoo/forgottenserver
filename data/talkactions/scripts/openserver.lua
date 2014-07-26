function onSay(cid, words, param)
	local player = Player(cid)
	Game.setGameState(GAME_STATE_NORMAL)
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Server is now open.")
	return false
end
