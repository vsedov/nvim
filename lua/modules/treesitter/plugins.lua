--  TODO: (vsedov) (08:58:48 - 08/11/22): Make all of this optional, because im not sure which is
--  causing the error here, and its quite important that i figure this one out .
local conf = require("modules.treesitter.config")
local ts = require("core.pack").package
local fn = vim.fn

ts({
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    init = conf.treesitter_init,
    config = conf.nvim_treesitter,
})

ts({
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = conf.treesitter_obj,
})

ts({
    "RRethy/nvim-treesitter-textsubjects",
    lazy = true,
    ft = { "lua", "rust", "go", "python", "javascript" },
    config = conf.tsubject,
})

ts({
    "RRethy/nvim-treesitter-endwise",
    lazy = true,
    ft = { "lua", "ruby", "vim" },
    config = conf.endwise,
})

ts({
    "nvim-treesitter/nvim-treesitter-refactor",
    lazy = true,

    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-treesitter/nvim-treesitter-textobjects" },
    config = conf.treesitter_ref, -- let the last loaded config treesitter
})
ts({
    "David-Kunz/markid",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
})

ts({
    "m-demare/hlargs.nvim",
    lazy = true,

    ft = {
        "c",
        "cpp",
        "go",
        "java",
        "javascript",
        "jsx",
        "lua",
        "php",
        "python",
        "r",
        "ruby",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "zig",
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = conf.hlargs,
})

ts({
    "andrewferrier/textobj-diagnostic.nvim",
    lazy = true,

    ft = { "python", "lua" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = true,
})

ts({
    "andymass/vim-matchup",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = conf.matchup,
    init = conf.matchup_setup,
})
ts({
    "Yggdroot/hiPairs",
    lazy = true,
    cond = true,
    event = "BufRead",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = conf.hi_pairs,
})

ts({
    "NMAC427/guess-indent.nvim",
    lazy = true,
    event = lambda.config.guess_indent,
    cmd = "GuessIndent",
    config = conf.guess_indent,
})

ts({
    "yioneko/nvim-yati",
    event = "VeryLazy",
    lazy = true,
    dependencies = { "nvim-treesitter/nvim-treesitter", "yioneko/vim-tmindent" },
    config = conf.indent,
})

ts({
    "folke/paint.nvim",
    lazy = true,
    ft = "lua",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = conf.paint,
})

ts({
    "Dkendal/nvim-treeclimber",
    lazy = true,
    dependencies = { "rktjmp/lush.nvim", "nvim-treesitter/nvim-treesitter" },
})

-- ts({
--     "wellle/targets.vim",
--     lazy = true,
--     event = "VeryLazy",
--     init = function()
--         vim.g.targets_gracious = 1
--     end,
--     config = function()
--         vim.cmd([[
-- autocmd User targets#mappings#user call targets#mappings#extend({
--     \ 's': { 'separator': [{'d':','}, {'d':'.'}, {'d':';'}, {'d':':'}, {'d':'+'}, {'d':'-'},
--     \                      {'d':'='}, {'d':'~'}, {'d':'_'}, {'d':'*'}, {'d':'#'}, {'d':'/'},
--     \                      {'d':'\'}, {'d':'|'}, {'d':'&'}, {'d':'$'}] },
--     \ '@': {
--     \     'separator': [{'d':','}, {'d':'.'}, {'d':';'}, {'d':':'}, {'d':'+'}, {'d':'-'},
--     \                   {'d':'='}, {'d':'~'}, {'d':'_'}, {'d':'*'}, {'d':'#'}, {'d':'/'},
--     \                   {'d':'\'}, {'d':'|'}, {'d':'&'}, {'d':'$'}],
--     \     'pair':      [{'o':'(', 'c':')'}, {'o':'[', 'c':']'}, {'o':'{', 'c':'}'}, {'o':'<', 'c':'>'}],
--     \     'quote':     [{'d':"'"}, {'d':'"'}, {'d':'`'}],
--     \     'tag':       [{}],
--     \     },
--     \ })
--       ]])
--     end,
-- })

ts({
    "chrisgrieser/nvim-various-textobjs",
    lazy = true,
    event = "VeryLazy",
    config = function()
        require("various-textobjs").setup({ useDefaultKeymaps = true })

        -- example: `?` for diagnostic textobj
        vim.keymap.set({ "o", "x" }, "?", '<cmd>lua require("various-textobjs").diagnostic()<CR>')

        -- example: `an` for outer subword, `in` for inner subword
        vim.keymap.set({ "o", "x" }, "aS", '<cmd>lua require("various-textobjs").subword(false)<CR>')
        vim.keymap.set({ "o", "x" }, "iS", '<cmd>lua require("various-textobjs").subword(true)<CR>')

        -- exception: indentation textobj requires two parameters, the first for
        -- exclusion of the starting border, the second for the exclusion of ending
        -- border
        vim.keymap.set({ "o", "x" }, "ii", '<cmd>lua require("various-textobjs").indentation(true, true)<CR>')
        vim.keymap.set({ "o", "x" }, "ai", '<cmd>lua require("various-textobjs").indentation(false, true)<CR>')
    end,
})

ts({
    "ckolkey/ts-node-action",
    lazy = true,
    dependencies = { "nvim-treesitter" },
    keys = "<leader>k",
    init = function()
        vim.keymap.set(
            "n",
            "<leader>k",
            require("ts-node-action").node_action,
            { noremap = true, silent = true, desc = "Trigger Node Action" }
        )
    end,
    config = true,
})

ts({
    "ziontee113/SelectEase",
    lazy = true,
    ft = { "lua", "python" },
})
