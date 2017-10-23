local w,h = ScrW(),ScrH()

local FormattedTime = string.FormattedTime

function GM:HUDPaint()
	local lp = LocalPlayer()
	local HP = lp:Health()
	
	DrawTextShadow(HP,"MZS_Font80",80,h-110,MAIN_WHITECOLOR,0,MAIN_BLACKCOLOR,2)
	
	DrawTextShadow("Infected: "..#player.GetAllZombies(),"MZS_Font36",80,30,MAIN_GREENCOLOR,0,MAIN_BLACKCOLOR,2)
	DrawTextShadow("Kills: "..lp:Frags(),"MZS_Font36",w-150,30,MAIN_REDCOLOR,0,MAIN_BLACKCOLOR,2)
	
	--Time stuff
	if (GAMEMODE.WinData) then
		local Time = math.ceil(GAMEMODE.WinData.Time-CurTime())
		
		DrawTextShadow(GAMEMODE.WinData.Text,"MZS_Font110",w/2,170,GAMEMODE.WinData.Color,1,MAIN_BLACKCOLOR,2)
		DrawTextShadow("Next map in: "..FormattedTime( Time, "%02i:%02i"),"MZS_Font36",w/2,110,MAIN_WHITECOLOR,1,MAIN_BLACKCOLOR,2)
	else
		local Time = math.ceil(GetGameTime())
		
		DrawTextShadow(FormattedTime( 900-Time, "%02i:%02i"),"MZS_Font36",w/2,50,MAIN_WHITECOLOR,1,MAIN_BLACKCOLOR,2)
		
		if (Time < 90) then
			DrawTextShadow("Invasion begins in: "..FormattedTime( 90-Time, "%02i:%02i"),"MZS_Font36",w/2,80,MAIN_GREENCOLOR,1,MAIN_BLACKCOLOR,2)
		end
		
		--Not enough players
		if (!HasEnoughPlayers()) then
			DrawTextShadow("X","MZS_Font110",w/2,60,MAIN_REDCOLOR,1,MAIN_BLACKCOLOR,2)
			DrawTextShadow("You need at least 2 people to play this gamemode!","MZS_Font36",w/2,140,MAIN_REDCOLOR,1,MAIN_BLACKCOLOR,2)
		end
	end
	
	--Target ID
	local Tr = lp:GetEyeTrace()
	
	if (IsValid(Tr.Entity) and Tr.Entity:IsPlayer()) then
		DrawTextShadow(Tr.Entity:Nick(),"MZS_Font36",w/2,h/2,MAIN_WHITECOLOR,1,MAIN_BLACKCOLOR,2)
	end
	
	--Some Help stuff
	if (lp.Zomb) then
		DrawTextShadow("Press [Q] to change zombie","MZS_Font36",80,h-130,MAIN_WHITECOLOR,0,MAIN_BLACKCOLOR,2)
	else
		DrawTextShadow("Press [Q] to place barricades","MZS_Font36",80,h-160,MAIN_WHITECOLOR,0,MAIN_BLACKCOLOR,2)
		DrawTextShadow("Use [Mouse wheel] to rotate them","MZS_Font36",80,h-130,MAIN_WHITECOLOR,0,MAIN_BLACKCOLOR,2)
	end
	
	local XP,MXP = lp:GetXP(),lp:GetRequiredXP()
	local c 	 = XP/MXP
	
	DrawMZSRect(w/2-203,h-93,406,46,MAIN_BLACKCOLOR)
	DrawMZSRect(w/2-193,h-83,386*c,26,MAIN_GREENCOLOR)
	
	DrawMZSRect(w/2-203,h-130,406,26,MAIN_BLACKCOLOR,2)
	DrawText("Rank "..lp:GetLevel(),"MZS_Font36",w/2,h-120,MAIN_WHITECOLOR,1)
	DrawText("XP "..XP.."/"..MXP,"MZS_Font36",w/2,h-70,MAIN_WHITECOLOR,1)
end
