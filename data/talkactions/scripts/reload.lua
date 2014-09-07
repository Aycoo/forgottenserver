local reloadData =
{
	{
		names = {"global","global.lua"},
		name  = "Global.lua",
		reloadType = RELOADTYPE_GLOBAL
	},
	{
		names = {"action","actions"},
		name  = "Actions",
		reloadType = RELOADTYPE_ACTIONS
	},
	{
		names = {"config","configuration"},
		name  = "Configuration",
		reloadType = RELOADTYPE_CONFIG
	},
	{
		names = {"creaturescript","creaturescripts"},
		name  = "CreatureScripts",
		reloadType = RELOADTYPE_CREATURESCRIPTS
	},
	{
		names = {"monster","monsters"},
		name  = "Monsters",
		reloadType = RELOADTYPE_MONSTERS
	},
	{
		names = {"move","movement","movements","moveevents","moveevent"},
		name  = "Movements",
		reloadType = RELOADTYPE_MOVEMENTS
	},
	{
		names = {"npc","npcs"},
		name  = "Npcs",
		reloadType = RELOADTYPE_NPCS
	},
	{
		names = {"raid","raids"},
		name  = "Raids",
		reloadType = RELOADTYPE_RAIDS
	},
	{
		names = {"spell","spells"},
		name  = "Spells",
		reloadType = RELOADTYPE_SPELLS
	},
	{
		names = {"talk","talkaction","talkactions"},
		name  = "Talkactions",
		reloadType = RELOADTYPE_TALKACTIONS
	},
	{
		names = {"items"},
		name  = "Items",
		reloadType = RELOADTYPE_ITEMS
	},
	{
		names = {"weapon","weapons"},
		name  = "Weapons",
		reloadType = RELOADTYPE_WEPONS
	},
	{
		names = {"quest","quests"},
		name  = "Quests",
		reloadType = RELOADTYPE_QUESTS
	},
	{
		names = {"mount","mounts"},
		name  = "Mounts",
		reloadType = RELOADTYPE_MOUNTS
	},
	{
		names = {"globalevent","globalevents"},
		name  = "GlobalEvents",
		reloadType = RELOADTYPE_GLOBALEVENTS,
	},
	{
		names = {"event","events"},
		name  = "Events",
		reloadType = RELOADTYPE_EVENTS,
	},
	{
		names = {"chat","channel","chatchannels"},
		name  = "ChatChannels",
		reloadType = RELOADTYPE_CHATCHANNELS
	}
}

function onSay(cid, words, param)
	
	local player = Player(cid)
	
	local command = param:lower()
	
	for _, data in ipairs( reloadData ) do
		if isInArray( data.names, command ) then
			if reloadInfo( data.reloadType ) then
				player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format("Reloaded %s.", data.name))
			else
				player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, string.format("Failed to reload %s.", data.name))
			end
			
			return false
		end
	end
	
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Reload type not found.")

	return false
end
