local doors = {
	[1] = {doorPosition = Position(33376, 31323, 2), nivel = -1},
	[2] = {doorPosition = Position(33376, 31335, 3), nivel = 1},
	[3] = {doorPosition = Position(33376, 31349, 4), nivel = 2},
	[4] = {doorPosition = Position(33363, 31346, 7), nivel = 4}, -- última porta!!
}

local boats = {
	[1] = {boatPosition = Position(33373, 31309, 7), nivel = 3, toPosition = Position(33382, 31292, 7), message = "A small island emerges out of the mist as you row towards a tiny light inside a dark, forehoding chapel."},
	[2] = {boatPosition = Position(33381, 31294, 7), nivel = 3, toPosition = Position(33374, 31309, 7), message = "Your heart lightens as you return from the gloomy isle."},
	[3] = {boatPosition = Position(33344, 31348, 7), nivel = 3, toPosition = Position(33326, 31352, 7)},
	[4] = {boatPosition = Position(33328, 31352, 7), nivel = 3, toPosition = Position(33346, 31348, 7)},
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item:getActionId() == 4920 then -- Portas!!
		for _, p in pairs(doors) do
			local door = p.doorPosition
			local nivel = p.nivel
			if (item:getPosition() == door) and not(Tile(item:getPosition()):getTopCreature()) then
				if player:getStorageValue(Storage.secretLibrary.FalconBastion.killingBosses) >= nivel then
						player:teleportTo(toPosition, true)
						item:transform(item.itemid + 1)
					else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The door seems to be sealed against unwanted intruders.")	
				end	
			end
		end
	elseif item:getActionId() == 4921 then -- Barcos!!
		for _, p in pairs(boats) do
			local boat = p.boatPosition
			local nivel = p.nivel
			local toPos = p.toPosition
			local message = p.message
			if item:getPosition() == boat then
				if player:getStorageValue(Storage.secretLibrary.FalconBastion.killingBosses) >= nivel then
					player:teleportTo(toPos, true)
					player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					if message then
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
					end	
					else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can not use this boat yet.")	
				end	
			end
		end
	end
return true
end



