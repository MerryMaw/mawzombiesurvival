
hook.Add("OnNPCKilled","AddFragNPC",function(npc,att,inflicter)
	if (att:IsPlayer() and !att.Zomb) then att:AddFrags(1) att:AddXP(math.random(5))  end
end)

hook.Add("PlayerHurt","AddFrag",function(vict,att,HPLeft,Dmg)
	if (att:IsPlayer() and HPLeft <= 0) then att:AddFrags(1) att:AddXP(math.random(50)) end
end)