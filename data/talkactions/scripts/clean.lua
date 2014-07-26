function onSay(cid, words, param)
	local player = Player(cid)
	local itemCount = cleanMap()
	if itemCount > 0 then
		player:sendTextMessage(MESSAGE_STATUS_WARNING, "Cleaned " .. itemCount .. " item" .. (itemCount > 1 and "s" or "") .. " from the map.")
	end
	return false
end
