-- acesso liberado
function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(item.itemid + 1)
	player:teleportTo(toPosition, true)
	return false
end
