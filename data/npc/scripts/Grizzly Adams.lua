local keywordHandler = KeywordHandler:new()
local npcHandler     = NpcHandler:new(keywordHandler)

NpcSystem.parseParameters(npcHandler)
 
function onCreatureAppear(cid)                          npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid)                       npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg)                  npcHandler:onCreatureSay(cid, type, msg) end
function onThink()                                      npcHandler:onThink() end
 

local taskChoose = {}

local goingToDoTaskMessages =
{
	"Happy hunting, old chap! Speak to me again when you are done hunting.",
	"Nice! Speak to me again when you are done hunting.",
	"Happy hunting, old chap! Return here when you are done hunting."
}

local rankPromotionMsg =
{
	[ PawFurRank.Huntsman ] = {
		"You have completed %d tasks! Let me promote you to the first rank: Huntsman. Congratulations! ...",
		"If you find any trophies that you don't need, feel free to ask me for a trade."
	},
	[ PawFurRank.Ranger ] = 
	{
		"You have completed %d hunting tasks. It's time for a promotion. You advance to the rank of 'Ranger'. Congratulations! ...",
		"Oh, I made a deal with Lorek. He ships Rangers from our society - and higher ranks of course - to Banuta, Chor or near the mountain pass to Darama. Just ask him for a passage."
	},
	[ PawFurRank.BigGameHunter ] = 
	{
		"Good show! You have completed %d hunting tasks for the 'Paw and Fur - Hunting Elite. You have earned the right to join the ranks of those known as 'Big game hunter'. Congratulations! ...",
		"From now on I'll buy more trophies from you!"
	},
	[ PawFurRank.TrophyHunter ] = 
	{
		"Spiffing! You have done %d hunting tasks! From now on you can call yourself a 'Trophy hunter'. As a reward I have this special backpack for you and in addition you can sell some more rare trophies to me."
	},
	[ PawFurRank.EliteHunter ] = 
	{
		"Congratulations! You have made the highest rank: 'Elite hunter'. If haven't yet done so ask me for the {special task}."
	}
}

local function buildTasksStringList( tasks )

	local result = {}
	
	if #tasks > 5 then
		local text1 = "Alright, what would you like to hunt? You can try "
		local text2 = " as well as "
		
		local s1 = ""
		local s2 = ""
		
		for i = 1,5 do
			s1 = s1 .. "{" .. pawFurQuest.tasks[ tasks[ i ] ].raceName .. "}" .. ", "
		end
		
		s1 = s1 .. "..."
	
		for i = 6,#tasks do
			local s = ""
			if i > 6 then
				if i == #tasks then
					s = " and "
				else
					s = ", "
				end
			end
			s2 = s2 .. s .. "{" .. pawFurQuest.tasks[ tasks[ i ] ].raceName .. "}"
			
		end	
		
		text1 = text1 .. s1
		text2 = text2 .. s2 .. "."
		table.insert( result, text1 )
		table.insert( result, text2 )
		
	else
		
		local text = "Alright, what would you like to hunt? You can try "
		for i = 1,#tasks do
			local s = ""
			if i > 1 then
				if i == #tasks then
					s = " and "
				else
					s = ", "
				end
			end
			text = text .. s .. "{" .. pawFurQuest.tasks[ tasks[ i ] ].raceName .. "}"
		end
		
		table.insert( result, text )
	end
	
	return result
end

local function finishCompletedTasks( cid )

	local player         = Player( cid )
	
	--get the opened tasks which player has completed the kill requirement
	local completedTasks = pawFurQuest:getCompletedTasks( player )
	
	-- no tasks to finish
	if #completedTasks == 0 then
		return false
	end
	
	-- pick the first
	local taskId = completedTasks[ 1 ]

	if pawFurQuest:taskHasBoss( taskId ) then
	
		--killed the boss, now we should try to finish the task
		if pawFurQuest:getTaskStatus( player, taskId ) == TaskStatus.BossKilled then
		
			if pawFurQuest:finishTask( player, taskId ) then
			
				player:sendTextMessage( MESSAGE_STATUS_CONSOLE_ORANGE,string.format( "Congratulations! You have finished the task: %s!", pawFurQuest.tasks[ taskId ].raceName ) )
				
				npcHandler:say("If you're up for another hunting mission just ask me for a task.", cid) 
			else	
				--todo, error, should never fail
				return true
			end
	
		else

			pawFurQuest:setTaskStatus( player, taskId, TaskStatus.BossStarted )
			
			local bossId   = pawFurQuest:getBossIdByTaskId( taskId )
						
			local bossData = pawFurQuest.bosses[ bossId ]
			
			npcHandler:say( bossData.goingToKillMessage, cid )
			
		end
		
	else
		-- Se não tem boss simplesmente dá os premios e termina a task
		if pawFurQuest:finishTask( player, taskId ) then
			npcHandler:say("If you're up for another hunting mission just ask me for a task.", cid)
		end
		
	end
	
	return true
