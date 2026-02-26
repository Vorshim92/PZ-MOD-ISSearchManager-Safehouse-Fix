local original_ISSearchManager_createIconsForWorldItems = ISSearchManager.createIconsForWorldItems
function ISSearchManager:createIconsForWorldItems(_square)
    if isClient() then
		if not SafeHouse.isSafehouseAllowLoot(_square, self.character) then
			return true;
		end;
	end;
    original_ISSearchManager_createIconsForWorldItems(self, _square)
end




