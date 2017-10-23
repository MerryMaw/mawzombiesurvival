DeriveGamemode("gearfox")

AddLuaSHFolder("shared")

AddLuaCSFolder("hud")
AddLuaCSFolder("client")

AddLuaSVFolder("server")


GM.Name 			= "Maw's Zombie Survival"
GM.Author 			= "The Maw"
GM.Email 			= "cjbremer@gmail.com"
GM.Website 			= "www.devinity2.com"

function GM:PlayerHurt( Vict, Att, HPLeft, Dmg )
    if (Vict.Zomb and Att.Zomb) then return false end
	if (!Vict.Zomb and !Att.Zomb) then return false end
end