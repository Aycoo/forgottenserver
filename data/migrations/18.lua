function onUpdateDatabase()
	print("> Updating database to version 19 (added maxSummons for player table)")
	db.query("ALTER TABLE `players` ADD `max_summons` INT(11) NOT NULL DEFAULT '0'")
	return true
end
