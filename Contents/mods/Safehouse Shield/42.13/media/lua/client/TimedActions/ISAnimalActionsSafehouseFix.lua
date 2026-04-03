--***********************************************************
--**                    VORSHIM                     **
--***********************************************************
if not isClient() then return end

require "TimedActions/Animals/ISPickupAnimal"
require "TimedActions/Animals/ISPetAnimal"

-- Layer 4: Block ISPickupAnimal at action start
local original_ISPickupAnimal_isValidStart = ISPickupAnimal.isValidStart
function ISPickupAnimal:isValidStart()
    if self.animal and self.animal:getSquare()
        and not SafeHouse.isSafehouseAllowLoot(self.animal:getSquare(), self.character) then
        return false
    end
    return original_ISPickupAnimal_isValidStart(self)
end

-- Layer 5: Block ISPetAnimal at action start
local original_ISPetAnimal_isValidStart = ISPetAnimal.isValidStart
function ISPetAnimal:isValidStart()
    if self.animal and self.animal:getSquare()
        and not SafeHouse.isSafehouseAllowLoot(self.animal:getSquare(), self.character) then
        return false
    end
    return original_ISPetAnimal_isValidStart(self)
end