end

local function tasksPart( cid, msg )
	local player = Player( cid )
	
	if npcHandler.topic[ cid ] == 2 then
	
		local tasks = pawFurQuest:getTasksThatPlayerCanDo( player )
		
		if #tasks > 0 then
		
			
			local tasksStringList = buildTasksStringList( tasks )
	
			if pawFurQuest:playerHasMaxRank( player ) then
				table.insert( tasksStringList, 1, string.format( "You may not advance in your rank anymore until you've levelled up. But you can accept tasks without getting Paw & Fur points, just for an experience reward and the possibility to fight a boss from the range lower than level %d. ...", PawFurRanks[ pawFurQuest:getPlayerRank( player ) ].endLevel + 1 ) )
			end
			
			npcHandler:say( tasksStringList, cid )
			
			npcHandler.topic[ cid ] = 6
			
		else
			if pawFurQuest:playerHasMaxRank( player ) then
				local msg = 
				{
					"Ah, okay. This time you'll just get an experience reward, no points for our society as you already gained enough points for your level range. Ask me for a {boss} and the choice is yours. ...",
					" Level up and new tasks and thus points will be available."
				}
				
				npcHandler:say( msg, cid )
			else
				npcHandler:say("You don't have any more task to do.", cid)
			end
			npcHandler.topic[ cid ] = 0
			
		end
		
	elseif npcHandler.topic[ cid ] == 6 then
	
		local taskId = pawFurQuest:getTaskIdByName( msg )
		if taskId then
		
			if pawFurQuest:canStartTask( player, taskId ) then
				taskChoose[ cid ] = taskId
				if pawFurQuest:playerHasMaxRank( player ) then
					npcHandler:say( string.format( "You already achieved the maximum rank for your level range. If you accept this task, you won't gain points for our society. Hunt %d %s and you'll be rewarded with experience and the possibility to choose a boss. Are you in, old chap?",pawFurQuest.tasks[ taskId ].killsRequired, pawFurQuest.tasks[ taskId ].raceName ), cid )
				else
					npcHandler:say( pawFurQuest.tasks[ taskId ].message, cid )
				end
				npcHandler.topic[ cid ] = 7
				
			else
				npcHandler:say("For some reason you cannot do this task, sorry..", cid)
				npcHandler.topic[ cid ] = 0			
			end
		else
			npcHandler:say("I cannot understand you.", cid)
			npcHandler.topic[ cid ] = 0
		end
		
	elseif npcHandler.topic[ cid ] == 7 then
	
		if msg == "yes" then
			pawFurQuest:startTask( player, taskChoose[ cid ] )
			npcHandler:say( goingToDoTaskMessages[ math.random( 1, #goingToDoTaskMessages ) ], cid )
			npcHandler.topic[ cid ] = 0
		elseif msg == "no" then
			npcHandler:say("No problem old chap. Come back if you change your mind.", cid)
			npcHandler.topic[ cid ] = 0
		else
			npcHandler:say("I cannot understand you, try later.", cid)
			npcHandler.topic[ cid ] = 0
		end
		
	end
	
	return true
end

local function deleteTaskPart( cid, msg )

	local player = Player( cid )
	
	if ( npcHandler.topic[ cid ] == 0 ) then
	
		npcHandler:say( "You've three unfinished tasks running old chap. If you want to accept a new one, you have to delete one of your old ones. Do you want to delete a task?", cid )
		
		npcHandler.topic[ cid ] = 8
		
	elseif ( npcHandler.topic[ cid ] == 8 ) then
	
		if ( msg == "yes" ) then
			npcHandler.topic[ cid ] = 9
			npcHandler:say( "Well, which one do you want to delete? Please name the monster that you don't want to hunt.", cid )
			
		elseif ( msg == "no" ) then
			npcHandler:say("No problem old chap. Come back if you change your mind.", cid)
			npcHandler.topic[ cid ] = 0		
		end
		
	elseif ( npcHandler.topic[ cid ] == 9 ) then
	
		local taskId = pawFurQuest:getTaskIdByName( msg )
		if taskId then
		
			local tasksOpen = pawFurQuest:getOpenTasks( player )
			if isInArray( tasksOpen, taskId ) then
				taskChoose[ cid ] = taskId
				npcHandler:say( "Do you really want to delete this task?", cid )
				npcHandler.topic[ cid ] = 10
			else
				npcHandler:say("You are not doing this task so i cannot cancel it.", cid)
				npcHandler.topic[ cid ] = 0						
			end
			
		else
			npcHandler:say("I cannot understand you, try again.", cid)
		end
		
	elseif ( npcHandler.topic[ cid ] == 10 ) then
	
		if ( msg == "yes" ) then
			npcHandler.topic[ cid ] = 0
			pawFurQuest:cancelTask( player, taskChoose[ cid ] )
			npcHandler:say( "As you wish. Ask me for a new task old chap.", cid )
			
		elseif ( msg == "no" ) then
			npcHandler:say("No problem old chap. Come back if you change your mind.", cid)
			npcHandler.topic[ cid ] = 0		
		end
		
	end
	
	return true
end

local function promotionPart( cid, msg )

	local player = Player( cid )
	
	if npcHandler.topic[ cid ] == 0 then
		local ok, newRank = pawFurQuest:advanceRank( player )
		if ok then
			local tasksDoneCount = #pawFurQuest:getTasksAlreadyDone( player )
			
			local t = {}
			for _,str in ipairs( rankPromotionMsg[ newRank ] ) do
				table.insert( t, string.format( str, tasksDoneCount ) )
			end
			
			npcHandler:say( t, cid)
		else
			npcHandler:say( "Sorry, i cannot grant you a promotion.", cid )
		end
	end
	
	return true
end

local function tradePart( cid, msg )

	local player = Player( cid )
	
	if npcHandler.topic[ cid ] == 0 then
		if pawFurQuest:playerCanTrade( player ) then
			pawFurQuest:playerTrade( player )
			return npcHandler:say('It\'s my offer.', cid)
		else
			return npcHandler:say( 'You don\'t have any rank.', cid )
		end
	end
	
	return true
end

local function becameMemberPart( cid, msg )

	-- becoming a member
	
	local player = Player( cid )
	
	if ( isInArray( { "yes", "join" }, msg:lower( ) ) ) then 
	
		--just to be sure
		if pawFurQuest:isMember( player ) then
			npcHandler.topic[ cid ] = 0
			return npcHandler:say("You already are a member.", cid)
		end
		
		npcHandler:say("Great! A warm welcome to our newest member: |PLAYERNAME|! Ask me for a {task} if you want to go on a hunt.", cid)
		npcHandler.topic[ cid ] = 0
		
		pawFurQuest:becameMember( player )
		
	elseif ( msg:lower( ) == "no" ) then
		npcHandler:say("No problem old chap. Come back if you change your mind.", cid)  
		npcHandler.topic[ cid ] = 0
	else
		npcHandler:say("I cannot understand you, try again.", cid) 
		npcHandler.topic[ cid ] = 0
	end	
	
	return true
end

local function specialTasksPart( cid, msg )
	
	local player = Player( cid )
	
	if npcHandler.topic[ cid ] == 0 then
		if ( player:getLevel() >= 90 ) and ( pawFurQuest:getPlayerRank( player ) >= PawFurRank.TrophyHunter ) then
			
			local tiquandaId = pawFurQuest:getBossIdByName( "Tiquandas Revenge" )
			
			if pawFurQuest:alreadyKilledBoss( player, tiquandaId ) then
				if pawFurQuest:getBossStatus( player, tiquandaId ) == BossStatus.Killed then
					pawFurQuest:setBossStatus( player, tiquandaId, BossStatus.NotStarted )
					npcHandler:say( " Great accievement, old chap! You are an outstanding hunter, no doubt about it!", cid )
					return true
				end
				
				local demodrasId = pawFurQuest:getBossIdByName( "Demodras" )
				
				if pawFurQuest:alreadyKilledBoss( player, demodrasId ) then
					if pawFurQuest:getBossStatus( player, demodrasId ) == BossStatus.Killed then
						pawFurQuest:setBossStatus( player, demodrasId, BossStatus.NotStarted )
						npcHandler:say( "Jolly good show! You can cross swords with any creature in this world! I bow to you.", cid )
					end
				else
					pawFurQuest:setBossStatus( player, demodrasId, BossStatus.GoingToKill )
					npcHandler:say( pawFurQuest.bosses[ demodrasId ].goingToKillMessage, cid )
				end
				
			else
				pawFurQuest:setBossStatus( player, tiquandaId, BossStatus.GoingToKill )
				npcHandler:say( pawFurQuest.bosses[ tiquandaId ].goingToKillMessage, cid )
				return true
			end
		else
			return npcHandler:say( "You are an eager one. Your rank within our hunting elite is great buuuut I believe you're a little inexperienced for the special tasks. Gain more experience and then you will be equal to the special task! I don't want to send you to your death!", cid )
		end
	end
	
	return true
end

local function takeBossPart( cid, msg )
	local player = Player( cid )
	
	for bossId, bossData in ipairs( pawFurQuest.bosses ) do
		if not bossData.special then
			if pawFurQuest:getBossStatus( player, bossId ) == BossStatus.Killed then
				pawFurQuest:setBossStatus( player, bossId, NotStarted )
				pawFurQuest:giveRewards( player, bossData.rewards )
				npcHandler:say( "Good job, old chap.", cid )
				return true
			end
		end
	end
	
	if pawFurQuest:getBossPoints( player ) > 0 then
		
		local bosses = pawFurQuest:getBossPlayerCanDo( player )
		if #bosses > 0 then
			if npcHandler.topic[ cid ] == 0 then
			
				local bossesStr = "You can choose between the "
				if #bosses > 0 then
					for _,bossId in ipairs( bosses ) do
						local comma = ", "
						if _ + 1 == #bosses then
							comma = " and "
						elseif _ == #bosses then
							comma = "."
						end
						bossesStr = bossesStr .. "{" .. pawFurQuest.bosses[ bossId ].name .. "}".. comma 
					end
				else
					bossesStr = "You can choose {" .. pawFurQuest.bosses[ bosses[ 1 ] ].name .. "}."
				end
				
				npcHandler:say( bossesStr, cid )
				
				npcHandler.topic[ cid ] = 12
				
				return true
			elseif npcHandler.topic[ cid ] == 12 then
				local bossId = pawFurQuest:getBossIdByName( msg:lower() )
				if bossId and isInArray( bosses, bossId ) then
					pawFurQuest:setBossStatus( player, bossId, BossStatus.GoingToKill )
					npcHandler:say( "Find its hideout and kill it!", cid )
					
					local playerRank = pawFurQuest:getPlayerRank( player )
					
					if playerRank == PawFurRank.EliteHunter then
						local taskId = pawFurQuest:getTaskIdByBossId( bossId )
						if pawFurQuest.tasks[ taskId ].rank == PawFurRank.EliteHunter then
							pawFurQuest:setBossPoints( player, pawFurQuest:getBossPoints( player ) - 1 )
						end
					else
						pawFurQuest:setBossPoints( player, pawFurQuest:getBossPoints( player ) - 1 )
					end
				else
					npcHandler:say( "I cannot understand you.", cid )
					npcHandler.topic[ cid ] = 0
					
					return true
				end
			end
			
		else
			return npcHandler:say( "You do not have any boss to choose.", cid )
		end
	else
		return npcHandler:say( "You do not have any boss point.", cid )
	end
	
	return true
end

local function creatureSayCallback(cid, type, msg)

	local player = Player( cid )
	
	-- Greeting. There are different types of greeting from grizzly adams, based on CipTibia.
	
	if ( msgcontains(msg, "hi") or msgcontains(msg, "hello") ) and ( not npcHandler:isFocused( cid ) ) then
	
		if (  not pawFurQuest:isMember( player ) ) then
		
			npcHandler:say( "Welcome |PLAYERNAME|. Would you like to join the 'Paw and Fur - Hunting Elite?", cid )
			npcHandler.topic[ cid ] = 1
			
		elseif pawFurQuest:canAdvanceRank( player ) then
		
			local tasksDoneCount = #pawFurQuest:getTasksAlreadyDone( player )
			
			if tasksDoneCount < 40 then
				npcHandler:say( string.format( "You have completed %d tasks for our society. Ask me for a {promotion} to advance your rank!",tasksDoneCount ), cid ) 
			else
				npcHandler:say( string.format( "By the gods....%d hunting tasks....this is austoding! Ask me for a promotion to advance your rank! And while you are here, I also have another special task for you.",tasksDoneCount ), cid ) 
			end
			
		else
		
			npcHandler:say( "Welcome to the 'Paw and Fur - Hunting Elite' |PLAYERNAME|. Feel free to do {tasks} for us.", cid )
			
		end
		
		npcHandler:addFocus( cid )
		
		return true
	end
	
	if( not npcHandler:isFocused( cid ) ) then
		return false
	end
	
	if ( msgcontains(msg, "bye") or msgcontains(msg, "farewell") ) then
		npcHandler:say( "Happy hunting, old chap!",cid )
		npcHandler:resetNpc( cid )
		npcHandler:releaseFocus( cid )
		return true
	end	
	
	--- index
	
	if ( npcHandler.topic[ cid ] == 0 ) then 
		
		if ( not pawFurQuest:isMember( player ) ) then
		
			npcHandler:say("You'll have to {join} us to get more information. Would you like to join the 'Paw and Fur - Hunting Elite?",cid)
			npcHandler.topic[ cid ] = 1
			return true
			
		end
		
		if msg:lower() == 'promotion' then
			return promotionPart( cid, msg )
		end
		
		--make sure that player always have the right rank
		if pawFurQuest:canAdvanceRank( player ) then
			npcHandler:say( "You are ready to advance one rank in our society Darly. Ask me for a {promotion} first.", cid )
			return true
		end
		
		if ( msg:lower( ) == 'task' ) or ( msg:lower() == 'mission' ) then
		
			
			if finishCompletedTasks( cid ) then
				return true
			else
				
				local openTasks = pawFurQuest:getOpenTasks( player )
				--you have three tasks, so you should delete one
				if #openTasks >= PawFurConfig.tasksByPlayer then
					return deleteTaskPart( cid, msg )
				end
				
				--part which player take the tasks
				npcHandler.topic[ cid ] = 2
			end
			
		elseif msg:lower() == 'tasks' then
			
			local openTasks = pawFurQuest:getOpenTasks( player )
			--you have three tasks, so you should delete one
			if #openTasks >= PawFurConfig.tasksByPlayer then
				return deleteTaskPart( cid, msg )
			else
				--part which player take the tasks
				npcHandler.topic[ cid ] = 2
			end
		elseif msg:lower() == 'boss' then
			return takeBossPart( cid, msg )
		elseif msg:lower() == 'trade' then
			return tradePart( cid, msg )
		elseif msg:lower() == 'special task' then
			return specialTasksPart( cid, msg )
		end

	end
	
	--taking tasks
	if ( npcHandler.topic[ cid ] == 1 ) then
		return becameMemberPart( cid, msg )
	elseif ( npcHandler.topic[ cid ] == 2 ) or ( npcHandler.topic[ cid ] == 6 ) or ( npcHandler.topic[ cid ] == 7 ) then
		return tasksPart( cid, msg )
	--deleting tasks
	elseif ( npcHandler.topic[ cid ] == 8 ) or ( npcHandler.topic[ cid ] == 9 ) or ( npcHandler.topic[ cid ] == 10 ) then
		return deleteTaskPart( cid, msg )
	elseif ( npcHandler.topic[ cid ] == 12 ) then
		return takeBossPart( cid, msg )
	end
	
end
 
 
npcHandler:setMessage(MESSAGE_FAREWELL, "Happy hunting, old chap!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)