local config = {
	centerRoom = Position(32977, 31662, 14),
	newPosition = Position(32977, 31667, 14)
}

local bosses = {
	{bossPosition = Position(32977, 31662, 14), bossName = 'The Time Guardian'},
	{bossPosition = Position(32975, 31664, 13), bossName = 'The Freezing Time Guardian'},
	{bossPosition = Position(32980, 31664, 13), bossName = 'The Blazing Time Guardian'}
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 9825 then
		if player:getPosition() ~= Position(33010, 31660, 14) then
			item:transform(9826)
			return true
		end
	end
	if item.itemid == 9825 then
		local playersTable = {}
		if doCheckBossRoom(player:getId(), "The Time Guardian", Position(32967, 31654, 13), Position(32989, 31677, 14)) then
			for q = 1,#bosses do
				Game.createMonster(bosses[q].bossName, bosses[q].bossPosition, true, true)
			end
			for y = 31660, 31664 do
				local playerTile = Tile(Position(33010, y, 14)):getTopCreature()
				if playerTile and playerTile:isPlayer() then
					playerTile:getPosition():sendMagicEffect(CONST_ME_POFF)
					playerTile:teleportTo(config.newPosition)
					playerTile:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					playerTile:setStorageValue(Storage.ForgottenKnowledge.TimeGuardianTimer, os.stime() + 20 * 60 * 60)
					table.insert(playersTable, playerTile:getId())
				end
			end
			addEvent(kickPlayersAfterTime, 30*60*1000, playersTable, Position(32967, 31654, 13), Position(32989, 31677, 14), Position(32870, 32724, 14))
			item:transform(9826)
		end
		elseif item.itemid == 9826 then
		item:transform(9825)
	end
	return true
end
