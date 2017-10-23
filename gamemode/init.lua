AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

--Prevents people from reconnecting to become humans!
ZombifiedPlayers = {} 

local PistolLoad = {
	"weapon_glock18",
	"weapon_fiveseven",
	"weapon_deagle",
}

local AssaultLoad = {
	"weapon_ak47",
	"weapon_ump45",
	"weapon_p90",
	"weapon_mp5",
	"weapon_m4a1",
	"weapon_famas",
	"weapon_galil",
}

local SniperLoad = {
	"weapon_scout",
	"weapon_awp",
}

local Zero = Vector(0,0,0)

function GM:Initialize()
	resource.AddFile("resource/fonts/akbar.ttf")
	
	resource.AddDir("materials/mawzombiesurvival")
	resource.AddDir("sound/mawzombiesurvival")
end

function GM:PlayerSpawn(pl)
	pl:ResetHull()
	pl:DrawViewModel(false)
	
	local Zomb = ZombifiedPlayers[pl:SteamID64()]
	if (Zomb) then
		if (pl.NextZombie) then
			pl:ZombifyPlayer(pl.NextZombie)
			pl.NextZombie = nil
		else
			pl:ZombifyPlayer(Zomb)
		end
	elseif (GetGameTime() < 90) then
		pl:Give("weapon_fists")
		
		pl:Give(table.Random(PistolLoad))
		pl:GiveAmmo(64,"Pistol")
		
		if (math.random(1,7)<=2) then
			pl:Give("weapon_medkit")
			pl:Give("weapon_xm1014")
			pl:GiveAmmo(100,"Buckshot")
			
			pl:ChatPrint("You have become a medic in this round!")
		elseif (math.random(1,7)==1) then
			pl:Give(table.Random(SniperLoad))
			pl:GiveAmmo(90,"XBowBolt")
			
			pl:ChatPrint("You're a sniper in this round!")
		else
			pl:Give(table.Random(AssaultLoad))
			pl:GiveAmmo(220,"SMG1")
			
			pl:ChatPrint("You're just a regular survivor in this round!")
		end
		
		local M = "male_0"..math.random(1,9)
		pl:SetModel("models/player/group01/"..M..".mdl")
		pl:SetPlayerColor(Zero)
		
		pl:InitializeHands(M)
		
		pl:SetWalkSpeed(100)
		pl:SetRunSpeed(150)
	else
		pl:ZombifyPlayer("Zombie")
	end
end

-- Zombify on player death and set spawntime
function GM:DoPlayerDeath(pl)
	pl:CreateRagdoll()
	pl.RespawnCD = CurTime()+10
	
	if (!pl.Zomb and HasEnoughPlayers()) then
		pl:ZombifyPlayer("Zombie")
		ZombifiedPlayers[pl:SteamID64()] = "Zombie"
	end
end

-- prevents gibs from spawning from broken props!
function GM:PropBreak( att, prop )
	prop:Remove()
end

-- No team kills! :D
function GM:EntityTakeDamage( ent, dmginfo )
    if (ent:IsPlayer()) then
		local att = dmginfo:GetAttacker()
		
		if (IsValid(att) and att:IsPlayer()) then
			if (att.Zomb and ent.Zomb) then dmginfo:SetDamage(0) 
			elseif (!att.Zomb and !ent.Zomb) then dmginfo:SetDamage(0) end
		end
    end
 
    return dmginfo
end

-- 3D Voice Chat
function GM:PlayerCanHearPlayersVoice()
	return true
end 

-- Flashlight: DISABLE FOR INTENSIFIED LOLS!
function GM:PlayerSwitchFlashlight( pl, bool )
	return false
end

-- Deathsound
function GM:PlayerDeathSound(pl)
	return true
end