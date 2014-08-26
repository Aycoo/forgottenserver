function onSay(cid, words, param)
	
	local player = Player(cid)
	local t = param:split(",")
	
	if(not t[2]) then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Invalid param specified.")
		return false
	end

	local toPlayer = Player(t[1])
	
	if( not toPlayer ) then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Player " .. t[1] .. " not found.")
		return false
	end
	
	if ( not tonumber(t[2])) then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Storage key must be a number.")	
		return false
	end

	if( not t[3]) then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE," [" .. t[1] .. " - " .. t[2] .. "] = " .. player:getStorageValue(tonumber(t[2])))
	else
		if (not tonumber(t[3]))  then
			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Storage value must be a number.")	
			return false
		end
		player:setStorageValue(tonumber(t[2]), tonumber(t[3]))
	end

	return false
end
