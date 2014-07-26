function onSay(cid, words, param)
	local player = Player(cid)
	local orig = player:getPosition()
	local npcId = doCreateNpc(param, orig)
	if npcId ~= false then
		orig:sendMagicEffect(CONST_ME_MAGIC_RED)
	else
		player:sendCancelMessage("There is not enough room.")
		orig:sendMagicEffect(CONST_ME_POFF)
	end
	return false
end
