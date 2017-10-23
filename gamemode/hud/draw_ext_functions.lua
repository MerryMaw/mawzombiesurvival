
local Rect = Material("color")

local random  = math.random

function DrawMZSRect(x,y,w,h,col,seed)
	seed = seed or 1
	
	math.randomseed(seed)
	
	local Dat = {
		{
			x = x+random(0,w/16),
			y = y+random(0,h/16),
		},
		{
			x = x+w-random(0,w/16),
			y = y+random(0,h/16),
		},
		{
			x = x+w-random(0,w/16),
			y = y+h-random(0,h/16),
		},
		{
			x = x+random(0,w/16),
			y = y+h-random(0,h/16),
		}
	}
	
	surface.SetDrawColor(col.r,col.g,col.b,col.a)
	surface.SetMaterial(Rect)
	surface.DrawPoly(Dat)
end
	