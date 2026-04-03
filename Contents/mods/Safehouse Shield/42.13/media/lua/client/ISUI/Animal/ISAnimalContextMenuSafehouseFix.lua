--***********************************************************
--**                    VORSHIM                     **
--***********************************************************
if not isClient() then return end

require "ISUI/Animal/ISAnimalContextMenu"

-- Layer 1: Block animal context menu in protected safehouses
local original_doMenu = AnimalContextMenu.doMenu
AnimalContextMenu.doMenu = function(player, context, animal, test)
    local playerObj = getSpecificPlayer(player)
    local square = animal:getCurrentSquare()
    if square and not SafeHouse.isSafehouseAllowLoot(square, playerObj) then
        return
    end
    return original_doMenu(player, context, animal, test)
end

-- Layer 2: Block pickup action (safety net)
local original_onPickupAnimal = AnimalContextMenu.onPickupAnimal
AnimalContextMenu.onPickupAnimal = function(animal, chr)
    local square = animal:getSquare()
    if square and not SafeHouse.isSafehouseAllowLoot(square, chr) then
        return
    end
    return original_onPickupAnimal(animal, chr)
end

-- Layer 3: Block pet action (safety net)
local original_onPetAnimal = AnimalContextMenu.onPetAnimal
AnimalContextMenu.onPetAnimal = function(animal, chr)
    local square = animal:getCurrentSquare()
    if square and not SafeHouse.isSafehouseAllowLoot(square, chr) then
        return
    end
    return original_onPetAnimal(animal, chr)
end
