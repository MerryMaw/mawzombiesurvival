hook.Add("CalcMainActivity","Animations",function(pl,vel)
	if (!pl.Zomb) then return end
	
	local Anim 		= pl:LookupSequence(pl.Zomb.Animations.Idle[1])
	local JumpAnim 	= CalcJumpAnimation( pl )
	
	if (!JumpAnim) then
		local Len = vel:Length2D()
		if (Len > pl:GetWalkSpeed()+10) then Anim = pl:LookupSequence(pl.Zomb.Animations.Run[1])
		elseif (Len > 0) then Anim = pl:LookupSequence(pl.Zomb.Animations.Walk[1]) end
	else
		Anim = JumpAnim
	end
	
	if (pl.NextAttack and pl.NextAttack > CurTime()) then
		if (!pl.NextAttackAnim) then pl.NextAttackAnim = pl:LookupSequence(table.Random(pl.Zomb.Animations.Attack)) end
		Anim = pl.NextAttackAnim
		pl:SetCycle(1-(pl.NextAttack-CurTime())/pl.Zomb.CD)
	elseif (pl.NextAttackAnim) then
		pl.NextAttackAnim = nil
	end
	
    return Anim,Anim
end)

function CalcJumpAnimation( pl )
	if (!pl:OnGround() and pl:WaterLevel() <= 0) then
		return pl:LookupSequence(pl.Zomb.Animations.Jump[1])
    end
 
    return false
end