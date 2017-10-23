

if (SERVER) then
	net.Receive("RequestUpdateZombie",function(bit,pl)
		local ReqPl = net.ReadEntity()
		
		if (!IsValid(ReqPl) or !ReqPl:IsPlayer()) then return end
		
		ReqPl:UpdateZombie(pl)
		ReqPl:UpdatePlayerRank(pl)
	end)
else
	local Count  = 0
	local simple = timer.Simple
	
	hook.Add("NetworkEntityCreated","UpdateZombiePlayer",function(pl)
		if (!pl:IsPlayer()) then return end
		
		Count=Count+1
		simple(0.1*Count,function()
			net.Start("RequestUpdateZombie") net.WriteEntity(pl) net.SendToServer()
			Count=Count-1
		end)
	end)
end