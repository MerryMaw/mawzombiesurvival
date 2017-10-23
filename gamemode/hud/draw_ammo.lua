local w,h = ScrW(),ScrH()

hook.Add("HUDPaint","DrawAmmo",function()
	local lp = LocalPlayer()
	
	local wep = lp:GetActiveWeapon()
	
	if (!IsValid(wep)) then return end

	local Ammo = lp:GetAmmoCount(wep:GetPrimaryAmmoType())
	local Clip = wep:Clip1()
	
	if (Clip > -1) then
		DrawTextShadow(Clip,"MZS_Font80",w-210,h-110,MAIN_WHITECOLOR,2,MAIN_BLACKCOLOR,2)
		DrawTextShadow(Ammo,"MZS_Font36",w-100,h-75,MAIN_WHITECOLOR,2,MAIN_BLACKCOLOR,2)
	end
end)
