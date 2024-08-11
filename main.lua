-- One Shot Protection v1.0.7
-- Klehrik

log.info("Successfully loaded ".._ENV["!guid"]..".")
mods.on_all_mods_loaded(function() for k, v in pairs(mods) do if type(v) == "table" and v.hfuncs then Helper = v end end end)

local player = nil
local stored_health = 0
local osp_window = 0

-- Parameters (in frames)
local osp_window_max    = 30
local iframes           = 45


-- ========== ImGui ==========

local one_shot_protection = true
gui.add_to_menu_bar(function()
    local new_value, clicked = ImGui.Checkbox("Enable One Shot Protection",one_shot_protection)
    if clicked then
        one_shot_protection = new_value
    end
end)


-- ========== Main ==========

gm.pre_script_hook(gm.constants.__input_system_tick, function()

    -- Check if player exists
    if Helper.instance_exists(player) then
        local ninety = player.maxhp * 0.9

        -- Set maximum "OSP window" when over 90% health
        if player.hp > ninety then
            osp_window = osp_window_max
            stored_health = player.hp

        else osp_window = math.max(osp_window - 1, 0)
        end

    else player = Helper.get_client_player()
    end
end)


gm.pre_script_hook(gm.constants.actor_on_damage_raw, function(self, other, result, args)
    if one_shot_protection == false then
        return
    end

    if self == player then
        local ninety = self.maxhp * 0.9

        -- Any damage dealt during the "OSP window" cannot be fatal
        local minimum = stored_health - ninety
        if self.hp < minimum and osp_window > 0 then
            self.hp = minimum
            osp_window = 0

            -- Give immunity frames
            -- (Don't override existing immunity if it has more frames)
            self.invincible = math.max(self.invincible, iframes)
        end
    end
end)
