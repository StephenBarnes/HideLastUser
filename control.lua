
-- Whenever selected entity changes, we set both the last-selected and new-selected entities to last_user = nil.
-- Note this isn't enough, eg if you rotate the selected entity, it will update last_user without calling this hook.
script.on_event(defines.events.on_selected_entity_changed, function(event)
	local lastSelected = event.last_entity
	if lastSelected ~= nil and lastSelected.valid then
		lastSelected.last_user = nil
	end
	local newSelected = game.players[event.player_index].selected
	if newSelected ~= nil and newSelected.valid then
		newSelected.last_user = nil
	end
end)

-- Every tick, we set last_user to nil for each player's selected entity.
script.on_event(defines.events.on_tick, function(event)
	for _, player in pairs(game.players) do
		if player ~= nil and player.valid then
			local selected = player.selected
			if selected ~= nil and selected.valid then
				selected.last_user = nil
			end
		end
	end
end)

-- This event doesn't seem to get called when player looks at tooltip, so I can't use it.
--[[script.on_event(defines.events.on_string_translated, function(e)
	...
end)]]

-- When the game starts, scrub last_user from all entities.
local function scrubAllEntities()
	for _, surface in pairs(game.surfaces) do
		for _, entity in pairs(surface.find_entities_filtered({})) do
			entity.last_user = nil
		end
	end
end
script.on_init(scrubAllEntities)
script.on_configuration_changed(scrubAllEntities)