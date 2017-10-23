
local meta 			= FindMetaTable("Player")
local Preload_Data 	= GetZombieData()
local insert 		= table.insert

if (SERVER) then
	util.AddNetworkString("UpdateZombie")
	util.AddNetworkString("RequestUpdateZombie")
	util.AddNetworkString("RequestTransformZombie")
	
	function meta:ZombifyPlayer(ZombieType)
		local Dat = Preload_Data[ZombieType]
		ZombifiedPlayers[self:SteamID64()] = ZombieType
		
		self:StripWeapons() 
		
		self:SetHealth(Dat.HP)
		self:SetWalkSpeed(Dat.WalkSP)
		self:SetRunSpeed(Dat.RunSP)
		self:SetJumpPower(Dat.JumpP)
		
		self.Zomb = Dat
		self:SetModel(Dat.Model)
		self:SetViewOffset(Dat.OffPos)
		self:SetViewOffsetDucked(Dat.OffPos)
		
		if (Dat.Hull) then
			self:SetHull(Dat.Hull.Mins,Dat.Hull.Maxs)
			self:SetHullDuck(Dat.Hull.Mins,Dat.Hull.Maxs)
		end
		
		self:UpdateZombie()
		
		FriendNPCs(self)
	end
	
	function meta:UpdateZombie(pl)
		net.Start("UpdateZombie")
			net.WriteEntity(self)
			if (self.Zomb) then net.WriteString(self.Zomb.Name) end
		if (IsValid(pl)) then net.Send(pl)
		else net.Broadcast() end
	end

	net.Receive("RequestTransformZombie",function(bit,pl)
		local Zombie = net.ReadString()
		
		pl.NextZombie = Zombie
		pl:ChatPrint("You will become a "..Zombie.." next time you spawn!")
	end)
else
	net.Receive("UpdateZombie",function()
		local pl = net.ReadEntity()
		local zo = net.ReadString()
		
		if (!IsValid(pl)) then return end
		
		pl.Zomb = Preload_Data[zo]
		
		if (pl.Zomb and pl.Zomb.Hull) then
			pl:SetHull(pl.Zomb.Hull.Mins,pl.Zomb.Hull.Maxs)
			pl:SetHullDuck(pl.Zomb.Hull.Mins,pl.Zomb.Hull.Maxs)
		end
	end)
	
	function RequestChangeZombie(Zomb)
		net.Start("RequestTransformZombie")
			net.WriteString(Zomb)
		net.SendToServer()
	end
end



function player.GetAllZombies()
	local Dat = {}
	
	for k,v in pairs(player.GetAll()) do
		if (v.Zomb) then insert(Dat,v) end
	end
	
	return Dat
end

function player.GetAllAlive()
	local Dat = {}
	
	for k,v in pairs(player.GetAll()) do
		if (!v.Zomb) then insert(Dat,v) end
	end
	
	return Dat
end
