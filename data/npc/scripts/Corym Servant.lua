local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	
	local player = Player(cid)
	if msgcontains(msg, "mission") and player:getStorageValue(50733) == -1 then
		npcHandler:say("Now you have access to the door.", cid)
		player:setStorageValue(50733, 1)
	end
	return true
end

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "It's my duty to protect the city."})

npcHandler:setMessage(MESSAGE_GREET, "Hi mate!")
npcHandler:setMessage(MESSAGE_FAREWELL, "bye mate!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "bye mate!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
