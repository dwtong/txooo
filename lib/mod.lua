local mod = require("core/mods")

local clock_options = { -- 12, default
    1 / 32,
    1 / 16,
    1 / 12,
    1 / 10,
    1 / 8,
    1 / 7,
    1 / 6,
    1 / 5,
    1 / 4,
    1 / 3,
    1 / 2,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
}

mod.hook.register("script_post_init", "txooo init", function()
    params:add_separator("TXO")
    params:add_number("txooo_clock_ppqn", "clock ppqn", 1, 16, 4)
    for i = 1, 4 do
        params:add_number("txooo_" .. i .. "_lfo_rate", "lfo rate " .. i, 0, 100, 0)
        params:set_action("txooo_" .. i .. "_lfo_rate", function(value)
            crow.ii.txo.osc_lfo(i, value * 10)
        end)
    end
    for i = 1, 4 do
        params:add_number("txooo_" .. i .. "_lfo_depth", "lfo depth " .. i, 0, 100, 0)
        params:set_action("txooo_" .. i .. "_lfo_depth", function(value)
            crow.ii.txo.cv(i, value / 10)
        end)
    end
    for i = 1, 4 do
        params:add_number("txooo_" .. i .. "_lfo_shape", "lfo shape " .. i, 0, 100, 0)
        params:set_action("txooo_" .. i .. "_lfo_shape", function(value)
            crow.ii.txo.osc_wave(i, value * 100)
        end)
    end
    for i = 1, 4 do
        params:add_option("txooo_" .. i .. "_clock_rate", "clock rate " .. i, clock_options, 12)
        clock.run(function()
            while true do
                local rate = clock_options[params:get("txooo_" .. i .. "_clock_rate")]
                local ppqn = params:get("txooo_clock_ppqn")
                crow.ii.txo.tr_pulse(i)
                clock.sync(rate / ppqn)
            end
        end)
    end
end)
