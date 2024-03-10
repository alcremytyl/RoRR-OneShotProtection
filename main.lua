-- One Shot Protection v1.0.2
-- Klehrik

log.info("Successfully loaded ".._ENV["!guid"]..".")
require("./helper")

stored_health = -1



-- ========== Main ==========

gm.pre_script_hook(gm.constants.__input_system_tick, function()
    -- Using pref_name to identify which player is this client
    local pref_name = ""
    local init = find_cinstance_type(gm.constants.oInit)
    if init then pref_name = init.pref_name end


    -- Get the player that belongs to this client
    local player = nil
    local players = find_all_cinstance_type(gm.constants.oP)
    if players then
        for i = 1, #players do
            if players[i] then
                if players[i].user_name == pref_name then
                    player = players[i]
                    break
                end
            end
        end
    end

    if player then
        -- Take no more than 90% of maximum health + current barrier
        local max_damage = (player.maxhp + player.barrier) * 0.9
        local osp_value = math.max(stored_health - max_damage, 0)

        if osp_value > 0 and player.hp < osp_value then
            player.hp = osp_value
            player.dead = false

            -- Give half a second of immunity
            -- (Don't override existing immunity if it has more frames)
            player.invincible = math.max(player.invincible, 30)
        end

        stored_health = player.hp + player.barrier
    end
end)