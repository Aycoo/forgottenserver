/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2014  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include "otpch.h"

#include "events.h"
#include "tools.h"
#include "item.h"
#include "player.h"
#include "const.h"

#include <set>

Events::Events() :
	scriptInterface("Event Interface")
{
	clear();
	scriptInterface.initState();
}

void Events::clear()
{
	// Party
	partyOnJoin = -1;
	partyOnLeave = -1;
	partyOnDisband = -1;

	// Player
	playerOnBrowseField = -1;
	playerOnLook = -1;
	playerOnLookInBattleList = -1;
	playerOnLookInTrade = -1;
	playerOnLookInShop = -1;
	playerOnMoveItem = -1;
	playerOnMoveCreature = -1;
	playerOnTurn = -1;
	playerOnTradeRequest = -1;
	playerOnGainExperience = -1;
	playerOnLoseExperience = -1;
	playerGetCustomMissionDescription = -1;
	playerOnSave = -1;


	// Creature
	creatureOnTarget = -1;
	creatureOnChangeOutfit = -1;
	creatureOnAttack = -1;
	creatureOnHear = -1;
	creatureOnMove = -1;
	//Monster
	monsterOnTargetDeny = -1;
}

bool Events::load()
{
	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file("data/events/events.xml");
	if (!result) {
		std::cout << "[Error - Events::load] Failed to load data/events/events.xml: " << result.description() << std::endl;
		return false;
	}

	clear();

	std::set<std::string> classes;
	for (pugi::xml_node eventNode = doc.child("events").first_child(); eventNode; eventNode = eventNode.next_sibling()) {
		if (eventNode.attribute("enabled").as_bool()) {
			const std::string& className = eventNode.attribute("class").as_string();
			if (classes.count(className) == 0) {
				classes.insert(className);
				const std::string& lowercase = asLowerCaseString(className);
				if (scriptInterface.loadFile("data/events/scripts/" + lowercase + ".lua") != 0) {
					std::cout << "[Warning - Events::load] Can not load script: " << lowercase << ".lua" << std::endl;
					std::cout << scriptInterface.getLastLuaError() << std::endl;
				}
			}

			const std::string& methodName = eventNode.attribute("method").as_string();
			const int32_t event = scriptInterface.getMetaEvent(className, methodName);
			if (className == "Party") {
				if (methodName == "onJoin") {
					partyOnJoin = event;
				} else if (methodName == "onLeave") {
					partyOnLeave = event;
				} else if (methodName == "onDisband") {
					partyOnDisband = event;
				} else {
					std::cout << "[Warning - Events::load] Unknown party method: " << methodName << std::endl;
				}
			} else if (className == "Player") {
				if (methodName == "onBrowseField") {
					playerOnBrowseField = event;
				} else if (methodName == "onLook") {
					playerOnLook = event;
				} else if (methodName == "onLookInBattleList") {
					playerOnLookInBattleList = event;
				} else if (methodName == "onLookInTrade") {
					playerOnLookInTrade = event;
				} else if (methodName == "onLookInShop") {
					playerOnLookInShop = event;
				} else if (methodName == "onTradeRequest") {
					playerOnTradeRequest = event;
				} else if (methodName == "onMoveItem") {
					playerOnMoveItem = event;
				} else if (methodName == "onMoveCreature") {
					playerOnMoveCreature = event;
				} else if (methodName == "onTurn") {
					playerOnTurn = event;
				} else if (methodName == "onGainExperience") {
					playerOnGainExperience = event;
				} else if (methodName == "onLoseExperience") {
					playerOnLoseExperience = event;
				}
				else if (methodName == "getMissionDescription") {
					playerGetCustomMissionDescription = event;
				} 
				else if (methodName == "onSave") {
					playerOnSave = event;
				}
				else {
					std::cout << "[Warning - Events::load] Unknown player method: " << methodName << std::endl;
				}
			}
			else if (className == "Creature") {
				if (methodName == "onTarget") {
					creatureOnTarget = event;
				} else if (methodName == "onChangeOutfit") {
					creatureOnChangeOutfit = event;
				} else if (methodName == "onAttack") {
					creatureOnAttack = event;
				}
				else if (methodName == "onHear") {
					creatureOnHear = event;
				}
				else if (methodName == "onMove") {
					creatureOnMove = event;
				} else {
					std::cout << "[Warning - Events::load] Unknown creature method: " << methodName << std::endl;
				}
			}
			else if (className == "Monster") {
				 if (methodName == "onTargetDeny") {
					monsterOnTargetDeny = event;
				}
			} else {
				std::cout << "[Warning - Events::load] Unknown class: " << className << std::endl;
			}
		}
	}

	return true;
}

