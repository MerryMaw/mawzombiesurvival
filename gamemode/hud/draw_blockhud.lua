function GM:HUDShouldDraw( name )
	if (name == "CHudHealth" or 
		name == "CHudBattery" or 
		name == "CHudCrosshair" or
		name == "CHudVoiceStatus" or
		name == "CHudWeaponSelection" or
		name == "CHudAmmo" or
		name == "CHudVoiceSelfStatus") then return false end
		
	return true
end