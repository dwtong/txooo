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
