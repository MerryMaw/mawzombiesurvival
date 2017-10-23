
-- ZOMBIE DATA OF EACH THING YOU CAN BECOME
-- TODO: ADD MORE!
local Box 		= Vector(5,5,5)

local Zombies 	= {
	["Zombie"]			= {
		Name 	= "Zombie",
		Model 	= "models/Zombie/Classic.mdl",
		OffPos 	= Vector(0,0,70),
		CamDis 	= 130,
		RunSP	= 150,
		WalkSP	= 100,
		JumpP	= 200,
		HP		= 300,
		CD		= 1,
		Animations = {
			Idle	= {"Idle01",1},
			Walk 	= {"walk",1},
			Run 	= {"FireWalk",1},
			Jump 	= {"canal5aattack"},
			Attack 	= {"attackA","attackB","attackC","attackD","attackE","attackF",},
		},
		Sounds	= {
			Step = {
				"npc/zombie/foot1.wav",
				"npc/zombie/foot2.wav",
				"npc/zombie/foot3.wav",
			},
			Idle = {
				"npc/zombie/zombie_voice_idle1.wav",
				"npc/zombie/zombie_voice_idle2.wav",
				"npc/zombie/zombie_voice_idle3.wav",
				"npc/zombie/zombie_voice_idle4.wav",
			},
			Jump = {
				"npc/zombie/zombie_alert1.wav",
				"npc/zombie/zombie_alert2.wav",
				"npc/zombie/zombie_alert3.wav",
			},
			Attack = {
				"npc/zombie/claw_miss1.wav",
				"npc/zombie/claw_miss2.wav",
			},
		},
		AttackFunc = function(pl)
			local SP = pl:GetShootPos()
			local Ai = pl:GetAimVector()
			
			local Tr = util.TraceHull({
				start 	= SP,
				endpos 	= SP+Ai*120,
				maxs 	= Box,
				mins	= -Box,
				filter 	= player.GetAllZombies()
			})
				
			if (IsValid(Tr.Entity)) then
				Tr.Entity:TakeDamage(math.random(30,50),pl)
				pl:EmitSound("npc/zombie/claw_strike"..math.random(1,3)..".wav")
				
				local Phys = Tr.Entity:GetPhysicsObject()
				
				if (IsValid(Phys)) then
					Phys:ApplyForceCenter(Ai*50000)
				end
			end
		end
	},
	["Headcrab"] 		= {
		Name = "Headcrab",
		Model = "models/headcrabclassic.mdl",
		OffPos = Vector(0,0,40),
		CamDis = 100,
		RunSP	= 150,
		WalkSP	= 100,
		JumpP	= 300,
		HP		= 50,
		CD		= 1,
		Animations = {
			Idle	= {"Idle01",1},
			Walk 	= {"Run1",1},
			Run 	= {"Run1",1},
			Jump 	= {"jumpattack_broadcast"},
			Attack 	= {"jumpattack_broadcast"},
		},
		Sounds	= {
			Step = {
				"npc/headcrab_poison/ph_step1.wav",
				"npc/headcrab_poison/ph_step2.wav",
				"npc/headcrab_poison/ph_step3.wav",
				"npc/headcrab_poison/ph_step4.wav",
			},
			Idle = {
				"npc/headcrab/idle1.wav",
				"npc/headcrab/idle2.wav",
				"npc/headcrab/idle3.wav",
			},
			Jump = {
				"npc/headcrab/attack1.wav",
				"npc/headcrab/attack2.wav",
				"npc/headcrab/attack3.wav",
			},
			Attack = {
				"npc/headcrab/attack1.wav",
				"npc/headcrab/attack2.wav",
				"npc/headcrab/attack3.wav",
			},
		},
		Hull = {
			Mins = Vector(-14,-14,0),
			Maxs = Vector(14,14,24),
		},
		AttackFunc = function(pl)
			local Tr = util.TraceHull({
				start 	= pl:GetShootPos(),
				endpos 	= pl:GetShootPos()+pl:GetAimVector()*150,
				maxs 	= Box,
				mins	= -Box,
				filter 	= player.GetAllZombies()
			})
				
			if (IsValid(Tr.Entity)) then
				Tr.Entity:TakeDamage(math.random(20),pl)
				pl:EmitSound("npc/headcrab/headbite.wav")
			end
			
			pl:SetLocalVelocity((Vector(0,0,2)+pl:GetAimVector())*200)
		end
	},
	["Fast Headcrab"] 	= {
		Name  = "Fast Headcrab",
		Model = "models/headcrab.mdl",
		OffPos = Vector(0,0,40),
		CamDis = 100,
		RunSP	= 300,
		WalkSP	= 100,
		JumpP	= 300,
		HP		= 30,
		CD		= 1,
		Animations = {
			Idle	= {"Idle01",1},
			Walk 	= {"Run1",1},
			Run 	= {"Run1",1},
			Jump 	= {"attack"},
			Attack 	= {"attack"},
		},
		Sounds	= {
			Step = {
				"npc/headcrab_poison/ph_step1.wav",
				"npc/headcrab_poison/ph_step2.wav",
				"npc/headcrab_poison/ph_step3.wav",
				"npc/headcrab_poison/ph_step4.wav",
			},
			Idle = {
				"npc/headcrab/idle1.wav",
				"npc/headcrab/idle2.wav",
				"npc/headcrab/idle3.wav",
			},
			Jump = {
				"npc/headcrab/attack1.wav",
				"npc/headcrab/attack2.wav",
				"npc/headcrab/attack3.wav",
			},
			Attack = {
				"npc/headcrab/attack1.wav",
				"npc/headcrab/attack2.wav",
				"npc/headcrab/attack3.wav",
			},
		},
		Hull = {
			Mins = Vector(-14,-14,0),
			Maxs = Vector(14,14,24),
		},
		AttackFunc = function(pl)
			local Tr = util.TraceHull({
				start 	= pl:GetShootPos(),
				endpos 	= pl:GetShootPos()+pl:GetAimVector()*150,
				maxs 	= Box,
				mins	= -Box,
				filter 	= player.GetAllZombies()
			})
				
			if (IsValid(Tr.Entity)) then
				Tr.Entity:TakeDamage(math.random(15),pl)
				pl:EmitSound("npc/headcrab/headbite.wav")
			end
			
			pl:SetLocalVelocity((Vector(0,0,2)+pl:GetAimVector())*200)
		end
	},
	["Slow Headcrab"] 	= {
		Name  = "Slow Headcrab",
		Model = "models/headcrabblack.mdl",
		OffPos = Vector(0,0,40),
		CamDis = 100,
		RunSP	= 100,
		WalkSP	= 70,
		JumpP	= 300,
		HP		= 80,
		CD		= 1,
		Animations = {
			Idle	= {"Idle01",1},
			Walk 	= {"Run1",1},
			Run 	= {"Scurry",1},
			Jump 	= {"flinch1"},
			Attack 	= {"Tele_Attack_a","Tele_Attack_a_2","Tele_Attack_a_3"},
		},
		Sounds	= {
			Step = {
				"npc/headcrab_poison/ph_step1.wav",
				"npc/headcrab_poison/ph_step2.wav",
				"npc/headcrab_poison/ph_step3.wav",
				"npc/headcrab_poison/ph_step4.wav",
			},
			Idle = {
				"npc/headcrab_poison/ph_idle1.wav",
				"npc/headcrab_poison/ph_idle2.wav",
				"npc/headcrab_poison/ph_idle3.wav",
			},
			Jump = {
				"npc/headcrab_poison/ph_jump1.wav",
				"npc/headcrab_poison/ph_jump2.wav",
				"npc/headcrab_poison/ph_jump3.wav",
			},
			Attack = {
				"npc/headcrab/attack1.wav",
				"npc/headcrab/attack2.wav",
				"npc/headcrab/attack3.wav",
			},
		},
		Hull = {
			Mins = Vector(-14,-14,0),
			Maxs = Vector(14,14,24),
		},
		AttackFunc = function(pl)
			local Tr = util.TraceHull({
				start 	= pl:GetShootPos(),
				endpos 	= pl:GetShootPos()+pl:GetAimVector()*150,
				maxs 	= Box,
				mins	= -Box,
				filter 	= player.GetAllZombies()
			})
				
			if (IsValid(Tr.Entity)) then
				Tr.Entity:TakeDamage(math.random(30),pl)
				pl:EmitSound("npc/headcrab_poison/ph_poisonbite"..math.random(1,3)..".wav")
			end
			
			pl:SetLocalVelocity((Vector(0,0,2)+pl:GetAimVector())*200)
		end
	},
	["Fast Zombie"]		= {
		Name 	= "Fast Zombie",
		Model 	= "models/Zombie/Fast.mdl",
		OffPos 	= Vector(0,0,70),
		CamDis 	= 130,
		RunSP	= 400,
		WalkSP	= 100,
		JumpP	= 400,
		HP		= 140,
		CD		= 0.4,
		Animations = {
			Idle	= {"idle",1},
			Walk 	= {"walk_all",1},
			Run 	= {"Run",1},
			Jump 	= {"LeapStrike"},
			Attack 	= {"BR2_Attack",},
		},
		Sounds	= {
			Step = {
				"npc/fast_zombie/foot1.wav",
				"npc/fast_zombie/foot2.wav",
				"npc/fast_zombie/foot3.wav",
				"npc/fast_zombie/foot4.wav",
			},
			Idle = {
				"npc/fast_zombie/idle1.wav",
				"npc/fast_zombie/idle2.wav",
				"npc/fast_zombie/idle3.wav",
			},
			Jump = {
				"npc/fast_zombie/leap1.wav",
			},
			Attack = {
				"npc/fast_zombie/claw_miss1.wav",
				"npc/fast_zombie/claw_miss2.wav",
			},
		},
		AttackFunc = function(pl)
			local Tr = util.TraceHull({
				start 	= pl:GetShootPos(),
				endpos 	= pl:GetShootPos()+pl:GetAimVector()*120,
				maxs 	= Box,
				mins	= -Box,
				filter 	= player.GetAllZombies()
			})
				
			if (IsValid(Tr.Entity)) then
				Tr.Entity:TakeDamage(math.random(10),pl)
				pl:EmitSound("npc/zombie/claw_strike"..math.random(1,3)..".wav")
			end
		end
	},
	["Poison Zombie"]	= {
		Name 	= "Poison Zombie",
		Model 	= "models/Zombie/poison.mdl",
		OffPos 	= Vector(0,0,70),
		CamDis 	= 130,
		RunSP	= 100,
		WalkSP	= 60,
		JumpP	= 200,
		HP		= 560,
		CD		= 1.7,
		Animations = {
			Idle	= {"Idle01",1},
			Walk 	= {"Walk",1},
			Run 	= {"FireWalk",1},
			Jump 	= {"releasecrab"},
			Attack 	= {"melee_01"},
		},
		Sounds	= {
			Step = {
				"npc/zombie_poison/pz_left_foot1.wav",
				"npc/zombie_poison/pz_right_foot1.wav",
			},
			Idle = {
				"npc/zombie_poison/pz_idle2.wav",
				"npc/zombie_poison/pz_idle3.wav",
				"npc/zombie_poison/pz_idle4.wav",
			},
			Jump = {
				"npc/zombie_poison/pz_warn1.wav",
				"npc/zombie_poison/pz_warn2.wav",
			},
			Attack = {
				"npc/zombie/claw_miss1.wav",
				"npc/zombie/claw_miss2.wav",
			},
		},
		AttackFunc = function(pl)
			local SP = pl:GetShootPos()
			local Ai = pl:GetAimVector()
			
			local Tr = util.TraceHull({
				start 	= SP,
				endpos 	= SP+Ai*120,
				maxs 	= Box,
				mins	= -Box,
				filter 	= player.GetAllZombies()
			})
				
			util.BlastDamage(pl,pl,Tr.HitPos,50,math.random(20,30))
			
			if (IsValid(Tr.Entity)) then
				Tr.Entity:TakeDamage(math.random(30,40),pl)
				
				pl:EmitSound("npc/zombie/claw_strike"..math.random(1,3)..".wav")
				
				local Phys = Tr.Entity:GetPhysicsObject()
				
				if (IsValid(Phys)) then
					Phys:ApplyForceCenter(Ai*Phys:GetMass()*300)
				end
			end
		end
	},
}

function GetZombieData()
	return Zombies
end