local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SMALLPLANTS)
combat:setArea(createCombatArea(AREA_SQUAREWAVE5, AREADIAGONAL_SQUAREWAVE5))

function onGetFormulaValues(player, level, magicLevel)
	local min = (level / 5) + (magicLevel * 3.25) + 5
	local max = (level / 5) + (magicLevel * 6.75) + 30
	return player:getSpellDamage(-min, -max)
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(creature, variant)
	local player = Player(creature:getId())
	if player then
		if not player:isWarAllowed(CONST_WAR_WAVE) then
			player:sendCancelMessage("This action is not allowed here.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end
	end
	return combat:execute(creature, variant)
end
