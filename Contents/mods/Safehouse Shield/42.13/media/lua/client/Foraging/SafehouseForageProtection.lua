--[[
    SafehouseForageProtection.lua

    Prevents players from picking up world item icons (items dropped on the ground)
    inside other players' safehouses via the foraging search mode system.

    The vanilla code only checks the PLAYER's square in checkShouldDisable(),
    but icons are created/visible for squares within a radius around the player.
    This allows exploiting items near safehouse doors/edges.

    Three layers of defense:
    1. Prevent icon creation on protected safehouse squares
    2. Block the pickup action (double-click and context menu)
    3. Block context menu generation for icons on safehouse squares
]]

if not isClient() then return end

require "Foraging/ISSearchManager"
require "Foraging/ISWorldItemIcon"
require "Foraging/ISWorldItemIconTrack"
require "Foraging/ISBaseIcon"


-- LAYER 1: Prevent icon creation on protected safehouse squares.
-- createIconsForWorldItems is called from createIconsForCell(), which scans
-- a radius around the player. Squares inside safehouses the player doesn't
-- have access to should be skipped entirely.

local original_createIconsForWorldItems = ISSearchManager.createIconsForWorldItems

function ISSearchManager:createIconsForWorldItems(_square)
    if not SafeHouse.isSafehouseAllowLoot(_square, self.character) then
        return
    end
    return original_createIconsForWorldItems(self, _square)
end


-- LAYER 2a: Block the actual pickup action on ISWorldItemIcon.
-- doPickup is triggered by both double-click and context menu selection.
-- Catches edge cases where an icon already exists (e.g. icons loaded before
-- server toggled SafehouseAllowLoot off, or player removed from safehouse).

local original_ISWorldItemIcon_doPickup = ISWorldItemIcon.doPickup

function ISWorldItemIcon:doPickup(_x, _y, _contextOption, _targetContainer, _items)
    self:getGridSquare()
    if self.square and not SafeHouse.isSafehouseAllowLoot(self.square, self.character) then
        if _contextOption then _contextOption:hideAndChildren() end
        return
    end
    return original_ISWorldItemIcon_doPickup(self, _x, _y, _contextOption, _targetContainer, _items)
end


-- LAYER 2b: Same for ISWorldItemIconTrack (animal tracks on dropped items).

local original_ISWorldItemIconTrack_doPickup = ISWorldItemIconTrack.doPickup

function ISWorldItemIconTrack:doPickup(_x, _y, _contextOption, _targetContainer, _items)
    self:getGridSquare()
    if self.square and not SafeHouse.isSafehouseAllowLoot(self.square, self.character) then
        if _contextOption then _contextOption:hideAndChildren() end
        return
    end
    return original_ISWorldItemIconTrack_doPickup(self, _x, _y, _contextOption, _targetContainer, _items)
end


-- LAYER 3: Block context menu generation for icons on safehouse squares.
-- Prevents the "Pickup" option from appearing even if the icon somehow exists.

local original_ISBaseIcon_doContextMenu = ISBaseIcon.doContextMenu

function ISBaseIcon:doContextMenu(_context)
    self:getGridSquare()
    if self.square and not SafeHouse.isSafehouseAllowLoot(self.square, self.character) then
        return false
    end
    return original_ISBaseIcon_doContextMenu(self, _context)
end
