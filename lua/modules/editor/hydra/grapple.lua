if lambda.config.use_lightspeed then
    local Hydra = require("hydra")
    local match = lambda.lib.match
    local when = lambda.lib.when
    local loader = require("packer").loader
    local cmd = require("hydra.keymap-util").cmd
    loader("portal.nvim")
    local hint = [[
^ ^ _i_: Jump Forward   ^ ^
^ ^ _o_: Jump Backward  ^ ^
^ ^ _k_: Toggle         ^ ^
^ ^ _t_: Tag            ^ ^
^ ^ _u_: UnTag          ^ ^
]]
    Hydra({
        name = "Runner",
        hint = hint,
        config = {
            color = "pink",
            invoke_on_body = true,
            hint = {
                position = "middle-right",
                border = lambda.style.border.type_0,
            },
        },
        mode = { "n" },
        body = "\\i",
        heads = {
            {
                "i",
                function()
                    require("portal").jump_forward()
                end,
                { exit = true },
            },
            {
                "o",
                function()
                    require("portal").jump_backward()
                end,
                { exit = true },
            },
            {
                "k",
                function()
                    require("grapple").toggle()
                end,
                { exit = false },
            },
            {
                "t",
                function()
                    require("grapple").tag()
                end,
                { exit = false },
            },
            {
                "u",
                function()
                    require("grapple").untag()
                end,
                { exit = false },
            },
            { "<Esc>", nil, { exit = true, desc = false } },
        },
    })
end
