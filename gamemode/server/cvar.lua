

concommand.Add("TestNPC",function(pl,com,arg)
	if (!pl:IsAdmin()) then return end
	
	local ab = ents.Create("mzs_npc_survivor")
	ab:SetPos(pl:GetEyeTrace().HitPos)
	ab:Spawn()
	ab:Activate()
end)