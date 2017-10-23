
if (SERVER) then
	hook.Add("OnEntityCreated","UpdateZombieNPC",function(npc)
		if (!npc:IsNPC()) then return end
		
		for k,v in pairs(player.GetAllZombies()) do
			npc:AddEntityRelationship(v,D_LI,99)
		end
	end)
	
	function FriendNPCs(pl)
		for k,v in pairs(ents.FindByClass("npc_*")) do
			if (v:IsNPC()) then
				v:AddEntityRelationship(pl,D_LI,99)
			end
		end
	end
end