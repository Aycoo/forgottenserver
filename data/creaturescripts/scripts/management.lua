local banReasons =
{
	"Rule Violation",
	"Spamming",
	"Power Abuse",
	"Third Party Software",
	"Cave Botting",
	"Bug Abuse"
}

local banLengths =
{
	{60, "1 minute"},
	{10 * 60, "2 minutes"},
	{30 * 60, "30 minutes"},
	{1 * 60 * 60, "1 hour"},
	{12 * 60 * 60, "12 hours"},
	{1 * 24 * 60 * 60, "1 day"},
	{5 * 24 * 60 * 60, "5 days"},
	{10 * 24 * 60 * 60, "10 days"},
	{15 * 24 * 60 * 60, "15 days"},
	{30 * 24 * 60 * 60, "30 days"}
}

local addItems =
{
	{"magic sword", 1, false},
	{"sudden death rune", 100, true},
	{"golden helmet", 1, false},
	{"amulet of loss", 1, false},
	{"gold coin", 100, true},
	{"platinum coin", 50, true},
	{"crystal coin", 1, true}
}

-- don't touch below, if you don't know what you do!
local managementOptions =
{
	Player = {1, "Players"},
	NPC = {2, "NPCs"},
	Monster_Type = {3, "Monsters"},
	House = {4, "Houses"},
	Spawn_NPC = {5, "Spawn NPC"},
	Spawn_Monster = {6, "Spawn Monster"},
	Tp_Players_To_Temple = {7, "Teleport players to temple"}
}

local playersOptions =
{
	Info = {1, "Info"},
	Kick_Player = {2, "Kick Player"},
	Ban_Player = {3, "Ban Player"},
	Teleport_To_Player = {4, "Teleport to Player"},
	Teleport_Player_To_You = {5, "Teleport Player to You"},
	Add_Item = {6, "Add Item"},
	Remove_Item = {7, "Remove Item"},
	Add_Level = {8, "Add Level"},
	Add_Skills = {9, "Add Skills"},
	Add_Magic_Level = {10, "Add Magic Level"},
	Change_Town = {11, "Change Town"},
	Promote_Player = {12, "Promote Player"},
	Add_Premium = {13, "Add 7 Premium Days"},
	Change_Gender = {14, "Change Gender"},
	IP_Ban_Player = {15, "IP Ban Player"}
}

local npcsOptions =
{
	Remove_NPC = {1, "Remove NPC"},
	Teleport_To_NPC = {2, "Teleport to NPC"},
	Teleport_NPC_To_You = {3, "Teleport NPC to You"},
	Change_Speed = {4, "Change Speed"},
	Give_Skull = {5, "Give the NPC a Skull"},
	Give_Shield = {6, "Give the NPC a Shield"}
}

local monstersOptions =
{
	Info = {1, "Info"},
	Remove_Monster = {2, "Remove Monster"},
	Teleport_To_NPC = {3, "Teleport to Monster"},
	Teleport_NPC_To_You = {4, "Teleport Monster to You"},
	Change_Speed = {5, "Change Speed"},
	Change_Max_Health = {6, "Change Max Health"},
	Give_Skull = {7, "Give the NPC a Skull"},
	Give_Shield = {8, "Give the NPC a Shield"}
}

local skillsOptions =
{
	[0] = "Fist Fighting",
	[1] = "Club Fighting",
	[2] = "Sword Fighting",
	[3] = "Axe Fighting",
	[4] = "Distance Combat",
	[5] = "Shield",
	[6] = "Fishing"
}

local promoteOptions =
{
	"Player",
	"Tutor",
	"Senior Tutor",
	"Gamemaster",
	"GOD"
}

playerOptionChoices = {}
addChoices = {}
removeChoices = {}
banChoices = {}
skillChoices = {}
townChoices = {}
promoteChoices = {}
banReasonChoices = {}
npcOptionChoices = {}
npcSpeedChoices = {}
banType = {}

