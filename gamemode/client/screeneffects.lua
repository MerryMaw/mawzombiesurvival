local w,h = ScrW(),ScrH()
local Grain = Material("mawzombiesurvival/pp/filmgrain")
local tab 	= {
 [ "$pp_colour_addr" ] = 0,
 [ "$pp_colour_addg" ] = 0.1,
 [ "$pp_colour_addb" ] = 0,
 [ "$pp_colour_brightness" ] = 0,
 [ "$pp_colour_contrast" ] = 1,
 [ "$pp_colour_colour" ] = 1,
 [ "$pp_colour_mulr" ] = 0,
 [ "$pp_colour_mulg" ] = 1,
 [ "$pp_colour_mulb" ] = 0
}

function GM:RenderScreenspaceEffects()

	surface.SetMaterial(Grain)
	surface.SetDrawColor(Color(0,0,0,100))
	surface.DrawTexturedRect(0,0,w,h)
	
	if (LocalPlayer().Zomb) then DrawColorModify( tab ) end
end