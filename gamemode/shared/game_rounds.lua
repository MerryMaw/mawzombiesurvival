local GameTime 		= CurTime()
local GameOver 		= false

local InvasionTime 	= 90
local SurviveTime  	= 900

if (SERVER) then
	util.AddNetworkString("Gameover")
	util.AddNetworkString("GameTime")
	
	hook.Add("Tick","ZSTime",function()
		if (!GameOver) then
			if (!HasEnoughPlayers()) then 
				GameTime = CurTime()
				ZombifiedPlayers = {} 
				
				for k,v in pairs(player.GetAllZombies()) do
					if (v:Alive()) then 
						v.Zomb = nil
						v:KillSilent() 
					end
				end
				
				return 
			end
		
			local plz = player.GetAllZombies()
			local pla = player.GetAllAlive()
			local pls = player.GetAll()
		
			if (#pla < 1) then Gameover(false)
			elseif (GetGameTime() > SurviveTime) then Gameover(true)
			elseif (#plz < 1 and GetGameTime() > InvasionTime) then
				table.Random(player.GetAllAlive()):ZombifyPlayer("Zombie")
			end
		end
	end)
	
	hook.Add("PlayerAuthed","SyncGametime",function(pl)
		timer.Simple(1,function()
			net.Start("GameTime")
				net.WriteUInt(math.ceil(GameTime),32)
			net.Send(pl)
		end)
	end)
	
	function Gameover(bool)
		net.Start("Gameover") 
			net.WriteBit(bool)
		net.Broadcast()
		
		GameOver = true
		
		timer.Simple(30,function() game.LoadNextMap() end)
	end
else
	local Music
	local TogMus = 0
	
	hook.Add("Tick","ZSTime",function()
		if (!HasEnoughPlayers() and !GameOver) then 
			GameTime = CurTime()
			
			for k,v in pairs(player.GetAllZombies()) do
				if (v:Alive()) then 
					v.Zomb = nil
				end
			end
		end
		
		local lp = LocalPlayer()
		
		if (lp:IsValid()) then
			if (GameOver) then
				if (TogMus != 1) then
					if (Music) then Music:Stop() end
					Music = CreateSound(lp,"mawzombiesurvival/music/over1.mp3")
					Music:Play()
					Music:ChangeVolume(0.4,0)
					
					TogMus = 1
				end
			elseif (GetGameTime() > InvasionTime) then
				if (TogMus != 2) then
					if (Music) then Music:Stop() end
					Music = CreateSound(lp,"mawzombiesurvival/music/battle1.mp3")
					Music:Play()
					Music:ChangeVolume(0.4,0)
					
					TogMus = 2
				end
			else
				if (TogMus != 3) then
					if (Music) then Music:Stop() end
					Music = CreateSound(lp,"mawzombiesurvival/music/prologue.mp3")
					Music:Play()
					Music:ChangeVolume(0.4,0)
					
					TogMus = 3
				end
			end
		end
	end)
	
	net.Receive("Gameover",function()
		local Won = net.ReadBit()
		
		if (Won == 1) then 
			GAMEMODE.WinData = {
				Text = "Humans have won!",
				Color = Color(0,100,255),
				Time = CurTime()+30,
			}
		else
			GAMEMODE.WinData = {
				Text = "Zombies have won!",
				Color = Color(0,250,0),
				Time = CurTime()+30,
			}
		end
		
		GameOver = true
	end)
	
	net.Receive("GameTime",function() GameTime = net.ReadUInt(32) end)
end


function GetGameTime()
	return CurTime()-GameTime
end

function HasEnoughPlayers()
	return (#player.GetAll() > 1)
end