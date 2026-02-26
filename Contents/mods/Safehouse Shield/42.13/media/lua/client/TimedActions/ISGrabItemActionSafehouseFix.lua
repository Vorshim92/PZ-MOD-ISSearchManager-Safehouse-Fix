--***********************************************************
--**                    VORSHIM                     **
--***********************************************************
if not isClient() then return end

require "TimedActions/ISGrabItemAction"

local original_ISGrabItemAction_isValid = ISGrabItemAction.isValid
function ISGrabItemAction:isValid()
	if self.item and self.item:getSquare()
		and not SafeHouse.isSafehouseAllowLoot(self.item:getSquare(), self.character) then
		return false
	end
	return original_ISGrabItemAction_isValid(self)
end