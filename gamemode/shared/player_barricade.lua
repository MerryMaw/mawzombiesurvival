local meta = FindMetaTable("Player")

function meta:PerformPlankTrace(Yaw)
	local Tr = util.TraceLine({
		start = self:GetShootPos(),
		endpos = self:GetShootPos()+self:GetAimVector()*150,
		filter = self,
		mask = MASK_SOLID_BRUSHONLY,
	})
	
	local Norm = Tr.HitNormal
	local Ang  = Norm:Angle()
	Ang:RotateAroundAxis(Ang:Forward(),Yaw or 0)
	
	return Tr,Ang
end

if (SERVER) then
	util.AddNetworkString("RequestPlaceBarricade")
	
	function meta:PlaceBarricade(Yaw)
		if (self.Barricades and #self.Barricades > 3) then self:ChatPrint("You already have 4 barricades placed on the map! Destroy the previous ones to place new ones.") return end
		if (self.Zomb) then return end
		
		self.Barricades = self.Barricades or {}
		
		local Tr,Ang = self:PerformPlankTrace(Yaw)
		
		if (Tr.Hit) then
			local Ent = ents.Create("prop_physics")
			Ent:SetModel("models/props_debris/wood_board06a.mdl")
			Ent:Spawn()
			Ent:Activate()
			Ent:SetPos(Tr.HitPos)
			Ent:SetAngles(Ang)
			Ent:SetHealth(300)
			
			table.insert(self.Barricades,Ent)
			
			local Phys = Ent:GetPhysicsObject()
			Phys:Sleep()
			Phys:EnableMotion(false)
		end
	end
	
	net.Receive("RequestPlaceBarricade",function(bit,pl)
		pl:PlaceBarricade(net.ReadInt(16))
	end)
else
	local Plank
	local Yaw	= 0
	local CD	= CurTime()
	
	hook.Add("PlayerBindPress","BarricadeRotation",function(ply,bind,pressed)
		if (ply.IsPlacing) then
			if (bind == "invnext") then 
				if (Yaw >= 180) then Yaw = -180 end
				Yaw = Yaw+10
				return true
			end
			
			if (bind == "invprev") then 
				if (Yaw <= -180) then Yaw = 180 end
				Yaw = Yaw-10
				return true
			end
			
			if (bind:lower() == "+attack" and pressed) then
				if (CD < CurTime()) then
					net.Start("RequestPlaceBarricade")
						net.WriteInt(Yaw,16)
					net.SendToServer()
					
					CD = CurTime()+1
				else
					ply:ChatPrint("Calm down! You only just recently placed a barricade.")
				end
				
				return true
			end
		end
	end)

	hook.Add("PostDrawOpaqueRenderables","PlacingBarricades",function()
		local lp = LocalPlayer()
		
		if (!lp.IsPlacing) then return end
		if (lp.Zomb) then lp.IsPlacing = false return end
		
		if (!IsValid(Plank)) then Plank = ClientsideModel("models/props_debris/wood_board06a.mdl") Plank:SetNoDraw(true) end
		
		local Tr,Ang = lp:PerformPlankTrace(Yaw)
		
		Plank:SetPos(Tr.HitPos)
		Plank:SetAngles(Ang)
		
		if (!Tr.Hit) then render.SetColorModulation(5,0,0)
		else render.SetColorModulation(0,5,0) end
		
		render.SetBlend(0.8)
			Plank:DrawModel()
		render.SetBlend(1)
		
		render.SetColorModulation(1,1,1)
	end)
end
		
		
		
		
		
		
		
		