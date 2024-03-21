-- One Shot Protection v1.0.4
-- Klehrik

log.info("Successfully loaded ".._ENV["!guid"]..".")
Helper = require("./helper")

local player = nil
local stored_health = 0
local osp_window = 0

-- Parameters (in frames)
local osp_window_max    = 30
local iframes           = 45



-- ========== Main ==========

gm.pre_script_hook(gm.constants.__input_system_tick, function()

    -- Check if player exists
    if Helper.does_instance_exist(player) then
        local ninety = player.maxhp * 0.9

        -- Set maximum "OSP window" when over 90% health
        if player.hp > ninety then
            osp_window = osp_window_max
            stored_health = player.hp

        -- Any damage dealt during the "OSP window" cannot be fatal
        else
            local minimum = stored_health - ninety
            if player.hp < minimum and osp_window > 0 then
                player.hp = minimum
                player.dead = false
                osp_window = 0

                -- Give immunity frames
                -- (Don't override existing immunity if it has more frames)
                player.invincible = math.max(player.invincible, iframes)
            end

            osp_window = math.max(osp_window - 1, 0)
        end

    else player = Helper.get_client_player()
    end
end)