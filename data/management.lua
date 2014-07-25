monsters = {}
state = {}

windows =
{
	Management = 100,
	Management_Players = 101,
	Management_Players_Options = 102,
	Management_Players_Select_Info = 103,
	Management_Players_Select_AddItem = 104,
	Management_Players_Select_RemoveItem = 105,
	Management_Players_Select_Ban_Reason = 106,
	Management_Players_Select_Ban_Length = 107,
	Management_Players_Select_AddSkills = 108,
	Management_Players_Select_ChangeTown = 109,
	Management_Players_Select_PromotePlayer = 110,
	Management_NPC = 111,
	Management_NPC_Options = 112,
	Management_NPC_Select_Speed = 113,
	-- rest of npc things
	Management_Monster = 120,
	Management_Monster_Type = 121,
	Management_Monster_Options = 122
}

preButtons = {{id = 0x00, text = "Select", enter = true, escape = false}, {id = 0x01, text = "End", enter = false, escape = true}, {id = 0x02, text = "Back", enter = false, escape = false}}
managementChoices = {}
managementButtons = {{id = 0x00, text = "Select", enter = true, escape = false}, {id = 0x01, text = "End", enter = false, escape = true}}

function createWindowWithButtons(cid, var, modalWindowId, headerText, bodyText, buttonTable, choiceTable, sendToPlayer, priority)
	var = ModalWindow(modalWindowId, headerText, bodyText)
	for i = 1, #buttonTable do
		var:addButton(buttonTable[i].id, buttonTable[i].text)
		if buttonTable[i].enter then
			var:setDefaultEnterButton(buttonTable[i].id)
		end
		if buttonTable[i].escape then
			var:setDefaultEscapeButton(buttonTable[i].id)
		end
	end
	for i = 0, #choiceTable do
		if choiceTable[i] ~= nil then
			var:addChoice(choiceTable[i].id, choiceTable[i].text)
		end
	end
	if not priority then
		var:setPriority(false)
	end
	if sendToPlayer then
		var:sendToPlayer(cid)
	end
end

function cacheData(t1, state, mType)
	local t2 = {}
	local a = 0
	if #t1 > 50 then
		for i = (state == 1 and 1 or ((state - 1) * 50) + 1), (state == 1 and 50 or (state * 50) > #t1 and #t1 or (state * 50)) do
			a = a + 1
			t2[a] = {}; t2[a].id = a; t2[a].text = mType .." (".. Creature(t1[i]):getPosition().x .."/".. Creature(t1[i]):getPosition().y .."/".. Creature(t1[i]):getPosition().z ..")"
		end
		local c = ((state * 50) < #t1 and 51 or ((#t1 - (((state - 1) * 50) + 1) + 1)))
		local b = ((state * 50) < #t1 and 52 or ((#t1 - (((state - 1) * 50) + 1) + 2)))
		if #t1 > (50 * state) then
			t2[c] = {}; t2[c].id = c; t2[c].text = "Next"
		end
		if state > 1 then
			t2[b] = {}; t2[b].id = b; t2[b].text = "Back"
		end
	elseif #t1 <= 50 then
		for i = 1, #t1 do
			t2[i] = {}; t2[i].id = i; t2[i].text = mType .." (".. Creature(t1[i]):getPosition().x .."/".. Creature(t1[i]):getPosition().y .."/".. Creature(t1[i]):getPosition().z ..")"
		end
	end
	return t2
end

function cacheData1(t1, state)
	local t2 = {}
	local a = 0
	if #t1 > 50 then
		for i = (state == 1 and 1 or ((state - 1) * 50) + 1), (state == 1 and 50 or (state * 50) > #t1 and #t1 or (state * 50)) do
			a = a + 1
			t2[a] = {}; t2[a].id = a; t2[a].text = t1[i]
		end
		local c = ((state * 50) < #t1 and 51 or ((#t1 - (((state - 1) * 50) + 1) + 1)))
		local b = ((state * 50) < #t1 and 52 or ((#t1 - (((state - 1) * 50) + 1) + 2)))
		if #t1 > (50 * state) then
			t2[c] = {}; t2[c].id = c; t2[c].text = "Next"
		end
		if state > 1 then
			t2[b] = {}; t2[b].id = b; t2[b].text = "Back"
		end
	elseif #t1 <= 50 then
		for i = 1, #t1 do
			t2[i] = {}; t2[i].id = i; t2[i].text = t1[i]
		end
	end
	return t2
end

function cacheData2(t1, state)
	local t2 = {}
	local a = 0
	if #t1 > 50 then
		for i = (state == 1 and 1 or ((state - 1) * 50) + 1), (state == 1 and 50 or (state * 50) > #t1 and #t1 or (state * 50)) do
			a = a + 1
			t2[a] = {}; t2[a].id = a; t2[a].text = t1[i][1] .." (".. Creature(t1[i][2]):getPosition().x .."/".. Creature(t1[i][2]):getPosition().y .."/".. Creature(t1[i][2]):getPosition().z ..")"
		end
		local c = ((state * 50) < #t1 and 51 or ((#t1 - (((state - 1) * 50) + 1) + 1)))
		local b = ((state * 50) < #t1 and 52 or ((#t1 - (((state - 1) * 50) + 1) + 2)))
		if #t1 > (50 * state) then
			t2[c] = {}; t2[c].id = c; t2[c].text = "Next"
		end
		if state > 1 then
			t2[b] = {}; t2[b].id = b; t2[b].text = "Back"
		end
	elseif #t1 <= 50 then
		for i = 1, #t1 do
			t2[i] = {}; t2[i].id = i; t2[i].text = t1[i][1]  .." (".. Creature(t1[i][2]):getPosition().x .."/".. Creature(t1[i][2]):getPosition().y .."/".. Creature(t1[i][2]):getPosition().z ..")"
		end
	end
	return t2
end

table.find = function (table, value)
   for i, v in pairs(table) do
     if(v == value) then
       return i
     end
   end
   return nil
end

function getExpForLevel(level)
	level = level - 1
	return ((50 * level * level * level) - (150 * level * level) + (400 * level)) / 3
end

function getAllItemsById(cid, id)
	local containers = {}
	local items = {}

	for k,v in pairs(slotBits) do
		local sitem = getPlayerSlotItem(cid, k)
		if sitem.uid > 0 then
			if isContainer(sitem.uid) then
				table.insert(containers, sitem.uid)
			elseif not(id) or id == sitem.itemid then
				table.insert(items, sitem)
			end
		end
	end

	while #containers > 0 do
		for k = (getContainerSize(containers[1]) - 1), 0, -1 do
		local tmp = getContainerItem(containers[1], k)
			if isContainer(tmp.uid) then
				table.insert(containers, tmp.uid)
			elseif not(id) or id == tmp.itemid then
				table.insert(items, tmp)
			end
		end
		table.remove(containers, 1)
	end
	return items
end

function getOnlineNpcs()
	local result = {}
	for _, npc in ipairs(Game.getNpcs()) do
		result[#result + 1] = {}
		result[#result][1] = npc:getName()
		result[#result][2] = npc:getId()
	end
	return result
end

function getOnlineMonsters()
	local result = {}
	for _, monster in ipairs(Game.getMonsters()) do
		result[#result + 1] = {}
		result[#result][1] = monster:getName()
		result[#result][2] = monster:getId()
	end
	return result
end

function isInArray(arr,val,checkindex)
	assert(type(arr)=='table','#1 must be a table')
	for i,b in pairs(arr) do
		if (checkindex and i == val) or (not checkindex and b == val) then
			return true, checkindex and b or i
		end
	end
	return false
end