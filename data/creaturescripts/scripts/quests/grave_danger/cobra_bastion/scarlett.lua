local storage = Storage.GraveDanger.CobraBastion.Questline
local rooms = {
	[1] = {fromPos = Position(33390, 32642, 6), toPos = Position(33394, 32646, 6)},
	[2] = {fromPos = Position(33390, 32646, 6), toPos = Position(33394, 32650, 6)},
	[3] = {fromPos = Position(33390, 32650, 6), toPos = Position(33394, 32654, 6)},
	[4] = {fromPos = Position(33394, 32642, 6), toPos = Position(33398, 32646, 6)},
	[5] = {fromPos = Position(33394, 32646, 6), toPos = Position(33398, 32650, 6)},
	[6] = {fromPos = Position(33394, 32650, 6), toPos = Position(33398, 32654, 6)},
	[5] = {fromPos = Position(33398, 32642, 6), toPos = Position(33402, 32646, 6)},
	[6] = {fromPos = Position(33398, 32646, 6), toPos = Position(33402, 32650, 6)},
	[7] = {fromPos = Position(33398, 32650, 6), toPos = Position(33402, 32654, 6)}
}

local function isMirrorsCorrect(fromPosition, toPosition)
	local transformTo = {
		[36188] = {m = false},
		[36189] = {m = false},
		[36191] = {m = false},
		[36190] = {m = false}
	}
	local it1 = Tile(fromPosition):getItemById(36188)
	local it2 = Tile(Position(fromPosition.x + 4, fromPosition.y, fromPosition.z)):getItemById(36189)
	local it3 = Tile(Position(toPosition.x - 4, toPosition.y, toPosition.z)):getItemById(36191)
	local it4 = Tile(toPosition):getItemById(36190)
	if it1 and it2 and it3 and it4 then
		return true
	end
	return false
end

local eventDoDamage = function(creatureid, attackerid, type)
	local creature = Creature(creatureid)
	if not creature then
		return
	end

	local damage = creature:getMaxHealth()/4
	creature:say('AHHHHHHHHHHH!', TALKTYPE_MONSTER_SAY)
	doTargetCombat(attackerid, creature, type, -damage, -damage, CONST_ME_POFF, ORIGIN_NONE)
	creature:setMoveLocked(false) -- false - pode andar
end

local eventRemoveFreeze = function(creatureid, evented)
	local creature = Creature(creatureid)
	if not creature then
		return
	end

	if creature:isMoveLocked() then
		creature:setMoveLocked(false) -- false - pode andar
		if evented then
			SCARLETT_MAY_DIE = 0
		end
	end
end

local function changeScarlett(creatureid)
	local creature = Creature(creatureid)
	if not creature then
		return
	end

	creature:say('Galthen... is that you?', TALKTYPE_MONSTER_SAY)
	SCARLETT_MAY_DIE = 1
	SCARLETT_MAY_TRANSFORM = 0
	creature:setMoveLocked(true) -- true nao pode andar
	addEvent(eventRemoveFreeze, 4*1000, creature:getId(), true)
end

function onThink(creature)
	if not creature:isMonster() then
		return true
	end

	-- deu use na estatua?
	if SCARLETT_MAY_TRANSFORM ~= 1 then
		return true
	end

	local mirrorsCount = 0
	for _, p in pairs(rooms) do
		if creature:getPosition():isInRange(p.fromPos, p.toPos) then			
			if isMirrorsCorrect(p.fromPos, p.toPos) then
				addEvent(changeScarlett, 0.5*1000, creature:getId())
				return true
			end
		end
	end
	return true
end

function onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if not creature:isMonster() then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	if creature:getStorageValue(storage) ~= 1 then
		return primaryDamage, primaryType, secondaryDamage, secondaryType
	end

	-- se torna imune a tudo
	if not creature:isMoveLocked() then
		return primaryDamage*0.01, primaryType, secondaryDamage*0.01, secondaryType
	end

	local spec = Game.getSpectators(creature:getPosition(), false, false, 4, 4, 4, 4)
	for _, c in pairs(spec) do
		if c and (c:isPlayer() or c:getMaster()) then
			doTargetCombat(creature:getId(), c, COMBAT_EARTHDAMAGE, -7500, -7500, CONST_ME_GROUNDSHAKER)
		end
	end

	addEvent(eventDoDamage, 200, creature:getId(), attacker:getId(), primaryType)
	SCARLETT_MAY_DIE = 0
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end