function onAppear(cid)
	local creature = Creature(cid)
	if creature:isMonster() then
		if not isInArray(monsters,creature:getName(),true) then
			monsters[creature:getName()] = {}
			monsters[creature:getName()][1] = cid
		else
			monsters[creature:getName()][#monsters == nil and 1 or #monsters[creature:getName()]+1] = cid
		end
	end
	return true
end

function onDisappear(cid)
	local creature = Creature(cid)
	if creature:isMonster() then
		for i = 1, #monsters[creature:getName()] do
			if monsters[creature:getName()][i] == cid then
				table.remove(monsters[creature:getName()], i)
				break
			end
		end
		table.sort(monsters[creature:getName()])
	end
	return true
end
