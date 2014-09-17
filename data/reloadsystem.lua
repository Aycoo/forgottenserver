reloadSystem =
{
	data = {}
}

function reloadSystem:addEntry(name, words, fileName)
	local d    = {}
	d.name     = name
	d.words    = words
	d.fileName = fileName
	
	table.insert(self.data, d)
end

function reloadSystem:executeFile(fileName)
	local result, err = pcall(dofile, fileName)
	
	if not result then
		print(err)
	end
	
	return result
end

function reloadSystem:executeAllEntrys()
	for _,data in ipairs(self.data) do
		self:executeFile(data.fileName)
	end	
end

function reloadSystem:tryReload(word)
	for _,data in ipairs(self.data) do
		if isInArray(data.words, word) then
			local result = self:executeFile(data.fileName)
			return true, result, data.name
		end
	end
	
	return false
end