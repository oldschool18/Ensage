manacost = {120,140,160,180}
damage = {100,175,250,325}
range = 2500
sleepTick = nil




function Tick( tick )
	if not engineClient.ingame or engineClient.console or not me then
		return
	end

	-- No Beam Spamming
	if sleepTick and sleepTick > tick then
		return
	end

	-- Hero check
	if me.name ~= "Tinker" then
		script:Unload()
		print("Unload we are not playing Tinker!")
		return
	end
	
	-- Checks if we already skilled our beam and if it's ready
	local beam = me:GetAbility(2)
	if not beam or beam.level == 0 or beam.state ~= STATE_READY then
		return
	end
	
	-- Checks for visible enemy heroes
	enemies = entityList:FindEntities({type=TYPE_HERO,team=TEAM_ENEMY,alive=true,visible=true})
	for i,v in ipairs(enemies) do
	-- Distance Check
	local distance = GetDistance2D(me,v)
	-- Casting skill Check
		if v.health > 0 and v.health < damage[beam.level]*(100-v.magicDmgResist)/100 and distance < range and not v.illusion then
			UseAbility(beam)
			sleepTick = tick + 1000
			return
		end
	end
end

function GetDistance2D(a,b)
	return math.sqrt(math.pow(a.x-b.x,2)+math.pow(a.y-b.y,2))
end

script:RegisterEvent(EVENT_TICK,Tick)
