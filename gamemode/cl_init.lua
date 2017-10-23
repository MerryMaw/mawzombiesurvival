
include("shared.lua")

hook.Remove("PlayerBindPress","CameraScroll")
hook.Remove("CalcView","View")

function GM:Initialize()
	self:SetEnableMawNameTag(false)
	self:SetEnableMawCircle(false)
	self:EnableMOTD(false)
	self:SetEnableThirdPerson(false)
	self:SetEnableMawChat(false)
end

function GM:ShouldDrawLocalPlayer() 
	return true --util.tobool(LocalPlayer().Zomb) 
end