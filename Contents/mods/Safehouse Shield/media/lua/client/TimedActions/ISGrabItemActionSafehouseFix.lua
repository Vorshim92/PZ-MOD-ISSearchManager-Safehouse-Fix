--***********************************************************
--**                    VORSHIM                     **
--***********************************************************

local original ISGrabItemAction_isValid = ISGrabItemAction.isValid
function ISGrabItemAction:isValid()
	if isClient() and SafeHouse.isSafeHouse(self.item:getSquare(), getPlayer():getUsername(), true) then
		if not getServerOptions():getBoolean("SafehouseAllowLoot") then
			return false
		end
	end
	return original_ISGrabItemAction_isValid(self)
end