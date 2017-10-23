//Doors are only an exploitable and cheap way towards victory!

function GM:InitPostEntity()
	for k,v in pairs(ents.FindByClass("prop_door_rotating")) do
		v:Remove()
	end
end