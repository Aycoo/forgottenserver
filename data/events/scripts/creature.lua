local Register = 
{
	target = {},
	outfit = {},
	attack = {},
	hear = {} 
}

local UnRegister =
{
	target = {},
	outfit = {},
	attack = {},
	hear = {}
}

-- I use this method to register and un register certain monsters / npcs / players if you leave both tables empty all are registered.
-- example target = {} in both register and unRegister table.
-- IMPORTANT names must be lower case example: Demon has to be demon or Evil Hero has to be evil hero.
-- to enable it for all players / monsters /npcs use "all players" "all monsters" "all npcs"
function register(self, registerTable)
	if registerTable[1] ~= nil then
		if self:isPlayer() and not isInArray(registerTable, "all players") then
			if not isInArray(registerTable, string.lower(self:getName())) then
				return false
			end
		elseif self:isMonster() and not isInArray(registerTable, "all monsters") then
			if not isInArray(registerTable, string.lower(self:getName())) then
				return false
			end
		elseif self:isNpc() and not isInArray(registerTable, "all npcs") then
			if not isInArray(registerTable, string.lower(self:getName())) then
				return false
			end
		end
	end
	return true
end

function unRegister(self, unRegisterTable)
	if unRegisterTable[1] ~= nil then
		if isInArray(unRegisterTable, string.lower(self:getName())) then
			return true
		end
	end
	return false
end
-- functions end here, please do not edit them!


-- Events start from here on!
function Creature:onTarget(target, isAttacked)
	if self:isMonster() then
		if ddos.enabled then
			return false
		end
	end
	if not register(self, Register.target) then
		return true
	end
	if unRegister(self, UnRegister.target) then
		return true
	end
	-- start scripting from here on.
	return true
end

function Creature:onChangeOutfit(newOutfit, oldOutfit)
	if not register(self, Register.outfit) then
		return true
	end
	if unRegister(self, UnRegister.outfit) then
		return true
	end
	-- return true so the player is able to change his outfit or return false and the old outfit will stay.
	-- start scripting from here on.
	return true, newOutfit
end

function Creature:onAttack(target)
	if not register(self, Register.attack) then
		return true
	end
	if unRegister(self, UnRegister.attack) then
		return true
	end
	-- return true and the monster / player / npc can do dmg again.
	-- start scripting from here on.
	return true
end

function Creature:onHear(sayCreature, words, type, pos)
	if not register(self, Register.hear) then
		return true
	end
	if unRegister(self, UnRegister.hear) then
		return true
	end
	-- doesn't need a return value.
	-- start scripting from here on.
end

function Creature:onMove(fromPosition, toPosition)
	return self:isAbleToWalk()
end