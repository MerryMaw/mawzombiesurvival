local Col	= Color(20,20,20,220)
local Col2	= Color(20,50,20,250)

local x,y 	= ScrW()/2,ScrH()/2
local w 	= 700

function GM:ScoreboardShow()
	self.ShowSB = true
end

function GM:ScoreboardHide()
	self.ShowSB = false
end

function GM:HUDDrawScoreBoard()
	if (!self.ShowSB) then return end
	
	local NPly 		= #player.GetAll()
	local PlyTableH = 20 * NPly
	local Tall 		= 100 + PlyTableH
	local X,Y 		= x - w/2, y - Tall/2
	local by 		= Y + 100
	
	DrawRect(X, by, w, PlyTableH, Col)
	
	DrawTextShadow(self.Name, "MZS_Font80", x, Y + 30, MAIN_TEXTCOLOR,1,MAIN_BLACKCOLOR,2)
	
	DrawText("Name", "MZS_Font22", X, Y+75, MAIN_TEXTCOLOR)
	DrawText("Kills", "MZS_Font22", X + w - 100, Y+75, MAIN_TEXTCOLOR)
	DrawText("Ping", "MZS_Font22", X + w - 30, Y+75, MAIN_TEXTCOLOR)
	DrawText("Class", "MZS_Font22", X + w - 200, Y+75, MAIN_TEXTCOLOR)
	DrawText("Rank", "MZS_Font22", x, Y+75, MAIN_TEXTCOLOR)
	
	for k,v in pairs( player.GetAll() ) do
		local Y2 = by + 20 * (k-1)-3
		
		DrawText(v:Nick(), "MZS_Font22", X + 2, Y2, MAIN_TEXTCOLOR)
		DrawText(v:Ping(), "MZS_Font22", X + w - 30, Y2, MAIN_TEXTCOLOR)
		DrawText(v:Frags(), "MZS_Font22", X + w - 100, Y2, MAIN_TEXTCOLOR)
		DrawText(v:GetLevel(), "MZS_Font22", x, Y2, MAIN_TEXTCOLOR)
		
		if (v.Zomb) then
			DrawText(v.Zomb.Name, "MZS_Font22", X + w - 200, Y2, MAIN_GREENCOLOR)
		end
			
	end
end

