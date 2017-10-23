

local meta = FindMetaTable("Player")
local Dat = {
	"id BIGINT NOT NULL PRIMARY KEY",
	"money BIGINT",
	"xp BIGINT",
	"level TINYINT",
}

hook.Add("Initialize","CreateSQLTable",function()
	local Dat = sql.Query("CREATE TABLE IF NOT EXISTS MZS_Accounts ("..table.concat(Dat,",")..");")
end)

hook.Add("PlayerAuthed","LoadAccount",function(pl)
	pl:LoadAccount()
end)

hook.Add("Tick","PlayerSave",function()
	for k,v in pairs(player.GetAll()) do
		if (v.SaveSQLTimer and v.SaveSQLTimer < CurTime()) then
			v:SaveAccount()
		end
	end
end)
		

function meta:LoadAccount()
	if (self:IsBot()) then return end
	
	local Data = sql.Query("SELECT * FROM MZS_Accounts WHERE id="..self:SteamID64())

	if (!Data) then
		sql.Query("INSERT INTO MZS_Accounts VALUES("..self:SteamID64()..",0,1,1);")
		print("Created account for "..self:Nick()..". User did not exist!")
	else
		local Acc = Data[1]
		self:SetupPlayerRank(Acc.xp,Acc.level)
	end
	
	self.SaveSQLTimer = CurTime()+math.random(20,50)
end

function meta:SaveAccount()
	local Data = {
		"xp="..self:GetXP(),
		"level="..self:GetLevel(),
		--"money="..self.money
	}
	
	sql.Query("UPDATE MZS_Accounts SET "..table.concat(Data,",").." WHERE id="..self:SteamID64())
	self.SaveSQLTimer = CurTime()+math.random(20,50)
end