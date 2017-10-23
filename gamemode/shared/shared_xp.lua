
--> Inherited from Old Age 2 scripts made by The Maw. <--

local meta = FindMetaTable("Player")

if (SERVER) then
	util.AddNetworkString("SetXP")
	util.AddNetworkString("SetupLeveling")
	util.AddNetworkString("SetLevel")

	function meta:AddXP(xp)
		if (!self.xp) then self.xp = 0 end
		if (!self.Level) then self.Level = 1 end
		
		self.xp = self.xp + xp
		
		self:RecalcLevel()
		
		net.Start("SetXP")
			net.WriteEntity(self)
			net.WriteUInt(self.xp,32)
		net.Broadcast() --Think ill be sending this to everyone :)
	end
	
	function meta:SetupPlayerRank(xp,level)
		net.Start("SetupLeveling")
			net.WriteEntity(self)
			net.WriteUInt(xp,32)
			net.WriteUInt(level,8)
		net.Broadcast()
		
		self.xp 	= xp
		self.Level 	= level
	end
	
	function meta:UpdatePlayerRank(pl)
		net.Start("SetupLeveling")
			net.WriteEntity(self)
			net.WriteUInt(self.xp or 0,32)
			net.WriteUInt(self.Level or 1,8)
		if (IsValid(pl)) then net.Send(pl)
		else net.Broadcast() end
	end
	
	function meta:RecalcLevel()
		if (!self.xp) then return 1 end
		if (!self.Level) then self.Level = 1 end
		
		local Level = self.Level
		
		repeat
			local XP = 178 + Level^2 * (22*Level)
			
			if (self.xp >= XP) then Level = Level+1 self.xp = self.xp-XP end
		until (self.xp < XP or Level > 90)
		
		if (Level != self.Level) then 
			self.Level = Level
			
			net.Start("SetLevel")
				net.WriteEntity(self)
				net.WriteUInt(self.Level,8)
			net.Broadcast()
			
			--LEVELUP!
			self:OnLevelUp(Level)
		end
	end
else
	net.Receive("SetXP",function(size) net.ReadEntity().xp = net.ReadUInt(32) end)
	net.Receive("SetLevel",function(size) 
		local pl = net.ReadEntity()
		pl.Level = net.ReadUInt(8) 
		pl:OnLevelUp(pl.Level)
	end)
	
	net.Receive("SetupLeveling",function(size)
		local Ply 	= net.ReadEntity()
		
		Ply.xp 		= net.ReadUInt(32)
		Ply.Level 	= net.ReadUInt(8)
	end)
end

function meta:GetXP()
	return self.xp or 0
end

function meta:GetLevel()
	return self.Level or 1
end

function meta:GetRequiredXP()
	local Level = self:GetLevel()
	return (178 + Level^2 * (22*Level))
end

function meta:OnLevelUp(lvl)
	if (SERVER) then
	else
		self:EmitSound("music/class_menu_0"..math.random(1,9)..".wav")
	end
end
	
	
	
	
	