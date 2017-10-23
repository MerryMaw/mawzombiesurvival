local VoiceMat 	= surface.GetTextureID("voice/speaker4")
local VoiceMat2 = surface.GetTextureID("gui/gradient_up")
local VoiceEna 	= true

local insert = table.insert
local Remove = table.remove
local min	 = math.min

local x 	 = ScrW()-310

function GM:PlayerStartVoice( ply )
	ply.Rec = {}
	ply.Talking = true
	ply.LastTalkStart = CurTime()
end

function GM:PlayerEndVoice( ply )
	ply.Rec = {}
	ply.Talking = nil
end

local Time = CurTime()

hook.Add("Tick","RecVoice",function()	
	if (Time < CurTime()) then
		for k,v in pairs( player.GetAll() ) do
			if (v.Talking and v.LastTalkStart and v.LastTalkStart < CurTime()-0.1) then
				local V = min(1,v:VoiceVolume())
						
				insert(v.Rec,1,V)
				
				if (#v.Rec >= 25) then
					Remove(v.Rec,#v.Rec)
				end
			end
		end
		
		Time = CurTime()+0.02
	end
end)

hook.Add("HUDPaint","_VoiceChatDraw",function()
	local D = 0
	for k,v in pairs( player.GetAll() ) do
		if (v.Talking and v.LastTalkStart and v.LastTalkStart < CurTime()-0.1) then
			local H = 400 + 50*D
			D = D+1
			
			DrawRect( x, H, 300, 45, MAIN_BLACKCOLOR )
			
			for k,v in pairs(v.Rec) do
				DrawTexturedRect( x+150+(150/25)*(k-1), H+45-40*v, 4, 40*v, MAIN_GREENCOLOR,VoiceMat2 )
				DrawTexturedRect( x+150-(150/25)*k, H+45-40*v, 4, 40*v, MAIN_GREENCOLOR,VoiceMat2 )
			end
			
			DrawOutlinedRect( x, H, 300, 45, MAIN_TOTALBLACKCOLOR )
			
			DrawTexturedRect( x+270, H+14, 16, 16, MAIN_TEXTCOLOR, VoiceMat )
			DrawText( v:Nick(), "MZS_Font26", x+14, H+9, MAIN_TEXTCOLOR ) 
		end
	end
end)