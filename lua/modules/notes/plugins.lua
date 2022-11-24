local conf = require("modules.notes.config")
local notes = require("core.pack").package

notes({
    "nvim-neorg/neorg",
    -- "tamton-aquib/neorg",
    -- branch = "code-execution",
    --[[ branch = "main", ]]
    tags = "*",
    run = ":Neorg sync-parsers",
    requires = {
        { "max397574/neorg-contexts", ft = "norg" },
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
        "nvim-treesitter",
    },

    config = conf.norg,
})

--  REVISIT: (vsedov) (02:26:26 - 10/11/22): Required?
notes({
    "hisbaan/jot.nvim",
    requires = "nvim-lua/plenary.nvim",
    cmd = { "Jot" },
    config = conf.jot,
})

notes({
    "AckslD/nvim-FeMaco.lua",
    opt = true,
    ft = { "norg", "markdown" },
    config = conf.femaco,
    cmd = "FeMaco",
})

notes({
    "jubnzv/mdeval.nvim",
    ft = { "norg" },
    config = conf.mdeval,
})

notes({
    "lervag/vimtex",
    opt = true,
    ft = { "latex", "tex" },
    setup = conf.vimtex,
})

notes({
    "dhruvasagar/vim-table-mode",
    cmd = "TableModeToggle",
    opt = true,
    ft = { "norg", "markdown" },
    conf = conf.table,
})

notes({
    "edluffy/hologram.nvim",
    opt = true,
    -- Disable this fo rth etime , there could be some breaking changes
    -- that i dont really know how to deal with
    config = conf.hologram,
})
-- Default:~
--     normal = {
--       ["<cr>"] = "open_data",
--       ["<s-cr>"] = "open_data_index",
--       ["<tab>"] = "toggle_node",
--       ["<s-tab>"] = "toggle_node",
--       ["/"] = "select_path",
--       ["$"] = "change_icon_menu",
--       c = "add_inside_end_index",
--       I = "add_inside_start",
--       i = "add_inside_end",
--       l = "copy_node_link",
--       L = "copy_node_link_index",
--       d = "delete",
--       O = "add_above",
--       o = "add_below",
--       q = "quit",
--       r = "rename",
--       R = "change_icon",
--       u = "make_url",
--       x = "select",
--     }

--     selection = {
--       ["<cr>"] = "open_data",
--       ["<s-tab>"] = "toggle_node",
--       ["/"] = "select_path",
--       I = "move_inside_start",
--       i = "move_inside_end",
--       O = "move_above",
--       o = "move_below",
--       q = "quit",
--       x = "select",
--     }

notes({
    "phaazon/mind.nvim",
    cmd = { "MindOpenMain", "MindOpenProject", "MindReloadState" },
    config = function()
        require("mind").setup()
    end,
})

notes({
    lambda.use_local("pomodoro.nvim", "personal"),
    cmd = {
        "PomodoroStartFocus",
        "PomodoroStartBreak",
        "PomodoroStartLongBreak",
        "PomodoroPause",
        "PomodoroResume",
        "PomodoroTogglePopup",
    },
})

-- notes({
--     "jghauser/papis.nvim",
--     -- after = { "telescope.nvim", "nvim-cmp" },
--     ft = { "latex", "tex", "norg" },
--     requires = {
--         "kkharji/sqlite.lua",
--         "nvim-lua/plenary.nvim",
--         "MunifTanjim/nui.nvim",
--         "nvim-treesitter/nvim-treesitter",
--     },
--     rocks = { "lyaml" },
--     config = function()
--         require("papis").setup({
--             papis_python = {
--                 dir = "/home/viv/Documents/papers/",
--                 info_name = "info.yaml", -- (when setting papis options `-` is replaced with `_`
--                 notes_name = [[notes.norg]],
--             },
--             enable_keymaps = false,
--         })
--     end,
-- })
