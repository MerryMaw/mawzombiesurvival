
local Mat 		 = Material("sprites/light_ignorez")
local DrawSprite = render.DrawSprite
local clamp		 = math.Clamp
local Col		 = Color(0,0,0,255)
local Up		 = Vector(0,0,50)
local Menu		 = nil
local X,Y		 = ScrW()/2, ScrH()/2

hook.Add("PostDrawOpaqueRenderables","RenderZombieTracker",function()
	local lp = LocalPlayer()
	
	if (!lp.Zomb) then return end
	
	local pls = player.GetAll()
	
	cam.IgnoreZ(true)
	render.SetMaterial(Mat)
	render.SetColorModulation(0,10,0)
		for k,v in pairs(pls) do
			if (!v.Zomb) then
				Col.g = clamp(v:Health()*2.5,0,255)
				Col.r = clamp(255-v:Health()*2.5,0,255)
				
				DrawSprite(v:GetPos()+Up,32,32,Col)
			end
		end
	render.SetColorModulation(1,1,1)
	cam.IgnoreZ(false)
end)

function OpenZombieMenu()
	local lp = LocalPlayer()
	
	if (!lp.Zomb) then return end
	
	Menu = DermaMenu()
	Menu.Paint = function(s,w,h) DrawRect(0,0,w,h,MAIN_BLACKCOLOR) end
	
	for k,v in pairs(GetZombieData()) do
		local O = Menu:AddOption(v.Name, function() RequestChangeZombie(v.Name) end)
		O:SetColor(MAIN_WHITECOLOR)
		O:SetFont("MZS_Font36")
	end
		
	Menu:Open()
	Menu:SetPos(X,Y)
end
	
	