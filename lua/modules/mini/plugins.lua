local mini = require("core.pack").package
local conf = require("modules.mini.config")
local mini_opt = lambda.config.ui.mini_animate

mini({
    "echasnovski/mini.indentscope",
    cond = lambda.config.ui.indent_lines.use_mini_indent_scope,
    event = { "UIEnter" },
    init = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = {
                "alpha",
                "coc-explorer",
                "dashboard",
                "fzf", -- fzf-lua
                "help",
                "lazy",
                "lazyterm",
                "lspsagafinder",
                "mason",
                "nnn",
                "notify",
                "NvimTree",
                "qf",
                "starter", -- mini.starter
                "toggleterm",
                "Trouble",
                "neoai-input",
                "neoai-*",
                "neoai-output",
                "neo-tree",
                "neo-*",
                "neorg",
                "norg",
                "*.norg",
                "*norg",
                "*neorg",
            },
            callback = function()
                vim.b.miniindentscope_disable = true
                vim.schedule(function()
                    if MiniIndentscope then
                        MiniIndentscope.undraw()
                    end
                end)
            end,
        })
    end,
    opts = {
        symbol = "│",
        options = {
            border = "both",
            indent_at_cursor = true,
            try_as_border = true,
        },
    },
})

mini({
    "echasnovski/mini.trailspace",
    event = "VeryLazy",
    init = function()
        lambda.command("TrimTrailSpace", function()
            MiniTrailspace.trim()
        end, {})
        lambda.command("TrimLastLine", function()
            MiniTrailspace.trim_last_lines()
        end, {})
    end,
    config = true,
})

-- mini({
--     "echasnovski/mini.align",
--     main = "mini.align",
--     opts = {},
--     keys = { { "ga" } },
-- })

mini({
    "echasnovski/mini.clue",
    cond = lambda.config.tools.use_which_key_or_use_mini_clue == "mini",
    event = "VeryLazy",
    config = function()
        local miniclue = require("mini.clue")
        miniclue.setup({
            triggers = {
                --  ──────────────────────────────────────────────────────────────────────

                -- Leader triggers
                { mode = "n", keys = ";" },
                { mode = "x", keys = ";" },
                { mode = "n", keys = "_" },
                { mode = "x", keys = "_" },

                { mode = "n", keys = "<Leader>" },
                { mode = "x", keys = "<Leader>" },
                --  ──────────────────────────────────────────────────────────────────────
                { mode = "x", keys = "<cr>" },
                { mode = "o", keys = "<cr>" },
                --  ──────────────────────────────────────────────────────────────────────

                { mode = "n", keys = "<c-g>" },
                { mode = "x", keys = "<c-g>" },

                --  ──────────────────────────────────────────────────────────────────────
                { mode = "n", keys = "," },
                { mode = "x", keys = "," },
                --  ──────────────────────────────────────────────────────────────────────

                { mode = "n", keys = "\\" },
                { mode = "x", keys = "\\" },
                --  ──────────────────────────────────────────────────────────────────────

                { mode = "x", keys = "]" },
                { mode = "o", keys = "]" },
                --  ──────────────────────────────────────────────────────────────────────

                -- Built-in completion
                { mode = "i", keys = "<C-x>" },
                --  ──────────────────────────────────────────────────────────────────────

                -- -- `g` key
                -- { mode = "n", keys = "g" },
                -- { mode = "x", keys = "g" },
                --  ──────────────────────────────────────────────────────────────────────

                -- Marks
                { mode = "n", keys = "'" },
                { mode = "n", keys = "`" },
                { mode = "x", keys = "'" },
                { mode = "x", keys = "`" },
                --  ──────────────────────────────────────────────────────────────────────

                -- Registers
                { mode = "n", keys = '"' },
                { mode = "x", keys = '"' },
                { mode = "i", keys = "<C-r>" },
                { mode = "c", keys = "<C-r>" },
                --  ──────────────────────────────────────────────────────────────────────

                -- Window commands
                { mode = "n", keys = "<C-w>" },
                --  ──────────────────────────────────────────────────────────────────────

                -- `z` key
                { mode = "n", keys = "z" },
                { mode = "x", keys = "z" },
                --  ──────────────────────────────────────────────────────────────────────

                -- { mode = "n", keys = ";r" },
                -- { mode = "x", keys = ";r" },

                { mode = "n", keys = "m" },
                { mode = "x", keys = "m" },
            },

            clues = {
                -- Enhance this by adding descriptions for <Leader> mapping groups
                miniclue.gen_clues.builtin_completion(),
                miniclue.gen_clues.g(),
                miniclue.gen_clues.marks(),
                miniclue.gen_clues.registers(),
                miniclue.gen_clues.windows(),
                miniclue.gen_clues.z(),
            },
            window = {
                delay = 100,
            },
        })
    end,
})
