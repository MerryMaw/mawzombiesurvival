function GM:OnSpawnMenuOpen()
	local lp = LocalPlayer()
	
	if (lp.Zomb) then OpenZombieMenu()
	else
		lp.IsPlacing = true
	end
end

function GM:OnSpawnMenuClose()
	local lp = LocalPlayer()
	
	lp.IsPlacing = false
end