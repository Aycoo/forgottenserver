function onAdvance(cid, skill, oldLevel, newLevel)
	local player = Player(cid)
	
	if skill == SKILL_LEVEL then
		player:setRate( SKILL_LEVEL, Game:getExperienceStage( player:getLevel( ) ) )
	end
	
	return true
end
