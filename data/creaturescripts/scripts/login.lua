function onLogin(cid)
	local player = Player(cid)

	local loginStr = "Welcome to " .. configManager.getString(configKeys.SERVER_NAME) .. "!"
	if player:getLastLoginSaved() <= 0 then
		loginStr = loginStr .. " Please choose your outfit."
		player:sendOutfitWindow()
	else
		if loginStr ~= "" then
			player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)
		end

		loginStr = string.format("Your last visit was on %s.", os.date("%a %b %d %X %Y", player:getLastLoginSaved()))
	end
	player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)

	player:registerEvent("PlayerDeath")
	player:registerEvent("Management")
	player:registerEvent("AdvanceStages")
	
	player:setRate( SKILL_LEVEL, Game:getExperienceStage( player:getLevel( ) ) )
	player:setRate( SKILL_MAGLEVEL, configManager.getNumber( configKeys.RATE_MAGIC ) ) 
	
	for skillType = SKILL_FIST,SKILL_FISHING do
		player:setRate( skillType, configManager.getNumber( configKeys.RATE_SKILL ) ) 
	end
	
	return true
end
