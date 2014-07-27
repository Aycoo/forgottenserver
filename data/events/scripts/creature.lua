local register = 
{
	target = {},
	outfit = {},
	attack = {},
	hear = {}
}

local unRegister =
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
function registerTarget(self) 
	if register.target[1] ~= nil then
		if self:isPlayer() and not isInArray(register.target, "all players") then
			if not isInArray(register.target, string.lower(self:getName())) then
				return true
			end
		elseif self:isMonster() and not isInArray(register.target, "all monsters") then
			if not isInArray(register.target, string.lower(self:getName())) then
				return true
			end
		elseif self:isNpc() and not isInArray(register.target, "all npcs") then
			if not isInArray(register.target, string.lower(self:getName())) then
				return true
			end
		end
	end
end

function unRegisterTarget(self)
	if unRegister.target[1] ~= nil then
		if isInArray(unRegister.target, string.lower(self:getName())) then
			return true
		end
	end
end

function registerOutfit(self) 
	if register.outfit[1] ~= nil then
		if self:isPlayer() and not isInArray(register.outfit, "all players") then
			if not isInArray(register.outfit, string.lower(self:getName())) then
				return true
			end
		elseif self:isMonster() and not isInArray(register.outfit, "all monsters") then
			if not isInArray(register.outfit, string.lower(self:getName())) then
				return true
			end
		elseif self:isNpc() and not isInArray(register.outfit, "all npcs") then
			if not isInArray(register.outfit, string.lower(self:getName())) then
				return true
			end
		end
	end
end

function unRegisterOutfit(self)
	if unRegister.outfit[1] ~= nil then
		if isInArray(unRegister.outfit, string.lower(self:getName())) then
			return true
		end
	end
end

function registerAttack(self) 
	if register.attack[1] ~= nil then
		if self:isPlayer() and not isInArray(register.attack, "all players") then
			if not isInArray(register.attack, string.lower(self:getName())) then
				return true
			end
		elseif self:isMonster() and not isInArray(register.attack, "all monsters") then
			if not isInArray(register.attack, string.lower(self:getName())) then
				return true
			end
		elseif self:isNpc() and not isInArray(register.attack, "all npcs") then
			if not isInArray(register.attack, string.lower(self:getName())) then
				return true
			end
		end
	end
end

function unRegisterAttack(self)
	if unRegister.attack[1] ~= nil then
		if isInArray(unRegister.attack, string.lower(self:getName())) then
			return true
		end
	end
end

function registerHear(self) 
	if register.hear[1] ~= nil then
		if self:isPlayer() and not isInArray(register.hear, "all players") then
			if not isInArray(register.hear, string.lower(self:getName())) then
				return true
			end
		elseif self:isMonster() and not isInArray(register.hear, "all monsters") then
			if not isInArray(register.hear, string.lower(self:getName())) then
				return true
			end
		elseif self:isNpc() and not isInArray(register.hear, "all npcs") then
			if not isInArray(register.hear, string.lower(self:getName())) then
				return true
			end
		end
	end
end

function unRegisterHear(self)
	if unRegister.hear[1] ~= nil then
		if isInArray(unRegister.hear, string.lower(self:getName())) then
			return true
		end
	end
end
-- functions end here, please do not edit them!


-- Events start from here on!
function Creature:onTarget(target)
	registerTarget(self)
	unRegisterTarget(self)
	-- start scripting from here on.
	return true
end

function Creature:onChangeOutfit(newOutfit, oldOutfit)
	registerOutfit(self)
	unRegisterOutfit(self)
	-- return true so the player is able to change his outfit or return false and the old outfit will stay.
	-- start scripting from here on.
	return true
end

function Creature:onAttack(target)
	registerAttack(self)
	unRegisterAttack(self)
	-- return true and the monster / player / npc can do dmg again.
	-- start scripting from here on.
	return true
end

function Creature:onHear(sayCreature, words, type, pos)
	registerHear(self)
	unRegisterHear(self)
	-- doesn't need a return value.
	-- start scripting from here on.
end


