
SWEP.Author					= "The Maw"
SWEP.Contact				= "cjbremer@gmail.com"
SWEP.PrintName				= "BASE"
SWEP.Purpose				= ""
SWEP.Instructions			= ""
SWEP.HoldType				= "ar2"

SWEP.Slot					= 3
SWEP.ViewModelFOV			= 82
SWEP.ViewModelFlip			= true
SWEP.ViewModel				= "models/weapons/v_smg_p90.mdl"
SWEP.WorldModel				= "models/weapons/w_smg_p90.mdl"

SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false

SWEP.Primary.Sound			= "Weapon.Fire_P90"
SWEP.Primary.Recoil			= 0.6
SWEP.Primary.Damage			= 17
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.017
SWEP.Primary.Delay 			= 0.05

SWEP.Primary.ClipSize		= 50	
SWEP.Primary.DefaultClip	= 50	
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"

SWEP.Secondary.ClipSize		= -1	
SWEP.Secondary.DefaultClip	= -1	
SWEP.Secondary.Automatic	= false			
SWEP.Secondary.Ammo			= "none"

SWEP.CSMuzzleFlashes 		= true

SWEP.ReloadCD				= CurTime()

SWEP.RenderGroup = RENDERGROUP_TRANSLUCENT

local Beam 	= Material("trails/laser")
local Flare = Material("particles/fire_glow")
local One	= Vector(1,1,0)

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Precache() 
	util.PrecacheSound("weapons/clipempty_pistol.wav") 
end

function SWEP:PrimaryAttack()
	if (!self:CanPrimaryAttack()) then return end
	
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:MuzzleFlash()

	self.ReloadCD = CurTime() + self.Primary.Delay + 0.05
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

	if (SERVER) then self.Owner:EmitSound(self.Primary.Sound) end

	self:TakePrimaryAmmo(1)
	
	self.Owner:LagCompensation(true)
		self:ShootBullet(self.Primary.Damage,self.Primary.Recoil)
	self.Owner:LagCompensation(false)
end

local IRONSIGHT_TIME = 0.25

function SWEP:SecondaryAttack()
	if (self.ReloadCD > CurTime() or !self.Zoom) then return end
	if (CLIENT) then return end
	
	self.Iron = !self.Iron
	
	if ( self.Iron ) then self.Owner:SetFOV(self.Zoom or 60,IRONSIGHT_TIME)
	else self.Owner:SetFOV(0,IRONSIGHT_TIME) end
	
	self.ReloadCD = CurTime()+IRONSIGHT_TIME+0.05
end

function SWEP:Reload()
	if (self.ReloadCD > CurTime()) then return end 
	if (self.Weapon:Clip1() >= self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0) then return end
	
	if (self.Iron) then 
		self.Owner:SetFOV(0,IRONSIGHT_TIME)
		self.Iron = false
	end
	
	self.Weapon:DefaultReload(ACT_VM_RELOAD)
	self.ReloadCD = CurTime()+self.Owner:GetViewModel():SequenceDuration()
end

function SWEP:Deploy()
	self.Iron = false
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	return true
end

function SWEP:ShootBullet(damage, recoil)
	local Vel  	  = self.Owner:GetVelocity():Length()+10
	local RecP    = math.Rand(-self.Primary.Recoil,self.Primary.Recoil)*Vel/200
	local RecY    = math.Rand(-self.Primary.Recoil,self.Primary.Recoil)*Vel/200
	local Aim	  = self.Owner:GetAimVector()
	
	Aim:Rotate(Angle(RecP,RecY,0))
	
	local attachmentIndex = self.Owner:LookupAttachment("anim_attachment_rh")
	local Attch 	= self.Owner:GetAttachment(attachmentIndex)
	
	local bullet = {
		Num 		= self.BulletBurst or 1,
		Src 		= Attch.Pos,
		Dir 		= Aim,
		Tracer		= 1,
		TracerName 	= "Tracer",
		Force		= damage * 0.5,
        Damage 		= damage,
		Callback	= function(attacker, tr, dmginfo) util.Decal("FadingScorch", tr.HitPos + tr.HitNormal, tr.HitPos+tr.HitNormal) end,
	}
	
	if (self.BulletSpread) then bullet.Spread = One*self.BulletSpread end

	self.Owner:FireBullets(bullet)
	
	if (CLIENT or game.SinglePlayer()) then
		local eyeangle 	= self.Owner:EyeAngles()
		eyeangle.pitch 	= eyeangle.pitch - recoil
		self.Owner:SetEyeAngles(eyeangle)
	else
		self.Owner:ViewPunch( Angle( math.Rand(-0.4,0.4) * self.Primary.Recoil, math.Rand(-0.4,0.4) *self.Primary.Recoil, 0 ) )
	end
end

function SWEP:CanPrimaryAttack()
	if (self.ReloadCD > CurTime()) then return false end
	if (!IsValid(self.Owner)) then return end
	if (self.Weapon:Clip1() <= 0 or self.Owner:WaterLevel() > 2) then
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
		self.Weapon:EmitSound("Default.ClipEmpty_Pistol")
		return false
	end
	
	return true
end

function SWEP:DrawWorldModelTranslucent(a,b,c)
	self:DrawModel()
	
	if (self.LaserBeam) then
		local attachmentIndex = self.Owner:LookupAttachment("anim_attachment_rh")
		
		local Attch 	= self.Owner:GetAttachment(attachmentIndex)
		
		if (Attch) then
			local Pos = Attch.Pos + Attch.Ang:Forward()*10 + Attch.Ang:Up()*5
			local Aim = self.Owner:GetAimVector()
			
			local Tr = util.TraceLine({
				start = Attch.Pos,
				endpos = Attch.Pos+Aim*90000,
				filter = self.Owner,
			})
			
			self:SetRenderBounds(Pos,Tr.HitPos)
			
			render.SetMaterial(Beam)
			render.StartBeam(2)
				render.AddBeam(Pos,2,0,MAIN_NOCOLOR)
				render.AddBeam(Tr.HitPos,2,1,MAIN_REDCOLOR)
			render.EndBeam()
			
			render.SetMaterial(Flare)
			render.DrawSprite(Tr.HitPos,4,4,MAIN_REDCOLOR)
		end
	end
end