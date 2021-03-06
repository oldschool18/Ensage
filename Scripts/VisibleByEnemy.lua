eff = {}
sleeptick = 0

function Tick(tick)
	if not client.connected or client.loading or client.console or tick < sleeptick then 
		return 
	end 

	sleeptick = tick + 200 -- 5 times a second should be enough

	local me = entityList:GetMyHero()
	if not me then
		return
	end

	local hero = entityList:GetEntities({type=LuaEntity.TYPE_HERO, alive = true})
	local effectDeleted = false
	for _,v in ipairs(hero) do 
		if v.team == me.team then
			local OnScreen = client:ScreenPosition(v.position)	
			if OnScreen then

				local effect = nil
				if v.handle == me.handle then -- comparing handles
					effect = "aura_shivas" 
				else 
					effect = "ambient_gizmo_model" 
				end

				local visible = v.visibleToEnemy
				if eff[v.handle] == nil and visible then						    
					eff[v.handle] = Effect(v,effect)
					eff[v.handle]:SetVector(1,Vector(0,0,0))
				elseif not visible and eff[v.handle] ~= nil then
					eff[v.handle] = nil
					effectDeleted = true

				end					
			end
		end
	end

	if effectDeleted then -- only call it once even when 1000 effects are deleted
		collectgarbage("collect")
	end
end

function GameClose()
	eff = {}
	collectgarbage("collect")
end

script:RegisterEvent(EVENT_CLOSE, GameClose)
script:RegisterEvent(EVENT_TICK, Tick)
