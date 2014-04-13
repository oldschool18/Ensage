--[ v 0.1]
--[[                    CONFIG                  ]]
keyCode = 0x20 -- space key :D
range = 1000
 
--[[                    Code                    ]]
sleepTick = nil
activated = false
 
function Tick( tick )
        if not engineClient.ingame or engineClient.console or (sleepTick and sleepTick > tick) or not activated then
                return
        end
 
        if me.name ~= "PhantomAssassin" then
                script:Unload()
                print("Unload we are not playing PhantomAssassin!!")
                return
        end
       
        if me.name == "PhantomAssassin" then
                print(">>PHANTOM ASSASSIN LOADED<<")
        end
       
 
        local _Q = me:GetAbility(1)
        local _W = me:GetAbility(2)
        local _E = me:GetAbility(3)
        local _R = me:GetAbility(4)
        local target = nil
        local enemies = entityList:FindEntities({type=TYPE_HERO,team=TEAM_ENEMY,alive=true,visible=true})
        for i,v in ipairs(enemies) do
                local distance = GetDistance3D(me,v)
                -- get a valid target
                if not target and distance < range and v.replicatingModel==-1 then
                        target = v
                end
                -- get closest target
                if target and distance < GetDistance3D(me,target) then
                target = v
                end
        end
 
        if target then
                CastSpell(_Q,target)
                CastSpell(_W,target)
                Attack(v)
                sleepTick = tick + 300
                return
                end
        end
function Frame(tick)
        if not engineClient.ingame or engineClient.console or not activated then
                return
        end
end
function CastSpell(spell,target)
if spell.state == STATE_READY then
UseAbility(spell,target)
end
end
 
 
 
function Key( msg, code )
        if code == keyCode then
                activated = (msg == KEY_DOWN)
        end
end
 
function GetDistance3D(p,t)
        return math.sqrt(math.pow(p.x-t.x,2)+math.pow(p.y-t.y,2)+math.pow(p.z-t.z,2))
end
 
script:RegisterEvent(EVENT_TICK,Tick)
script:RegisterEvent(EVENT_KEY,Key)
script:RegisterEvent(EVENT_FRAME,Frame)
