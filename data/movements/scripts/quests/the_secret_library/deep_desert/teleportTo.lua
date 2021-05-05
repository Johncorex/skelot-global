local lastTeleport = Position(32963, 32312, 8)
local scorpionTimer = Storage.secretLibrary.Darashia.scorpionTimer
local scorpionPosition = Position(32951, 32309, 8)
local fromPos = Position(32943, 32303, 8)
local toPos = Position(32960, 32315, 8)
local exit = Position(32963, 32307, 8)
local bossName = "furious scorpion"

local teleports = {
	[1] = {position = Position(33110, 32385, 7), destination = Position(32958, 32320, 8), storage = Storage.secretLibrary.Darashia.Questline, value = 1},
	[2] = {position = Position(32958, 32322, 8), destination = Position(33110, 32387, 7)},
	[3] = {position = Position(32955, 32288, 10), destination = Position(32955, 32284, 10), storage = Storage.secretLibrary.Darashia.colorPuzzle, value = 1,
	challenge = true},
	[4] = {position = Position(32942, 32283, 10), destination = Position(32942, 32288, 10)},
	[5] = {position = Position(32945, 32313, 8), destination = Position(33101, 32381, 7)}
}

local tileAccess = {
	[1] = {position = Position(32974, 32296, 9), storage = Storage.secretLibrary.Darashia.Questline, value = 2},
	[2] = {position = Position(32967, 32319, 9), storage = Storage.secretLibrary.Darashia.Questline, value = 3},
	[3] = {position = Position(32978, 32290, 10), storage = Storage.secretLibrary.Darashia.Questline, value = 6}
}

local puzzle = {
	{position = Position(32965, 32310, 9), value = 1},
	{position = Position(32965, 32309, 9), value = 2},
	{position = Position(32964, 32309, 9), value = 3},
	{position = Position(32963, 32309, 9), value = 4},
	{position = Position(32962, 32309, 9), value = 5},
	{position = Position(32961, 32309, 9), value = 6},
	{position = Position(32960, 32309, 9), value = 7},
	{position = Position(32959, 32309, 9), value = 8},
	{position = Position(32959, 32310, 9), value = 9},
	{position = Position(32959, 32311, 9), value = 10},
	{position = Position(32958, 32311, 9), value = 11},
	{position = Position(32957, 32311, 9), value = 12},
	{position = Position(32956, 32311, 9), value = 13},
	{position = Position(32956, 32310, 9), value = 14},
	{position = Position(32955, 32310, 9), value = 15},
	{position = Position(32954, 32310, 9), value = 16},
	{position = Position(32953, 32310, 9), value = 17},
	{position = Position(32953, 32311, 9), value = 18},
	{position = Position(32953, 32312, 9), value = 19},
	{position = Position(32953, 32313, 9), value = 20},
	{position = Position(32953, 32314, 9), value = 21},
	{position = Position(32954, 32314, 9), value = 22},
	{position = Position(32955, 32314, 9), value = 23},
	{position = Position(32956, 32314, 9), value = 24},
	{position = Position(32956, 32315, 9), value = 25},
	{position = Position(32956, 32316, 9), value = 26},
	{position = Position(32956, 32317, 9), value = 27},
	{position = Position(32957, 32317, 9), value = 28},
	{position = Position(32957, 32318, 9), value = 29},
	{position = Position(32957, 32319, 9), value = 30},
	{position = Position(32958, 32319, 9), value = 31},
	{position = Position(32959, 32319, 9), value = 32},
	{position = Position(32960, 32319, 9), value = 33},
	{position = Position(32960, 32318, 9), value = 34},
	{position = Position(32960, 32317, 9), value = 35},
	{position = Position(32961, 32317, 9), value = 36},
	{position = Position(32962, 32317, 9), value = 37},
	{position = Position(32962, 32318, 9), value = 38},
	{position = Position(32962, 32319, 9), value = 39}
}

local function startBattle(pid, position, b_name, middle)
	local player = Player(pid)
	if player then		
		player:teleportTo(position)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say("You have to master this very last challenge within 5 minutes!", TALKTYPE_MONSTER_SAY)
		local monster = Game.createMonster(b_name, middle)
	end
end

local function resetRoom(position, name)
	local spec = Game.getSpectators(position, false, false, 5, 5, 5, 5)
	for _, c in pairs(spec) do
		if c and c:isPlayer() then
			return false
		end
	end
	for _, c in pairs(spec) do
		if c and c:getName():lower() == name then
			c:remove()
		end
	end
	return true
end

function onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end
	local player = Player(creature:getId())
	if player then
		if item.actionid == 4930 then
			if position == lastTeleport then
				if resetRoom(scorpionPosition, bossName) then
					if player:getStorageValue(scorpionTimer) < os.stime() then
						player:setStorageValue(scorpionTimer, os.stime() + 20*60*60)
						startBattle(player:getId(), Position(32958, 32309, 8), bossName, scorpionPosition)
						addEvent(function(cid)
							local p = Player(cid)
							if p then
								if p:getPosition():isInRange(fromPos, toPos) then
									p:teleportTo(exit)
								end
							end
						end, 5*1000*60, player:getId())
					else
						player:sendCancelMessage('You are still exhausted from your last battle.')
						player:teleportTo(fromPosition, true)
					end
				else
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You must wait. Someone is challenging Furious Scorpion now.')
					player:teleportTo(fromPosition, true)
				end
			else
				for _, k in pairs(teleports) do
					if position == k.position then
						if k.storage then
							if player:getStorageValue(k.storage) >= k.value then
								player:teleportTo(k.destination)
							else
								if k.challenge then
									player:say('You have to master the challenge first!', TALKTYPE_MONSTER_SAY)
								end
								player:teleportTo(fromPosition, true)
							end
						else
							player:teleportTo(k.destination)
						end
						player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					end
				end
			end
		elseif item.actionid == 4931 then
			for _, k in pairs(puzzle) do
				if position == k.position then
					if player:getStorageValue(Storage.secretLibrary.Darashia.puzzleSqm) < #puzzle then
						if player:getStorageValue(Storage.secretLibrary.Darashia.puzzleSqm) == k.value then
							player:setStorageValue(Storage.secretLibrary.Darashia.puzzleSqm, player:getStorageValue(Storage.secretLibrary.Darashia.puzzleSqm)+1)
							player:getPosition():sendMagicEffect(CONST_ME_SOUND_WHITE)
						else
							player:setStorageValue(Storage.secretLibrary.Darashia.puzzleSqm, 1)
							player:getPosition():sendMagicEffect(CONST_ME_SOUND_RED)
						end
					elseif player:getStorageValue(Storage.secretLibrary.Darashia.puzzleSqm) == #puzzle then
						player:say('Access granted!', TALKTYPE_MONSTER_SAY)
						player:getPosition():sendMagicEffect(CONST_ME_SOUND_WHITE)
						player:setStorageValue(Storage.secretLibrary.Darashia.puzzleSqm, player:getStorageValue(Storage.secretLibrary.Darashia.puzzleSqm)+1)							
					end
				end
			end
		elseif item.actionid == 4932 then
			for _, k in pairs(tileAccess) do
				if position == k.position then
					if player:getStorageValue(k.storage) < k.value then
						player:setStorageValue(k.storage, player:getStorageValue(k.storage) + 1)
					end
				end
			end
		end
	end
	return true
end