// Party
bool Events::eventPartyOnJoin(Party* party, Player* player)
{
	// Party:onJoin(player) or Party.onJoin(self, player)
	if (partyOnJoin == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		std::cout << "[Error - Events::eventPartyOnJoin] Call stack overflow" << std::endl;
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(partyOnJoin, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(partyOnJoin);

	LuaScriptInterface::pushUserdata<Party>(L, party);
	LuaScriptInterface::setMetatable(L, -1, "Party");

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	return scriptInterface.callFunction(2);
}

bool Events::eventPartyOnLeave(Party* party, Player* player)
{
	// Party:onLeave(player) or Party.onLeave(self, player)
	if (partyOnLeave == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		std::cout << "[Error - Events::eventPartyOnLeave] Call stack overflow" << std::endl;
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(partyOnLeave, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(partyOnLeave);

	LuaScriptInterface::pushUserdata<Party>(L, party);
	LuaScriptInterface::setMetatable(L, -1, "Party");

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	return scriptInterface.callFunction(2);
}

bool Events::eventPartyOnDisband(Party* party)
{
	// Party:onDisband() or Party.onDisband(self)
	if (partyOnDisband == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		std::cout << "[Error - Events::eventPartyOnDisband] Call stack overflow" << std::endl;
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(partyOnDisband, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(partyOnDisband);

	LuaScriptInterface::pushUserdata<Party>(L, party);
	LuaScriptInterface::setMetatable(L, -1, "Party");

	return scriptInterface.callFunction(1);
}

// Player
bool Events::eventPlayerOnBrowseField(Player* player, const Position& position)
{
	// Player:onBrowseField(position) or Player.onBrowseField(self, position)
	if (playerOnBrowseField == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		std::cout << "[Error - Events::eventPlayerOnBrowseField] Call stack overflow" << std::endl;
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(playerOnBrowseField, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(playerOnBrowseField);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushPosition(L, position);

	return scriptInterface.callFunction(2);
}

void Events::eventPlayerOnLook(Player* player, const Position& position, Thing* thing, uint8_t stackpos, int32_t lookDistance)
{
	// Player:onLook(thing, position, distance) or Player.onLook(self, thing, position, distance)
	if (playerOnLook == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		std::cout << "[Error - Events::eventPlayerOnLook] Call stack overflow" << std::endl;
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(playerOnLook, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(playerOnLook);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	if (Creature* creature = thing->getCreature()) {
		LuaScriptInterface::pushUserdata<Creature>(L, creature);
		LuaScriptInterface::setCreatureMetatable(L, -1, creature);
	} else if (Item* item = thing->getItem()) {
		LuaScriptInterface::pushUserdata<Item>(L, item);
		LuaScriptInterface::setItemMetatable(L, -1, item);
	} else {
		lua_pushnil(L);
	}

	LuaScriptInterface::pushPosition(L, position, stackpos);
	lua_pushnumber(L, lookDistance);

	scriptInterface.callVoidFunction(4);
}

void Events::eventPlayerOnLookInBattleList(Player* player, Creature* creature, int32_t lookDistance)
{
	// Player:onLookInBattleList(creature, position, distance) or Player.onLookInBattleList(self, creature, position, distance)
	if (playerOnLookInBattleList == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		std::cout << "[Error - Events::eventPlayerOnLookInBattleList] Call stack overflow" << std::endl;
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(playerOnLookInBattleList, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(playerOnLookInBattleList);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	lua_pushnumber(L, lookDistance);

	scriptInterface.callVoidFunction(3);
}

void Events::eventPlayerOnLookInTrade(Player* player, Player* partner, Item* item, int32_t lookDistance)
{
	// Player:onLookInTrade(partner, item, distance) or Player.onLookInTrade(self, partner, item, distance)
	if (playerOnLookInTrade == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		std::cout << "[Error - Events::eventPlayerOnLookInTrade] Call stack overflow" << std::endl;
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(playerOnLookInTrade, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(playerOnLookInTrade);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Player>(L, partner);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	lua_pushnumber(L, lookDistance);

	scriptInterface.callVoidFunction(4);
}

bool Events::eventPlayerOnLookInShop(Player* player, const ItemType* itemType, uint8_t count)
{
	// Player:onLookInShop(itemType, count) or Player.onLookInShop(self, itemType, count)
	if (playerOnLookInShop == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		std::cout << "[Error - Events::eventPlayerOnLookInShop] Call stack overflow" << std::endl;
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(playerOnLookInShop, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(playerOnLookInShop);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<const ItemType>(L, itemType);
	LuaScriptInterface::setMetatable(L, -1, "ItemType");

	lua_pushnumber(L, count);

	return scriptInterface.callFunction(3);
}

bool Events::eventPlayerOnMoveItem(Player* player, Item* item, uint16_t count, const Position& fromPosition, const Position& toPosition)
{
	// Player:onMoveItem(item, count, fromPosition, toPosition) or Player.onMoveItem(self, item, count, fromPosition, toPosition)
	if (playerOnMoveItem == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		std::cout << "[Error - Events::eventPlayerOnMoveItem] Call stack overflow" << std::endl;
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(playerOnMoveItem, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(playerOnMoveItem);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	lua_pushnumber(L, count);
	LuaScriptInterface::pushPosition(L, fromPosition);
	LuaScriptInterface::pushPosition(L, toPosition);

	return scriptInterface.callFunction(5);
}

bool Events::eventPlayerOnMoveCreature(Player* player, Creature* creature, const Position& fromPosition, const Position& toPosition)
{
	// Player:onMoveCreature(creature, fromPosition, toPosition) or Player.onMoveCreature(self, creature, fromPosition, toPosition)
	if (playerOnMoveCreature == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		std::cout << "[Error - Events::eventPlayerOnMoveCreature] Call stack overflow" << std::endl;
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(playerOnMoveCreature, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(playerOnMoveCreature);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	LuaScriptInterface::pushPosition(L, fromPosition);
	LuaScriptInterface::pushPosition(L, toPosition);

	return scriptInterface.callFunction(4);
}

bool Events::eventPlayerOnTurn(Player* player, Direction direction)
{
	// Player:onTurn(direction) or Player.onTurn(self, direction)
	if (playerOnTurn == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		std::cout << "[Error - Events::eventPlayerOnTurn] Call stack overflow" << std::endl;
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(playerOnTurn, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(playerOnTurn);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, direction);

	return scriptInterface.callFunction(2);
}

bool Events::eventPlayerOnTradeRequest(Player* player, Player* target, Item* item)
{
	// Player:onTradeRequest(target,item)
	if (playerOnTradeRequest == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		std::cout << "[Error - Events::eventPlayerOnTradeRequest] Call stack overflow" << std::endl;
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(playerOnTradeRequest, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(playerOnTradeRequest);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Player>(L, target);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushUserdata<Item>(L, item);
	LuaScriptInterface::setItemMetatable(L, -1, item);

	return scriptInterface.callFunction(3);
}

void Events::eventPlayerOnGainExperience(Player* player, Creature* target, uint64_t &exp, uint64_t rawExp)
{
	// Player:onGainExperience(target(= nil, if there is no target), exp, rawExp) or Player.onGainExperience(self, target, exp, rawExp)

	if (playerOnGainExperience == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		std::cout << "[Error - Events::eventPlayerOnGainExperience] Call stack overflow" << std::endl;
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(playerOnGainExperience, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(playerOnGainExperience);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	if (target) {
		LuaScriptInterface::pushUserdata<Creature>(L, target);
		LuaScriptInterface::setCreatureMetatable(L, -1, target);
	}
	else {
		lua_pushnil(L);
	}

	lua_pushnumber(L, exp);
	lua_pushnumber(L, rawExp);

	if (scriptInterface.protectedCall(L, 4, 1) != 0) {

		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	}
	else {
		exp = LuaScriptInterface::getNumber<uint64_t>(L, -1);
		lua_pop(L, 1);
	}

	scriptInterface.resetScriptEnv();
}

void Events::eventPlayerOnLoseExperience(Player* player, uint64_t &exp)
{
	// Player:onLoseExperience(exp) or Player.onLoseExperience(self, exp)
	if (playerOnLoseExperience == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		std::cout << "[Error - Events::eventPlayerOnLoseExperience] Call stack overflow" << std::endl;
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(playerOnLoseExperience, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(playerOnLoseExperience);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, exp);

	if (scriptInterface.protectedCall(L, 2, 1) != 0) {
		LuaScriptInterface::reportError(nullptr, LuaScriptInterface::popString(L));
	}
	else {
		exp = LuaScriptInterface::getNumber<int64_t>(L, -1);
		lua_pop(L, 1);
	}

	scriptInterface.resetScriptEnv();
}

bool Events::eventPlayerGetCustomMissionDescription(Player* player, std::string& description)
{
	// Player:getMissionDescription(description)
	if (playerGetCustomMissionDescription == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		std::cout << "[Error - Events::eventPlayerGetCustomMissionDescription] Call stack overflow" << std::endl;
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(playerGetCustomMissionDescription, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(playerGetCustomMissionDescription);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	LuaScriptInterface::pushString(L, description);

	bool result = scriptInterface.callFunction(2, 2, false);

	if (result)
	{
		description = LuaScriptInterface::getString(L, -1);
	}

	lua_settop(L, 0);
	LuaScriptInterface::resetScriptEnv();

	return result;
}

bool Events::eventPlayerOnSave(Player* player)
{
	// Player:OnSave(guid)
	if (playerOnSave == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		std::cout << "[Error - Events::eventPlayerOnSave] Call stack overflow" << std::endl;
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(playerOnSave, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(playerOnSave);

	LuaScriptInterface::pushUserdata<Player>(L, player);
	LuaScriptInterface::setMetatable(L, -1, "Player");

	lua_pushnumber(L, player->getGUID());

	return scriptInterface.callFunction(2);
}

bool Events::eventCreatureOnTarget(Creature* creature, Creature* target, bool isAttacked)
{
	// Creature:onTarget(target, isAttacked) or Creature.onTarget(self, target, isAttacked)
	// isAttacked, tells you as a bool if the creature has been attacked by target or not.
	if (creatureOnTarget == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		std::cout << "[Error - Events::eventCreatureOnTarget] Call stack overflow" << std::endl;
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(creatureOnTarget, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(creatureOnTarget);

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	LuaScriptInterface::pushUserdata<Creature>(L, target);
	LuaScriptInterface::setCreatureMetatable(L, -1, target);

	lua_pushboolean(L, isAttacked);

	return scriptInterface.callFunction(3);
}

bool Events::eventCreatureOnChangeOutfit(Creature* creature, Outfit_t& newOutfit, const Outfit_t oldOutfit)
{
	// Creature:onChangeOutfit(newOutfit, oldOutfit)
	if (creatureOnChangeOutfit == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		std::cout << "[Error - Events::eventCreatureOnChangeOutfit] Call stack overflow" << std::endl;
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(creatureOnChangeOutfit, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(creatureOnChangeOutfit);

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	LuaScriptInterface::pushOutfit(L, newOutfit);
	LuaScriptInterface::pushOutfit(L, oldOutfit);

	bool success = scriptInterface.callFunction(3, 2, false);
	if (success)
	{
		newOutfit = scriptInterface.getOutfit(L, -1);
	}

	lua_settop(L, 0);
	LuaScriptInterface::resetScriptEnv();

	return success;
}

bool Events::eventCreatureOnAttack(Creature* creature, Creature* target)
{
	// Creature:onAttack(target)
	if (creatureOnAttack == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		std::cout << "[Error - Events::eventCreatureOnAttack] Call stack overflow" << std::endl;
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(creatureOnAttack, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(creatureOnAttack);

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	LuaScriptInterface::pushUserdata<Creature>(L, target);
	LuaScriptInterface::setCreatureMetatable(L, -1, target);

	return scriptInterface.callFunction(2);
}

void Events::eventCreatureOnHear(Creature* creature, Creature* sayCreature, const std::string words, SpeakClasses type, Position pos)
{
	// Creature:onHear(sayCreature, words, type, pos)
	if (creatureOnHear == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		std::cout << "[Error - Events::eventCreatureOnHear] Call stack overflow" << std::endl;
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(creatureOnHear, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(creatureOnHear);

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	LuaScriptInterface::pushUserdata<Creature>(L, sayCreature);
	LuaScriptInterface::setCreatureMetatable(L, -1, sayCreature);

	LuaScriptInterface::pushString(L, words);
	lua_pushnumber(L, type);
	LuaScriptInterface::pushPosition(L, pos);

	scriptInterface.callVoidFunction(5);
}

bool Events::eventCreatureOnMove(Creature* creature, Position fromPos, Position toPos)
{
	// Creature:OnMove( fromPos, toPos )
	if (creatureOnMove == -1) {
		return true;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		std::cout << "[Error - Events::eventPlayerOnMove] Call stack overflow" << std::endl;
		return false;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(creatureOnMove, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(creatureOnMove);

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setMetatable(L, -1, "Creature");

	LuaScriptInterface::pushPosition(L, fromPos);
	LuaScriptInterface::pushPosition(L, toPos);

	return scriptInterface.callFunction(3);
}


void Events::eventMonsterOnTargetDeny(Creature* creature, Creature* target)
{
	// Monster:onTargetDeny(target) or Monster.onTargetDeny(self, target)
	// this is called when Creature:onTarget(..) returns false (only if the one targeting is a monster).
	if (monsterOnTargetDeny == -1) {
		return;
	}

	if (!scriptInterface.reserveScriptEnv()) {
		std::cout << "[Error - Events::eventMonsterOnTargetDeny] Call stack overflow" << std::endl;
		return;
	}

	ScriptEnvironment* env = scriptInterface.getScriptEnv();
	env->setScriptId(monsterOnTargetDeny, &scriptInterface);

	lua_State* L = scriptInterface.getLuaState();
	scriptInterface.pushFunction(monsterOnTargetDeny);

	LuaScriptInterface::pushUserdata<Creature>(L, creature);
	LuaScriptInterface::setCreatureMetatable(L, -1, creature);

	LuaScriptInterface::pushUserdata<Creature>(L, target);
	LuaScriptInterface::setCreatureMetatable(L, -1, target);

	scriptInterface.callVoidFunction(2);
}
