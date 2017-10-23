
if (SERVER) then
	hook.Add("PlayerCanPickupWeapon","ZombiePickupWeapons",function(pl) if (pl.Zomb) then return false end end)
	hook.Add("PlayerCanPickupItem","ZombiePickupItems",function(pl) if (pl.Zomb) then return false end end)
	hook.Add("GetFallDamage","ZombieFallDamage",function(pl,speed) if (pl.Zomb) then return 0 end end)
	
	
	--Tick
	hook.Add("Tick","TickZombie",function()
		for k,v in pairs(player.GetAllZombies()) do
			if (!v:Alive()) then
				if (v.PreviousTakeoff) then 
					v.PreviousTakeoff:Stop() 
					v.PreviousTakeoff = nil 
				end
			else
				local Ground = v:OnGround()
				
				if (!Ground and !v.PreviousTakeoff) then
					v.PreviousTakeoff = CreateSound(v,table.Random(v.Zomb.Sounds.Jump))
					v.PreviousTakeoff:Play()
				elseif (Ground) then
					if (v.PreviousTakeoff) then
						v.PreviousTakeoff:Stop()
						v.PreviousTakeoff = nil
					end
					
					if (v:KeyDown(IN_ATTACK)) then
						v:ZombieAttack()
					end
					
					if (v:KeyDown(IN_ATTACK2)) then
						v:ZombieAttack2()
					end
				end
			end
		end
	end)
else
end