function onSay(cid, words, param)
	local player = Player(cid)
	managementChoices[1] = {}; managementChoices[1].id = 1; managementChoices[1].text = "Players (".. #getOnlinePlayers() ..")"
	managementChoices[2] = {}; managementChoices[2].id = 2; managementChoices[2].text = "NPCs (".. Game.getNpcCount() ..")"
	managementChoices[3] = {}; managementChoices[3].id = 3; managementChoices[3].text = "Monsters (".. Game.getMonsterCount() ..") (NOT FINISHED)"
	managementChoices[4] = {}; managementChoices[4].id = 4; managementChoices[4].text = "Spawn NPC (NOT FINISHED)"
	managementChoices[5] = {}; managementChoices[5].id = 5; managementChoices[5].text = "Spawn Monster (NOT FINISHED)"
	managementChoices[6] = {}; managementChoices[6].id = 6; managementChoices[6].text = "Teleport all players to temple"
	createWindowWithButtons(player, management, windows.Management, "Management", "Ingame Administration Tool:\nCreated by Evil Hero @ otland", managementButtons, managementChoices, true, false)
	return false
end