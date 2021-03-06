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

#ifndef FS_EVENTS_H_BD444CC0EE167E5777E4C90C766B36DC
#define FS_EVENTS_H_BD444CC0EE167E5777E4C90C766B36DC

#include "luascript.h"
#include "const.h"

class Party;
class ItemType;

class Events
{
	public:
		Events();
		~Events() {}

		void clear();
		bool load();

		// Party
		bool eventPartyOnJoin(Party* party, Player* player);
		bool eventPartyOnLeave(Party* party, Player* player);
		bool eventPartyOnDisband(Party* party);

		// Player
		bool eventPlayerOnBrowseField(Player* player, const Position& position);
		void eventPlayerOnLook(Player* player, const Position& position, Thing* thing, uint8_t stackpos, int32_t lookDistance);
		void eventPlayerOnLookInBattleList(Player* player, Creature* creature, int32_t lookDistance);
		void eventPlayerOnLookInTrade(Player* player, Player* partner, Item* item, int32_t lookDistance);
		bool eventPlayerOnLookInShop(Player* player, const ItemType* itemType, uint8_t count);
		bool eventPlayerOnMoveItem(Player* player, Item* item, uint16_t count, const Position& fromPosition, const Position& toPosition);
		bool eventPlayerOnMoveCreature(Player* player, Creature* creature, const Position& fromPosition, const Position& toPosition);
		bool eventPlayerOnTurn(Player* player, Direction direction);
		bool eventPlayerOnTradeRequest(Player* player, Player* target, Item* item);

		void eventPlayerOnGainExperience(Player* player, Creature* target, uint64_t &exp, uint64_t rawExp);
		void eventPlayerOnLoseExperience(Player* player, uint64_t &exp);
		bool eventPlayerGetCustomMissionDescription(Player* player, std::string &description);
		bool eventPlayerOnSave(Player* player);

		// Creature
		bool eventCreatureOnTarget(Creature* creature, Creature* target, bool isAttacked);

		void eventCreatureOnChangeOutfit(Creature* creature, Outfit_t &outfit, const Outfit_t oldOutfit);
		bool eventCreatureOnAttack(Creature* creature, Creature* target);
		void eventCreatureOnHear(Creature* creature, Creature* sayCreature, const std::string words, SpeakClasses type, Position pos);
		bool eventCreatureOnMove(Creature* creature, Position fromPos, Position toPos);
		
		// Monster
		void eventMonsterOnTargetDeny(Creature* creature, Creature* target);

	private:
		LuaScriptInterface scriptInterface;

		// Party
		int32_t partyOnJoin;
		int32_t partyOnLeave;
		int32_t partyOnDisband;

		// Player
		int32_t playerOnBrowseField;
		int32_t playerOnLook;
		int32_t playerOnLookInBattleList;
		int32_t playerOnLookInTrade;
		int32_t playerOnLookInShop;
		int32_t playerOnMoveItem;
		int32_t playerOnMoveCreature;
		int32_t playerOnTurn;
		int32_t playerOnTradeRequest;
		int32_t playerOnGainExperience;
		int32_t playerOnLoseExperience;
		int32_t playerGetCustomMissionDescription;
		int32_t playerOnSave;


		// Creature
		int32_t creatureOnTarget;
		int32_t creatureOnChangeOutfit;
		int32_t creatureOnAttack;
		int32_t creatureOnHear;
		int32_t creatureOnMove;
		// Monster
		int32_t monsterOnTargetDeny;
};

#endif
