local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_EXPLOSIONHIT)

local area = createCombatArea(AREA_CIRCLE3X3)
combat:setArea(area)

function spellCallbackTemp(param)
	local tile = Tile(Position(param.pos))
	if tile then
		local creature = tile:getTopCreature()
		if creature then
			if creature:isPlayer() or creature:getMaster() then
				doTargetCombat(0, creature, COMBAT_FIREDAMAGE, 0, -1500, CONST_ME_HITBYFIRE, ORIGIN_NONE)
			else
				if creature:getName():lower() == "the duke of the depths" then
					doTargetCombat(0, creature, COMBAT_HEALING, 0, 5000, CONST_ME_MAGIC_BLUE)
				end
			end
		end
	end
end

function onTargetTile(cid, pos)
	local param = {}
	param.cid = cid
	param.pos = pos
	param.count = 0
	spellCallbackTemp(param)
end

setCombatCallback(combat, CALLBACK_PARAM_TARGETTILE, "onTargetTile")

local function suicideHeart(creature)
	local c = Creature(creature)
	if c then
		local cPosition = c:getPosition()
		c:remove()
		local fieryBlood = Game.createMonster("Fiery Blood", cPosition, true, true)
		if fieryBlood then
			local var = {type = 1, number = fieryBlood:getId()}
			combat:execute(fieryBlood, var)
		end
	end
end

function onThink(creature)
	if not creature:isMonster() then
		return true
	end
	local contadorHearts = 0
	local bossId
	if creature:getName():lower() == "the fire empowered duke" then
		bossId = Creature(creature:getId())
		local spectators = Game.getSpectators(creature:getPosition(), false, false, 20, 20, 20, 20)
		for _, spectator in pairs(spectators) do
			if spectator:getName():lower() == "fiery heart" then
				contadorHearts = contadorHearts + 1
			end
		end
		if contadorHearts < 1 then
			if bossId then
				local oldBossHealth = bossId:getHealth()
				local oldBossPosition = bossId:getPosition()
				bossId:remove()
				local newBoss = Game.createMonster("the duke of the depths", oldBossPosition, true, true)
				if newBoss then
					newBoss:addHealth(-(newBoss:getHealth() - oldBossHealth))
				end
			end
		end
	end

	if creature:getName():lower() == "fiery heart" then
		if creature then
			addEvent(suicideHeart, 20*1000, creature:getId())
		end
	end

	return true
end
