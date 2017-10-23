local Zero 	= Vector(0.1,0.1,0.1)
local clamp = math.Clamp

function GM:CalcView(pl, origin, angles, fov)
	if (!pl:Alive()) then return end
	
	if (!pl.Zomb) then
		local BoneID		  = pl:LookupBone("ValveBiped.Bip01_Head1")
		if (!BoneID) then return end
		
		local BonePos,BoneAng = pl:GetBonePosition(BoneID)
		
		pl:ManipulateBoneScale( pl:LookupBone("ValveBiped.Bip01_Head1"), Zero)
		
		return {
			origin = BonePos,
			angles = angles,
		}
	else
		local Tr = util.TraceLine({
			start = origin,
			endpos = origin-angles:Forward()*pl.Zomb.CamDis,
			filter = pl,
			mask = MASK_SOLID_BRUSHONLY,
		})
		
		return {
			origin = Tr.HitPos,
			angles = angles,
		}
	end
end