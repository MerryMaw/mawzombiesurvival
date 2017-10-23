
_PlayerHat = ClientsideModel("models/props_junk/TrafficCone001a.mdl")
_PlayerHat:SetNoDraw(true)
 
local Hats = {
	{
		Name = "Cone",
		Model = "models/props_junk/TrafficCone001a.mdl",
		OffPos = Vector(15,3,0),
		OffAng = Angle(-90,20,0),
		Scale = 0.6,
	},
	{
		Name = "Graduate",
		Model = "models/player/items/humans/graduation_cap.mdl",
		OffPos = Vector(-0.5,-2.1,0),
		OffAng = Angle(0,120,90),
		Scale = 1,
	},
	{
		Name = "Top Hat",
		Model = "models/player/items/humans/top_hat.mdl",
		OffPos = Vector(-0.5,-2.1,0),
		OffAng = Angle(0,120,90),
		Scale = 1,
	}
}
		
 
hook.Add("PostPlayerDraw", "MZSHats", function( ply )
	if (ply.Zomb) then return end
	local Lv = ply:GetLevel()-1
	
	if (Lv > #Hats) then Lv = #Hats end
	
	local Ab = Hats[Lv]
	
	if (!Ab) then return end
	
	local Bone 				= ply:LookupBone("ValveBiped.Bip01_Head1")
	
	if (!Bone) then return end
	
	local BonePos , BoneAng = ply:GetBonePosition( Bone )
	
	local OffsetPos,OffsetAng = Ab.OffPos*1,Ab.OffAng
	OffsetPos:Rotate(BoneAng)
	
	local OldAng = BoneAng*1
	BoneAng:RotateAroundAxis(OldAng:Forward(),OffsetAng.r)
	BoneAng:RotateAroundAxis(OldAng:Right(),OffsetAng.p)
	BoneAng:RotateAroundAxis(OldAng:Up(),OffsetAng.y)
 
	_PlayerHat:SetModel(Ab.Model)
	_PlayerHat:SetModelScale(Ab.Scale, 0)
	_PlayerHat:SetRenderOrigin( BonePos + OffsetPos )
	_PlayerHat:SetRenderAngles( BoneAng )
	_PlayerHat:SetupBones()
 	_PlayerHat:DrawModel()
end)