function onModalWindow(cid, modalWindowId, buttonId, choiceId)
	local player = Player(cid)
	if state[player:getId()] == nil then
		state[player:getId()] = 1
	end
	--######Management######--
	if modalWindowId == windows.Management then
		state[player:getId()] = 1
		if buttonId == 0x00 then
			if choiceId == managementOptions.Player[1] then -- Players
				state[player:getId()] = 1
				if Game.getPlayerCount() > 0 then
					playerChoices = {}
					onlinePlayers = {}
					for k, v in pairs(getOnlinePlayers()) do
						table.insert(onlinePlayers, v)
					end
					table.sort(onlinePlayers)
					playerChoices = cacheData1(onlinePlayers, state[player:getId()])
					createWindowWithButtons(player, players, windows.Management_Players, "Players List", "Select Player", preButtons, playerChoices, true, false)
				else
					createWindowWithButtons(player, management, windows.Management, "Management", "Ingame Administration Tool:\nCreated by Evil Hero @ otland", managementButtons, managementChoices, true, false)
				end
			elseif choiceId == managementOptions.NPC[1] then -- NPCs
				if Game.getNpcCount() > 0 then
					npcChoices = {}
					onlineNpcs = {}
					npcButtons = {{id = 0x00, text = "Select", enter = false, escape = false}, {id = 0x01, text = "End", enter = false, escape = true}, {id = 0x02, text = "Back", enter = false, escape = false}, {id = 0x03, text = "TP", enter = true, escape = false}}
					for k, v in pairs(getOnlineNpcs()) do
						onlineNpcs[#onlineNpcs == nil and 1 or #onlineNpcs + 1] = {}
						onlineNpcs[#onlineNpcs][1] = v[1]
						onlineNpcs[#onlineNpcs][2] = v[2]
					end
					npcChoices = cacheData2(onlineNpcs, state[player:getId()])
					createWindowWithButtons(player, npcs, windows.Management_NPC, "NPC List", "Select NPC", npcButtons, npcChoices, true, false)
				else
					createWindowWithButtons(player, management, windows.Management, "Management", "Ingame Administration Tool:\nCreated by Evil Hero @ otland", managementButtons, managementChoices, true, false)
				end
			elseif choiceId == managementOptions.Monster_Type[1] then -- Monsters
				if Game.getMonsterCount() > 0 then
					monsterTypeChoices = {}
					monsterType = {}
					for k,v in pairs(monsters) do
						table.insert(monsterType, k)
					end
					table.sort(monsterType)
					monsterTypeChoices = cacheData1(monsterType, state[player:getId()])
					createWindowWithButtons(player, monsters1, windows.Management_Monster_Type, "Monster Type List", "Select Monster Type", preButtons, monsterTypeChoices, true, false)
				else
					createWindowWithButtons(player, management, windows.Management, "Management", "Ingame Administration Tool:\nCreated by Evil Hero @ otland", managementButtons, managementChoices, true, false)
				end
			elseif choiceId == managementOptions.Tp_Players_To_Temple[1] then -- teleport all players to temple
				local online = getOnlinePlayers()
				local counter = 0
				for k,v in pairs(online) do
					local tpPlayer = Player(v)
					if tpPlayer then
						doTeleportThing(tpPlayer, tpPlayer:getTown():getTemplePosition(), true)
						tpPlayer:sendTextMessage(22, "You have been teleported to temple")
						counter = counter + 1
					end
				end
				player:sendTextMessage(22, "You have successfully teleported ".. counter .."/".. #online .." players to temple")
				createWindowWithButtons(player, management, windows.Management, "Management", "Ingame Administration Tool:\nCreated by Evil Hero @ otland", managementButtons, managementChoices, true, false)
			end
		end
	end
	
	--######Player######--
	if modalWindowId == windows.Management_Players then
		if buttonId == 0x00 then
			if choiceId == ((state[player:getId()] * 50) < #onlinePlayers and 52 or ((#onlinePlayers - (((state[player:getId()] - 1) * 50) + 1) + 2))) then
				state[player:getId()] = state[player:getId()] - 1
				playerChoices = cacheData1(onlinePlayers, state[player:getId()])
				createWindowWithButtons(player, players, windows.Management_Players, "Players List", "Select Player", preButtons, playerChoices, true, false)
			elseif choiceId == ((state[player:getId()] * 50) < #onlinePlayers and 51 or ((#onlinePlayers - (((state[player:getId()] - 1) * 50) + 1 ) + 2))) then
				state[player:getId()] = state[player:getId()] + 1
				playerChoices = cacheData1(onlinePlayers, state[player:getId()])
				createWindowWithButtons(player, players, windows.Management_Players, "Players List", "Select Player", preButtons, playerChoices, true, false)
			else
				tmpPlayer = getPlayerByName(onlinePlayers[choiceId + (state[player:getId()] == 1 and 0 or ((state[player:getId()] - 1) * 50))])
				tmpPlayerName = onlinePlayers[choiceId + (state[player:getId()] == 1 and 0 or ((state[player:getId()] - 1) * 50))]
				target = Player(tmpPlayerName)
				state[player:getId()] = 1
				for k,v in pairs(playersOptions) do
					playerOptionChoices[v[1]] = {}; playerOptionChoices[v[1]].id = v[1]; playerOptionChoices[v[1]].text = v[2]
				end
				createWindowWithButtons(player, playersOptions, windows.Management_Players_Options, tmpPlayerName, "Select Option", preButtons, playerOptionChoices, true, false)
			end
		elseif buttonId == 0x02 then
			createWindowWithButtons(player, management, windows.Management, "Management", "Ingame Administration Tool:\nCreated by Evil Hero @ otland", managementButtons, managementChoices, true, false)
		end
	elseif modalWindowId == windows.Management_Players_Options then
		if buttonId == 0x00 then
			if choiceId == playersOptions.Kick_Player[1] then
				if tmpPlayer then
					local kickPlayer = Player(tmpPlayer)
					if kickPlayer ~= Player(cid) then
						kickPlayer:remove()
					end
				end
				createWindowWithButtons(player, playersOptions, windows.Management_Players_Options, tmpPlayerName, "Select Option", preButtons, playerOptionChoices, true, false)
			elseif choiceId == playersOptions.Teleport_To_Player[1] then
				if tmpPlayer then
					doTeleportThing(cid, getCreaturePosition(tmpPlayer), true)
				end
				createWindowWithButtons(player, playersOptions, windows.Management_Players_Options, tmpPlayerName, "Select Option", preButtons, playerOptionChoices, true, false)
			elseif choiceId == playersOptions.Teleport_Player_To_You[1] then
				if tmpPlayer then
					doTeleportThing(tmpPlayer, getCreaturePosition(cid), true)
				end
				createWindowWithButtons(player, playersOptions, windows.Management_Players_Options, tmpPlayerName, "Select Option", preButtons, playerOptionChoices, true, false)
			elseif choiceId == playersOptions.Info[1] then
				local p = Player(cid)
				local text = ""
				local playerInfo =
				{
					{"Name:", p:getName(), 2},{"Health Max:", p:getMaxHealth(), 1},{"Health:", p:getHealth(), 2},{"Mana Max:", p:getMaxMana(), 1},
					{"Mana:", p:getMana(), 2},{"Level:", p:getLevel(), 1},{"Soul Points:", p:getSoul(), 1},{"Capacity:", p:getCapacity(), 1},
					{"Experience:", p:getExperience(), 1},{"Vocation:", p:getVocation():getName(), 1},{"Town:", p:getTown():getName(), 2},
					{"Magic Level:", p:getMagicLevel(), 1},{"Fist:", p:getSkillLevel(SKILL_FIST), 1},{"Club:", p:getSkillLevel(SKILL_CLUB), 1},
					{"Sword:", p:getSkillLevel(SKILL_SWORD), 1},{"Axe:", p:getSkillLevel(SKILL_AXE), 1},{"Distance:", p:getSkillLevel(SKILL_DISTANCE), 1},
					{"Shielding:", p:getSkillLevel(SKILL_SHIELD), 1},{"Fishing:", p:getSkillLevel(SKILL_FISH), 1}
				}
				for k,v in pairs(playerInfo) do
					text = text .."".. v[1] .." "..v[2] ..""
					if k ~= #playerInfo then
						for i = 1, v[3] do
							text = text .."\n"
						end
					end
				end
				doShowTextDialog(cid,5958, text)
				createWindowWithButtons(player, playersOptions, windows.Management_Players_Options, tmpPlayerName, "Select Option", preButtons, playerOptionChoices, true, false)
			elseif choiceId == playersOptions.Add_Item[1] then
				for k, v in pairs(addItems) do
					addChoices[k] = {}; addChoices[k].id = k; addChoices[k].text = v[3] == true and v[1] .." ".. v[2] or v[1]
				end
				createWindowWithButtons(player, addItems, windows.Management_Players_Select_AddItem, tmpPlayerName, "Select an item to add:", preButtons, addChoices, true, false)
			elseif choiceId == playersOptions.Remove_Item[1] then
				if tmpPlayer then
					local ret = false
					local buttons = {{id = 0x01, text = "End", enter = false, escape = true}, {id = 0x02, text = "Back", enter = false, escape = true}}
					for i = 1, #getAllItemsById(tmpPlayer) do
						local itemType = ItemType(getAllItemsById(tmpPlayer)[i].itemid)
						local itemCount = getAllItemsById(tmpPlayer)[i].type
						removeChoices[i] = {}; removeChoices[i].id = i; removeChoices[i].text = itemCount > 0 and itemType:getName() .." ".. itemCount or itemType:getName()
						ret = true
					end
					if ret then
						buttons[#buttons+1] = {}; buttons[#buttons].id = 0x03; buttons[#buttons].text = "Delete 1"
						buttons[#buttons+1] = {}; buttons[#buttons].id = 0x04; buttons[#buttons].text = "Delete All"
					end
					createWindowWithButtons(player, removeItems, windows.Management_Players_Select_RemoveItem, tmpPlayerName, "Select an item to remove:", buttons, removeChoices, true, false)
				end
			elseif choiceId == playersOptions.Ban_Player[1] then
				banType[cid] = "Account Ban"
				for k,v in pairs(banReasons) do
					banChoices[k] = {}; banChoices[k].id = k; banChoices[k].text = v
				end
				createWindowWithButtons(player, banReasons, windows.Management_Players_Select_Ban_Reason, tmpPlayerName, "Select a ban reason:", preButtons, banChoices, true, false)
			elseif choiceId == playersOptions.Add_Level[1] then
				if tmpPlayer then
					local target = Player(tmpPlayerName)
					target:addExperience(getExpForLevel(target:getLevel()+1) - target:getExperience())
					doPlayerSendTextMessage(cid, 22, "You have advanced ".. tmpPlayerName .."\'s level by 1.")
					createWindowWithButtons(player, playersOptions, windows.Management_Players_Options, tmpPlayerName, "Select Option", preButtons, playerOptionChoices, true, false)
				end
			elseif choiceId == playersOptions.Add_Skills[1] then
				if tmpPlayer then
					skillButtons = {{id = 0x01, text = "End", enter = false, escape = true}, {id = 0x02, text = "Back", enter = false, escape = false}, {id = 0x03, text = "Add", enter = false, escape = false}}
					for k,v in pairs(skillsOptions) do
						skillChoices[k] = {}; skillChoices[k].id = k; skillChoices[k].text = v
					end
					createWindowWithButtons(player, skills, windows.Management_Players_Select_AddSkills, tmpPlayerName, "Select a skill to advance", skillButtons, skillChoices, true, false)
				end
			elseif choiceId == playersOptions.Add_Magic_Level[1] then
				if tmpPlayer then
					local target = Player(tmpPlayerName)
					target:addManaSpent(target:getVocation():getRequiredManaSpent(target:getBaseMagicLevel() + 1) - target:getManaSpent())
					doPlayerSendTextMessage(cid, 22, "You have advanced ".. tmpPlayerName .."\'s magic level by 1.")
					createWindowWithButtons(player, playersOptions, windows.Management_Players_Options, tmpPlayerName, "Select Option", preButtons, playerOptionChoices, true, false)
				end
			elseif choiceId == playersOptions.Change_Town[1] then
				if target then
					for i = 1, #Game.getTowns() do
						townChoices[i] = {}; townChoices[i].id = i; townChoices[i].text = Game.getTowns()[i]:getName()
					end
					createWindowWithButtons(player, town, windows.Management_Players_Select_ChangeTown, tmpPlayerName, "Select Town", preButtons, townChoices, true, false)
				end
			elseif choiceId == playersOptions.Promote_Player[1] then
				for i = 1, #promoteOptions do
					promoteChoices[i] = {}; promoteChoices[i].id = i; promoteChoices[i].text = promoteOptions[i]
				end
				createWindowWithButtons(player, promote, windows.Management_Players_Select_PromotePlayer, tmpPlayerName, "Select promotion type", preButtons, promoteChoices, true, false)
			elseif choiceId == playersOptions.Change_Gender[1] then
				local target = Player(tmpPlayerName)
				if target then
					target:setSex((target:getSex() == 0 and 1 or 0))
					doPlayerSendTextMessage(cid, 22, "You changed ".. tmpPlayerName .."\'s gender to ".. (target:getSex() == 0 and "Female" or "Male") ..".")
					createWindowWithButtons(player, playersOptions, windows.Management_Players_Options, tmpPlayerName, "Select Option", preButtons, playerOptionChoices, true, false)
				end
			elseif choiceId == playersOptions.Add_Premium[1] then
				local target = Player(tmpPlayerName)
				if target then
					target:addPremiumDays(7)
					createWindowWithButtons(player, playersOptions, windows.Management_Players_Options, tmpPlayerName, "Select Option", preButtons, playerOptionChoices, true, false)
				end
			elseif choiceId == playersOptions.IP_Ban_Player[1] then
				banType[cid] = "IP Ban"
				for k,v in pairs(banReasons) do
					banChoices[k] = {}; banChoices[k].id = k; banChoices[k].text = v
				end
				createWindowWithButtons(player, banReasons, windows.Management_Players_Select_Ban_Reason, tmpPlayerName, "Select a ban reason:", preButtons, banChoices, true, false)
			end
		elseif buttonId == 0x02 then
			createWindowWithButtons(player, players, windows.Management_Players, "Players List", "Select Player", preButtons, playerChoices, true, false)
		end
	elseif modalWindowId == windows.Management_Players_Select_AddItem then
		if buttonId == 0x00 then
			if tmpPlayer then
				local itemType = ItemType(addItems[choiceId][1])
				doPlayerAddItem(tmpPlayer, itemType:getId(), addItems[choiceId][2])
				createWindowWithButtons(player, addItems, windows.Management_Players_Select_AddItem, tmpPlayerName, "Select an item to add:", preButtons, addChoices, true, false)
			end
		elseif buttonId == 0x02 then
			createWindowWithButtons(player, playersOptions, windows.Management_Players_Options, tmpPlayerName, "Select Option", preButtons, playerOptionChoices, true, false)
		end
	elseif modalWindowId == windows.Management_Players_Select_RemoveItem then
		if buttonId == 0x03 then
			if tmpPlayer then
				local ret = false
				local itemType = ItemType(getAllItemsById(tmpPlayer)[choiceId].itemid)
				doPlayerRemoveItem(tmpPlayer, itemType:getId(), 1)
				local buttons = {{id = 0x01, text = "End", enter = false, escape = true}, {id = 0x02, text = "Back", enter = false, escape = true}}
				removeChoices = {}
				for i = 1, #getAllItemsById(tmpPlayer) do
					local itemType = ItemType(getAllItemsById(tmpPlayer)[i].itemid)
					local itemCount = getAllItemsById(tmpPlayer)[i].type
					removeChoices[i] = {}; removeChoices[i].id = i; removeChoices[i].text = itemCount > 0 and itemType:getName() .." ".. itemCount or itemType:getName()
					ret = true
				end
				if ret then
					buttons[#buttons+1] = {}; buttons[#buttons].id = 0x03; buttons[#buttons].text = "Delete 1"
					buttons[#buttons+1] = {}; buttons[#buttons].id = 0x04; buttons[#buttons].text = "Delete All"
				end
				createWindowWithButtons(player, removeItems, windows.Management_Players_Select_RemoveItem, tmpPlayerName, "Select an item to remove:", buttons, removeChoices, true, false)
			end
		elseif buttonId == 0x04 then -- remove all items of one count
			if tmpPlayer then
				local ret = false
				local itemType = ItemType(getAllItemsById(tmpPlayer)[choiceId].itemid)
				local itemCount = getAllItemsById(tmpPlayer)[choiceId].type
				doPlayerRemoveItem(tmpPlayer, itemType:getId(), itemCount)
				local buttons = {{id = 0x01, text = "End", enter = false, escape = true}, {id = 0x02, text = "Back", enter = false, escape = true}}
				removeChoices = {}
				for i = 1, #getAllItemsById(tmpPlayer) do
					local itemType = ItemType(getAllItemsById(tmpPlayer)[i].itemid)
					local itemCount = getAllItemsById(tmpPlayer)[i].type
					removeChoices[i] = {}; removeChoices[i].id = i; removeChoices[i].text = itemCount > 0 and itemType:getName() .." ".. itemCount or itemType:getName()
					ret = true
				end
				if ret then
					buttons[#buttons+1] = {}; buttons[#buttons].id = 0x03; buttons[#buttons].text = "Delete 1"
					buttons[#buttons+1] = {}; buttons[#buttons].id = 0x04; buttons[#buttons].text = "Delete All"
				end
				createWindowWithButtons(player, removeItems, windows.Management_Players_Select_RemoveItem, tmpPlayerName, "Select an item to remove:", buttons, removeChoices, true, false)
			end
		elseif buttonId == 0x02 then
			createWindowWithButtons(player, playersOptions, windows.Management_Players_Options, tmpPlayerName, "Select Option", preButtons, playerOptionChoices, true, false)
		end
	elseif modalWindowId == windows.Management_Players_Select_Ban_Reason then
		if buttonId == 0x00 then
			reason = banReasons[choiceId]
			for k,v in pairs(banLengths) do
				banReasonChoices[k] = {}; banReasonChoices[k].id = k; banReasonChoices[k].text = v[2]
			end
			createWindowWithButtons(player, banLength, windows.Management_Players_Select_Ban_Length, tmpPlayerName, "Select a ban length:", preButtons, banReasonChoices, true, false)
		elseif buttonId == 0x02 then
			createWindowWithButtons(player, playersOptions, windows.Management_Players_Options, tmpPlayerName, "Select Option", preButtons, playerOptionChoices, true, false)
		end
	elseif modalWindowId == windows.Management_Players_Select_Ban_Length then
		if buttonId == 0x00 then
			length = banLengths[choiceId][1]
			if banType[cid] == "Account Ban" then
				local accountId = getAccountNumberByPlayerName(tmpPlayerName)
				local timeNow = os.time()
				db:query("INSERT INTO `account_bans` (`account_id`, `reason`, `banned_at`, `expires_at`, `banned_by`) VALUES (" .. accountId .. ", '".. reason .."', " .. timeNow .. ", " .. timeNow + length .. ", " .. player:getGuid() .. ")")
				if target ~= nil then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, target:getName() .. " has been banned.")
					target:remove()
				else
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, target:getName() .. " has been banned.")
				end
			elseif banType[cid] == "IP Ban" then
				local resultId = db.storeQuery("SELECT `account_id`, `lastip` FROM `players` WHERE `name` = " .. db.escapeString(tmpPlayerName))
				local ip = result.getDataInt(resultId, "lastip")
				result.free(resultId)
				local targetCid = getPlayerByName(tmpPlayerName)
				if targetCid ~= false then
					ip = getIpByName(tmpPlayerName)
					doRemoveCreature(targetCid)
				end
				if ip == 0 then
					player:sendTextMessage(22, "There has been an error with the Players IP who you wanted to ban")
					-- send player option window
					return
				end
				resultId = db.storeQuery("SELECT 1 FROM `ip_bans` WHERE `ip` = " .. ip)
				if resultId ~= false then
					result.free(resultId)
					return false
				end
				local timeNow = os.time()
				db:query("INSERT INTO `ip_bans` (`ip`, `reason`, `banned_at`, `expires_at`, `banned_by`) VALUES (" .. ip .. ", '".. reason .."', " .. timeNow .. ", " .. timeNow + length .. ", " .. player:getGuid() .. ")")
			end
			createWindowWithButtons(player, playersOptions, windows.Management_Players_Options, tmpPlayerName, "Select Option", preButtons, playerOptionChoices, true, false)
		elseif buttonId == 0x02 then
			createWindowWithButtons(player, banReasons, windows.Management_Players_Select_Ban_Reason, tmpPlayerName, "Select a ban reason:", preButtons, banChoices, true, false)
		end
	elseif modalWindowId == windows.Management_Players_Select_AddSkills then
		local target = Player(tmpPlayerName)
		if buttonId == 0x03 then
			if target then
				target:addSkillTries(choiceId, target:getVocation():getRequiredSkillTries(choiceId, target:getSkillLevel(choiceId) + 1) - target:getSkillTries(choiceId))
			end
			createWindowWithButtons(player, skills, windows.Management_Players_Select_AddSkills, tmpPlayerName, "Select a skill to advance", skillButtons, skillChoices, true, false)
		elseif buttonId == 0x02 then
			createWindowWithButtons(player, playersOptions, windows.Management_Players_Options, tmpPlayerName, "Select Option", preButtons, playerOptionChoices, true, false)
		end
	elseif modalWindowId == windows.Management_Players_Select_ChangeTown then
		if buttonId == 0x00 then
			if target then
				local town = Town(choiceId)
				target:setTown(town)
				player:sendTextMessage(22, "You have set ".. target:getName() .."\'s town to ".. town:getName() ..".")
				target:sendTextMessage(22, "Your town has been set to ".. town:getName() ..".")
			end
			createWindowWithButtons(player, playersOptions, windows.Management_Players_Options, tmpPlayerName, "Select Option", preButtons, playerOptionChoices, true, false)
		elseif buttonId == 0x02 then
			createWindowWithButtons(player, playersOptions, windows.Management_Players_Options, tmpPlayerName, "Select Option", preButtons, playerOptionChoices, true, false)
		end
	elseif modalWindowId == windows.Management_Players_Select_PromotePlayer then
		if buttonId == 0x00 then
			if target then
				local accountId = target:getAccountId()
				target:remove()
				if choiceId > 3 then
					db:query("UPDATE `players` SET `group_id` = ".. choiceId - 2 .." WHERE `account_id` = " .. accountId .." AND `name` = '".. tmpPlayerName .."'")
				end
				db:query("UPDATE `accounts` SET `type` = ".. choiceId .." WHERE `id` = " .. accountId .."")
				player:sendTextMessage(22, "You have promoted ".. tmpPlayerName .." to a ".. promoteOptions[choiceId] ..".")
			end
			createWindowWithButtons(player, playersOptions, windows.Management_Players_Options, tmpPlayerName, "Select Option", preButtons, playerOptionChoices, true, false)
		elseif buttonId == 0x02 then
			createWindowWithButtons(player, playersOptions, windows.Management_Players_Options, tmpPlayerName, "Select Option", preButtons, playerOptionChoices, true, false)
		end
	end
	
	--######NPC######--
	if modalWindowId == windows.Management_NPC then
		if buttonId == 0x00 then
			if choiceId == ((state[player:getId()] * 50) < #onlineNpcs and 52 or ((#onlineNpcs - (((state[player:getId()] - 1) * 50) + 1) + 2))) then
				npcChoices = cacheData2(onlineNpcs, state[player:getId()])
				state[player:getId()] = state[player:getId()] - 1
				createWindowWithButtons(player, npcs, windows.Management_NPC, "NPC List", "Select NPC", npcButtons, npcChoices, true, false)
			elseif choiceId == ((state[player:getId()] * 50) < #onlineNpcs and 51 or ((#onlineNpcs - (((state[player:getId()] - 1) * 50) + 1 ) + 2))) then
				npcChoices = cacheData2(onlineNpcs, state[player:getId()])
				state[player:getId()] = state[player:getId()] + 1
				createWindowWithButtons(player, npcs, windows.Management_NPC, "NPC List", "Select NPC", npcButtons, npcChoices, true, false)
			else
				npcTarget = Creature(onlineNpcs[choiceId + (state[player:getId()] == 1 and 0 or ((state[player:getId()] - 1) * 50))][2])
				tmpNpcName = onlineNpcs[choiceId + (state[player:getId()] == 1 and 0 or ((state[player:getId()] - 1) * 50))][1]
				for k,v in pairs(npcsOptions) do
					npcOptionChoices[v[1]] = {}; npcOptionChoices[v[1]].id = v[1]; npcOptionChoices[v[1]].text = v[2]
				end
				state[player:getId()] = 1
				createWindowWithButtons(player, npcOptions, windows.Management_NPC_Options, tmpNpcName, "ID: ".. npcTarget:getId() .."\nPos: x:".. npcTarget:getPosition().x .." y:".. npcTarget:getPosition().y .." z:".. npcTarget:getPosition().z .."\n\nSelect Option", preButtons, npcOptionChoices, true, false)
			end
		elseif buttonId == 0x03 then
			if choiceId == ((state[player:getId()] * 50) < #onlineNpcs and 52 or ((#onlineNpcs - (((state[player:getId()] - 1) * 50) + 1) + 2))) then
				state[player:getId()] = state[player:getId()] - 1
				npcChoices = cacheData2(onlineNpcs, state[player:getId()])
				createWindowWithButtons(player, npcs, windows.Management_NPC, "NPC List", "Select NPC", npcButtons, npcChoices, true, false)
			elseif choiceId == ((state[player:getId()] * 50) < #onlineNpcs and 51 or ((#onlineNpcs - (((state[player:getId()] - 1) * 50) + 1 ) + 2))) then
				state[player:getId()] = state[player:getId()] + 1
				npcChoices = cacheData2(onlineNpcs, state[player:getId()])
				createWindowWithButtons(player, npcs, windows.Management_NPC, "NPC List", "Select NPC", npcButtons, npcChoices, true, false)
			else
				npcTarget = Creature(onlineNpcs[choiceId + (state[player:getId()] == 1 and 0 or ((state[player:getId()] - 1) * 50))][2])
				if npcTarget then
					doTeleportThing(player, npcTarget:getPosition(), true)
					createWindowWithButtons(player, npcs, windows.Management_NPC, "NPC List", "Select NPC", npcButtons, npcChoices, true, false)
				else
					state[player:getId()] = 1
					createWindowWithButtons(player, management, windows.Management, "Management", "Ingame Administration Tool:\nCreated by Evil Hero @ otland", managementButtons, managementChoices, true, false)
				end
			end
		elseif buttonId == 0x02 then
			createWindowWithButtons(player, management, windows.Management, "Management", "Ingame Administration Tool:\nCreated by Evil Hero @ otland", managementButtons, managementChoices, true, false)
		end
	elseif modalWindowId == windows.Management_NPC_Options then
		if buttonId == 0x00 then
			if choiceId == npcsOptions.Remove_NPC[1] then
				-- remove npc FINISHED
				if buttonId == 0x00 then
					if npcTarget then
						npcTarget:remove()
					end
				elseif buttonId == 0x02 then
					createWindowWithButtons(player, npcs, windows.Management_NPC, "NPC List", "Select NPC", preButtons, npcChoices, true, false)
				end
			elseif choiceId == npcsOptions.Teleport_To_NPC[1] then
				-- teleport to npc FINISHED
				if buttonId == 0x00 then
					if npcTarget then
						doTeleportThing(cid, npcTarget:getPosition(), true)
						createWindowWithButtons(player, npcOptions, windows.Management_NPC_Options, tmpNpcName, "Select Option", preButtons, npcOptionChoices, true, false)
					end
				elseif buttonId == 0x02 then
					createWindowWithButtons(player, npcs, windows.Management_NPC, "NPC List", "Select NPC", preButtons, npcChoices, true, false)
				end
			elseif choiceId == npcsOptions.Teleport_NPC_To_You[1] then
				-- teleport npc to you FINISHED
				if buttonId == 0x00 then
					if npcTarget then
						doTeleportThing(npcTarget, player:getPosition(), true)
						createWindowWithButtons(player, npcOptions, windows.Management_NPC_Options, tmpNpcName, "Select Option", preButtons, npcOptionChoices, true, false)
					end
				elseif buttonId == 0x02 then
					createWindowWithButtons(player, npcs, windows.Management_NPC, "NPC List", "Select NPC", preButtons, npcChoices, true, false)
				end	
			elseif choiceId == npcsOptions.Change_Speed[1] then
				-- change speed FINISHED
				if buttonId == 0x00 then
					speedIndex = 0
					speed = {}
					while speedIndex * 10 < 300 do
						speedIndex = speedIndex + 1
						npcSpeedChoices[speedIndex] = {}; npcSpeedChoices[speedIndex].id = speedIndex; npcSpeedChoices[speedIndex].text = speedIndex == 0 and 0 or speedIndex * 10
						table.insert(speed, speedIndex)
					end
					createWindowWithButtons(player, npcSpeed, windows.Management_NPC_Select_Speed, tmpNpcName, "Select Speed", preButtons, npcSpeedChoices, true, false)	
				elseif buttonId == 0x02 then
					createWindowWithButtons(player, npcs, windows.Management_NPC, "NPC List", "Select NPC", preButtons, npcChoices, true, false)
				end
			end
		elseif buttonId == 0x02 then
			createWindowWithButtons(player, npcs, windows.Management_NPC, "NPC List", "Select NPC", preButtons, npcChoices, true, false)
		end
	elseif modalWindowId == windows.Management_NPC_Select_Speed then
		-- handle the window for speed change FINISHED
		if buttonId == 0x00 then
			-- handle
			if npcTarget then
				npcTarget:changeSpeed(-(npcTarget:getSpeed() - npcTarget:getBaseSpeed()) + speed[choiceId])
				createWindowWithButtons(player, npcOptions, windows.Management_NPC_Options, tmpNpcName, "Select Option", preButtons, npcOptionChoices, true, false)
			end
		elseif buttonId == 0x02 then
			createWindowWithButtons(player, npcOptions, windows.Management_NPC_Options, tmpNpcName, "Select Option", preButtons, npcOptionChoices, true, false)
		end
	end
	
	--######Monster######--
	if modalWindowId == windows.Management_Monster_Type then
		if buttonId == 0x00 then
			if choiceId == ((state[player:getId()] * 50) < #monsterType and 52 or ((#monsterType - (((state[player:getId()] - 1) * 50) + 1) + 2))) then
				state[player:getId()] = state[player:getId()] - 1
				local monsterTypeChoices = cacheData1(monsterType, state[player:getId()])
				createWindowWithButtons(player, monster, windows.Management_Monster_Type, "Monster Type List", "Select Monster Type", preButtons, monsterTypeChoices, true, false)
			elseif choiceId == ((state[player:getId()] * 50) < #monsterType and 51 or ((#monsterType - (((state[player:getId()] - 1) * 50) + 1 ) + 2))) then
				state[player:getId()] = state[player:getId()] + 1
				local monsterTypeChoices = cacheData1(monsterType, state[player:getId()])
				createWindowWithButtons(player, monster, windows.Management_Monster_Type, "Monster Type List", "Select Monster Type", preButtons, monsterTypeChoices, true, false)
			else
				mType = monsterType[choiceId + (state[player:getId()] == 1 and 0 or ((state[player:getId()] - 1) * 50))]
				state[player:getId()] = 1
				monsterChoices = {}
				monsterButtons = {{id = 0x00, text = "Select", enter = false, escape = false}, {id = 0x01, text = "End", enter = false, escape = true}, {id = 0x02, text = "Back", enter = false, escape = false}, {id = 0x03, text = "TP", enter = true, escape = false}}
				local monsterChoices = cacheData(monsters[mType], state[player:getId()], mType)
				createWindowWithButtons(player, monster, windows.Management_Monster, "Monster List", "Select Monster\nPage: ".. state[player:getId()] .."", monsterButtons, monsterChoices, true, false)
			end
		elseif buttonId == 0x02 then
			createWindowWithButtons(player, management, windows.Management, "Management", "Ingame Administration Tool:\nCreated by Evil Hero @ otland", managementButtons, managementChoices, true, false)
		end
	elseif modalWindowId == windows.Management_Monster then
		if buttonId == 0x00 then
			if choiceId == ((state[player:getId()] * 50) < #monsters[mType] and 52 or ((#monsters[mType] - (((state[player:getId()] - 1) * 50) + 1) + 2))) then
				local monsterTypeChoices = cacheData1(monsterType, state[player:getId()])
				state[player:getId()] = state[player:getId()] - 1
				createWindowWithButtons(player, monsters1, windows.Management_Monster, "Monster List", "Select Monster\nPage: ".. state[player:getId()] .."", monsterButtons, monsterChoices, true, false)
			elseif choiceId == ((state[player:getId()] * 50) < #monsters[mType] and 51 or ((#monsters[mType] - (((state[player:getId()] - 1) * 50) + 1 ) + 2))) then
				local monsterTypeChoices = cacheData1(monsterType, state[player:getId()])
				state[player:getId()] = state[player:getId()] + 1
				createWindowWithButtons(player, monsters1, windows.Management_Monster, "Monster List", "Select Monster\nPage: ".. state[player:getId()] .."", monsterButtons, monsterChoices, true, false)
			else
				tmpMonster = nil
				monsterOptionChoices = {}
				if Creature(monsters[mType][choiceId + (state[player:getId()] == 1 and 0 or ((state[player:getId()] - 1) * 50))]) then
					tmpMonster = Creature(monsters[mType][choiceId + (state[player:getId()] == 1 and 0 or ((state[player:getId()] - 1) * 50))])
				end
				for k,v in pairs(monstersOptions) do
					monsterOptionChoices[v[1]] = {}; monsterOptionChoices[v[1]].id = v[1]; monsterOptionChoices[v[1]].text = v[2]
				end
				--local monsterOptionChoices = cacheData(monsters[mType], state[player:getId()], mType)
				createWindowWithButtons(player, monsterOptions, windows.Management_Monster_Options, tmpMonster:getName(), "ID: ".. tmpMonster:getId() .."\nPos: x:".. tmpMonster:getPosition().x .." y:".. tmpMonster:getPosition().y .." z:".. tmpMonster:getPosition().z .."\n\nSelect Option", preButtons, monsterOptionChoices, true, false)
			end
		elseif buttonId == 0x03 then
			if choiceId == ((state[player:getId()] * 50) < #monsters[mType] and 52 or ((#monsters[mType] - (((state[player:getId()] - 1) * 50) + 1) + 2))) then
				state[player:getId()] = state[player:getId()] - 1
				local monsterChoices = cacheData(monsters[mType], state[player:getId()], mType)
				createWindowWithButtons(player, monsters1, windows.Management_Monster, "Monster List", "Select Monster\nPage: ".. state[player:getId()] .."", monsterButtons, monsterChoices, true, false)
			elseif choiceId == ((state[player:getId()] * 50) < #monsters[mType] and 51 or ((#monsters[mType] - (((state[player:getId()] - 1) * 50) + 1 ) + 2))) then
				state[player:getId()] = state[player:getId()] + 1
				local monsterChoices = cacheData(monsters[mType], state[player:getId()], mType)
				createWindowWithButtons(player, monsters1, windows.Management_Monster, "Monster List", "Select Monster\nPage: ".. state[player:getId()] .."", monsterButtons, monsterChoices, true, false)
			else
				tmpMonster = nil
				monsterOptionChoices = {}
				if Creature(monsters[mType][choiceId + (state[player:getId()] == 1 and 0 or ((state[player:getId()] - 1) * 50))]) then
					tmpMonster = Creature(monsters[mType][choiceId + (state[player:getId()] == 1 and 0 or ((state[player:getId()] - 1) * 50))])
					doTeleportThing(player, tmpMonster:getPosition(), true)
				end
				local monsterChoices = cacheData(monsters[mType], state[player:getId()], mType)
				createWindowWithButtons(player, monsters1, windows.Management_Monster, "Monster List", "Select Monster\nPage: ".. state[player:getId()] .."", monsterButtons, monsterChoices, true, false)
			end
		elseif buttonId == 0x02 then
			state[player:getId()] = 1
			local monsterTypeChoices = cacheData1(monsterType, state[player:getId()], monsterTypeOnline)
			createWindowWithButtons(player, monsters1, windows.Management_Monster_Type, "Monster Type List", "Select Monster Type", preButtons, monsterTypeChoices, true, false)
		end
	elseif modalWindowId == windows.Management_Monster_Options then
		if buttonId == 0x00 then
			if choiceId == monstersOptions.Remove_Monster[1] then
				-- remove monster FINISHED
				if buttonId == 0x00 then
					if tmpMonster then
						tmpMonster:remove()
					end
				elseif buttonId == 0x02 then
					local monsterChoices = cacheData(monsters[mType], state[player:getId()], mType)
					createWindowWithButtons(player, monsters1, windows.Management_Monster, "Monster List", "Select Monster\nPage: ".. state[player:getId()] .."", monsterButtons, monsterChoices, true, false)
				end
			end
		elseif buttonId == 0x02 then
			local monsterChoices = cacheData(monsters[mType], state[player:getId()], mType)
			createWindowWithButtons(player, monsters1, windows.Management_Monster, "Monster List", "Select Monster\nPage: ".. state[player:getId()] .."", monsterButtons, monsterChoices, true, false)
		end
	end
	return true
end