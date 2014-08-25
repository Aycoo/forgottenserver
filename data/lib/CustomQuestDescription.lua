customMissionDescription = 
{
	callbacks = {}
}

function customMissionDescription:onMissionDescription(player, descriptionId)

	if self.callbacks[descriptionId] then
	
		local result = self.callbacks[descriptionId](player, descriptionId)
		
		if not (type(result) == 'string') then
			print("customMissionDescription:onMissionDescription(player, descriptionId) - ERROR! callback for : " .. descriptionId .. " is not returning a string.")
			return false
		end
		
		return result
	end
	
	print("customMissionDescription:onMissionDescription(player, descriptionId) - ERROR! No callback for description: " .. descriptionId)
	
	return descriptionId
end

function customMissionDescription:addCallback(descriptionId, callback)
	self.callbacks[descriptionId] = callback
end

local function beingCoolCallback( player, descriptionId )
	local t = {'Not cool :(', 'Cool :)', 'Ask me again.', 'Maybe tomorrow.'}
	
	return t[math.random(1, #t)]
end

customMissionDescription:addCallback('BeingCoolDescriptionId', beingCoolCallback)