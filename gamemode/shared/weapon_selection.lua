
if (SERVER) then
	--Are you serious? Do I really have to setup my own network function for weapon swaps IF i block CHudWeaponSelection?
	util.AddNetworkString("SelectWeapon")
	
	function NextWeapon(bForward,ply)
		local Wep 	= ply:GetActiveWeapon()
		local Weps 	= ply:GetWeapons()
		local Key 	= table.KeyFromValue( Weps, Wep )
		
		if (!IsValid(Wep)) then Key = 1 end
		
		if (bForward) then 
			local NewWep = Weps[Key+1] or Weps[1]
			if (IsValid(NewWep)) then ply:SelectWeapon(NewWep:GetClass()) end
		else
			local NewWep = Weps[Key-1] or Weps[#Weps]
			if (IsValid(NewWep)) then ply:SelectWeapon(NewWep:GetClass()) end
		end
	end
	
	function GM:PlayerSwitchWeapon(pl,oldWep,newWep)
		return false
	end
	
	net.Receive("SelectWeapon",function(bit,pl)
		if (util.tobool(net.ReadBit())) then NextWeapon(true,pl)
		else NextWeapon(false,pl) end
	end)
else
	local w,h = ScrW(),ScrH()
	local Sel = Color(0,0,40,255)

	hook.Add("HUDPaint","DrawZSWeaponSelection",function()
		local lp = LocalPlayer()
		
		local Weapons = lp:GetWeapons()
		local Select  = lp:GetActiveWeapon()
		
		for k,v in pairs(Weapons) do
			local Y = 60+k*50
			
			if (v == Select) then
				DrawTextShadow(v.PrintName or v:GetClass(),"MZS_Font36",100,Y+20,MAIN_YELLOWCOLOR,0,MAIN_BLACKCOLOR,2)
			else
				DrawTextShadow(v.PrintName or v:GetClass(),"MZS_Font26",100,Y+20,MAIN_WHITECOLOR,0,MAIN_BLACKCOLOR,2)
			end
		end
	end)
	
	local CD = CurTime()
	
	hook.Add("PlayerBindPress","SelectWeapon",function(pl,bind,pressed)
		if (!pl.Zomb and CD < CurTime()) then
			local B = bind:lower()
			CD = CurTime()+0.1
			
			if (B == "invnext") then
				net.Start("SelectWeapon")
					net.WriteBit(true)
				net.SendToServer()
				
				return true
			elseif (B == "invprev") then 
				net.Start("SelectWeapon")
					net.WriteBit(false)
				net.SendToServer()
				
				return true
			end
		end
	end)
end

