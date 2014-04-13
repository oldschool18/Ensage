manacost = {90,100,110,120}
damage = {75,150,225,300}
range = 800
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
	if me.name ~= "Luna" then
		script:Unload()
		print("Unload we are not playing Luna!")
		return
	end
	
	-- Checks if we already skilled our beam and if it's ready
	local beam = me:GetAbility(1)
	if not beam or beam.level == 0 or beam.state ~= -1 then
		return
	end
	
	-- Checks for visible enemy heroes
	enemies = entityList:FindEntities({type=TYPE_HERO,team=TEAM_ENEMY,alive=true,visible=true})
	for i,v in ipairs(enemies) do
	-- Distance Check
	local distance = GetDistance2D(me,v)
	-- Casting skill Check
		if v.health > 0 and v.health < damage[beam.level]*0.73 and distance < range and v.replicatingModel == -1 then
			UseAbility(beam,v)
			sleepTick = tick + 1000
			return
		end
	end
end

function GetDistance2D(a,b)
	return math.sqrt(math.pow(a.x-b.x,2)+math.pow(a.y-b.y,2))
end

script:RegisterEvent(EVENT_TICK,Tick)
