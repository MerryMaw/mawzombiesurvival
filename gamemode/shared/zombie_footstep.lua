

function GM:PlayerFootstep(pl,pos,foot,sound,vol,filter)
	if (!pl.Zomb) then return false end
	if (CLIENT) then return true end
	
	if (pl.Step) then pl.Step:Stop() end
	
	pl.Step = CreateSound(pl,table.Random(pl.Zomb.Sounds.Step))
	pl.Step:ChangeVolume(vol,0)
	pl.Step:Play()
	
	return true
end