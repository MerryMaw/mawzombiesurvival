local ZSpawns = {}
local SSpawns = {}

function GM:EntityKeyValue( ent, key, val )
	local C = ent:GetClass():lower()
	if (C == "gmod_player_start") then
		if (key == "spawnflags") then
			if (val == "4") then
				table.insert(ZSpawns,ent)
			else
				table.insert(SSpawns,ent)
			end
		end
	end
end

hook.Add("InitPostEntity","Loaded",function()
	print("ZSpawns: "..#ZSpawns.." | SSpawns: "..#SSpawns)
end)

function GM:PlayerSelectSpawn( pl )
	local spawns = SSpawns
	
	if (pl.Zomb) then spawns = ZSpawns end
	
	if (#spawns < 1) then spawns = ents.FindByClass( "gmod_player_*" ) end
	if (#spawns < 1) then spawns = ents.FindByClass( "info_player_*" ) end
	
    return spawns[ math.random( #spawns ) ]
end
