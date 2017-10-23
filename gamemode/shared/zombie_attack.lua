local meta = FindMetaTable("Player")

if (SERVER) then
	util.AddNetworkString("ZombieAttack")
	
	function meta:ZombieAttack()
		if (!self.Zomb) then return end
		if (self.NextAttack and self.NextAttack > CurTime()) then return end
		
		self.NextAttack = CurTime()+self.Zomb.CD
		
		self:LagCompensation(true)
			self.Zomb.AttackFunc(self)
		self:LagCompensation(false)
		
		net.Start("ZombieAttack")
			net.WriteEntity(self)
		net.Broadcast()
	end
	
	function meta:ZombieAttack2()
		if (!self.Zomb) then return end
		if (self.NextAttack and self.NextAttack > CurTime()) then return end
		
		self.NextAttack = CurTime()+1
		
		if (self.IdleSound) then self.IdleSound:Stop() end
		
		self.IdleSound = CreateSound(self,table.Random(self.Zomb.Sounds.Idle))
		self.IdleSound:Play()
	end
else
	net.Receive("ZombieAttack",function()
		local pl = net.ReadEntity()
		
		if (!IsValid(pl) or !pl.Zomb) then return end
		
		if (pl.AttackSound) then pl.AttackSound:Stop() end
		pl.AttackSound = CreateSound(pl,table.Random(pl.Zomb.Sounds.Attack))
		pl.AttackSound:Play()
		pl.NextAttack = CurTime()+pl.Zomb.CD
	end)
end