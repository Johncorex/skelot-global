local questline = Storage.DreamCourts.HauntedHouse.Questline
local wordsCount = Storage.DreamCourts.BurriedCatedral.wordCount

local facelessTime = Storage.DreamCourts.BurriedCatedral.facelessTime

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return true
	end
	if player:getStorageValue(questline) == 2 and player:getStorageValue(wordsCount) >= 4 then
		player:setStorageValue(questline, 3)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'This book tells you about a spell that draws its wielder towards the most energetic being next to him.')	
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'It consists of four parts wich have been scratched out of this book. They need to be read in conjunction with chants.')
	elseif player:getStorageValue(questline) >= 4 then
		if player:getStorageValue(facelessTime) > os.stime() then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have to wait to challange this enemy again!')
			return true
		else
			player:teleportTo(Position(33640, 32561, 13))
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'All chants have been sung in the right order, you are deemed worthy. You are transported away...')
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
	end
	return true
end
