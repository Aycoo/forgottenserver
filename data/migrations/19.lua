function onUpdateDatabase()
	print("> Updating database to version 20")
	print("> Skill Rates (level, magiclevel, fist, sword, etc.) are saved in database now.")
	print("> You can use :setRate(skilltype, value) or :getRate(skilltype) to set and get the rate.")
	print("> example: player:setRate(SKILL_LEVEL, 10.5) player:getRate(SKILL_LEVEL)")
	db.query("CREATE TABLE IF NOT EXISTS `player_rates` (`player_id` int(11) NOT NULL, `level` DOUBLE(6,1) NOT NULL DEFAULT '0.0', `magic_level` DOUBLE(6,1) NOT NULL DEFAULT '0.0', `fist` DOUBLE(6,1) NOT NULL DEFAULT '0.0', `club` DOUBLE(6,1) NOT NULL DEFAULT '0.0', `sword` DOUBLE(6,1) NOT NULL DEFAULT '0.0', `axe` DOUBLE(6,1) NOT NULL DEFAULT '0.0', `distance` DOUBLE(6,1) NOT NULL DEFAULT '0.0', `shield` DOUBLE(6,1) NOT NULL DEFAULT '0.0', `fish` DOUBLE(6,1) NOT NULL DEFAULT '0.0', UNIQUE KEY `player_id` (`player_id`), FOREIGN KEY (`player_id`) REFERENCES `players`(`id`) ON DELETE CASCADE ) ENGINE=InnoDB;")
	return true
end
