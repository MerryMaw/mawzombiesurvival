
AddCSLuaFile()

ENT.Base 			= "base_nextbot"
ENT.Spawnable		= true
ENT.EnemyClass		= {
	"player",
}

local HasValue = table.HasValue

function ENT:Initialize()

	self:SetModel( "models/police.mdl" )
	
	self.LoseTargetDist	= 10000
	self.SearchRadius 	= 400
	
	self:SetHealth(10)
end

function ENT:SetEnemy( ent )
	self.Enemy = ent
end
function ENT:GetEnemy()
	return self.Enemy
end

function ENT:EnemyRange()
	if (IsValid(self.Enemy)) then return self:GetRangeTo( self.Enemy:GetPos() ) end
	return false
end

function ENT:HaveEnemy()
	local Dis = self:EnemyRange()
	if ( Dis ) then
		if ( Dis > self.LoseTargetDist ) then							return self:FindEnemy()
		elseif ( self.Enemy:IsPlayer() and !self.Enemy:Alive() ) then	return self:FindEnemy()	
		end	
		
		return true
	else
		return self:FindEnemy()
	end
end

function ENT:FindEnemy()
	local obs = ents.FindInSphere( self:GetPos(), self.SearchRadius )
	
	for k,v in pairs( obs ) do
		if (HasValue(self.EnemyClass,v:GetClass():lower())) then
			self.Enemy = v
			return true
		end
	end	
	
	self.Enemy = nil
	return false
end

function ENT:RunBehaviour()
	while ( true ) do
		if ( self:HaveEnemy() ) then
			self.loco:FaceTowards( self:GetEnemy():GetPos() )
			self:PlaySequenceAndWait( "point" )
			self:ResetSequence( self:LookupSequence("run_all") )
			self.loco:SetDesiredSpeed( 150 )	
			self.loco:SetAcceleration( 400 )		
			self:ChaseEnemy() 				
			self.loco:SetAcceleration( 200 )			
			self:ResetSequence( self:LookupSequence("busyidle1") )	
		else
			self:StartActivity( ACT_WALK )		
			self.loco:SetDesiredSpeed( 60 )	
			self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 200 )
			self:StartActivity( ACT_IDLE )
		end
		
		coroutine.wait( 2 )
		
	end
end	

function ENT:ChaseEnemy( options )

	local options = options or {}

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, self:GetEnemy():GetPos() )

	if (  !path:IsValid() ) then return "failed" end

	while ( path:IsValid() and self:HaveEnemy() ) do
	
		if ( path:GetAge() > 0.1 ) then				
			path:Compute( self, self:GetEnemy():GetPos() )
		end
		
		path:Update( self )								-- This function moves the bot along the path
		
		if ( options.draw ) then path:Draw() end
		-- If we're stuck, ) then call the HandleStuck function and abandon
		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end

		coroutine.yield()

	end

	return "ok"
end
