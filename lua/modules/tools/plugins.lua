local conf = require("modules.tools.config")
local tools = require("core.pack").package
tools({
    "gennaro-tedesco/nvim-jqx",
    lazy = true,
    ft = "json",
    cmd = { "JqxList", "JqxQuery" },
})

tools({
    "is0n/fm-nvim",
    lazy = true,
    cmd = {
        "Lazygit", -- 3 [ neogit + fugative + lazygit depends how i feel.]
        "Joshuto", -- 2
        "Ranger",
        "Xplr", -- Nice but, i think ranger tops this one for the.time
        "Skim",
        "Nnn",
        "Fff",
        "Fzf",
        "Fzy",
    },
    config = conf.fm,
})
tools({
    "rktjmp/paperplanes.nvim",
    lazy = true,
    cmd = { "PP" },
    opts = {
        register = "+",
        provider = "dpaste.org",
        provider_options = {},
        notifier = vim.notify or print,
    },
})

tools({
    "natecraddock/workspaces.nvim",
    lazy = true,
    cmd = {
        "WorkspacesAdd",
        "WorkspacesRemove",
        "WorkspacesRename",
        "WorkspacesList",
        "WorkspacesOpen",
    },
    config = conf.workspace,
})

tools({
    "xiyaowong/link-visitor.nvim",
    lazy = true,
    cmd = { "VisitLinkInBuffer", "VisitLinkUnderCursor", "VisitLinkNearCursor" },
    config = function()
        require("link-visitor").setup({
            silent = true, -- disable all prints, `false` by default
        })
    end,
})

tools({
    "rhysd/vim-grammarous",
    lazy = true,
    cmd = { "GrammarousCheck" },
    ft = { "markdown", "txt", "norg", "tex" },
    init = conf.grammarous,
})
-------------

tools({
    "plasticboy/vim-markdown",
    lazy = true,
    ft = "markdown",
    dependencies = { "godlygeek/tabular" },
    cmd = { "Toc" },
    init = conf.markdown,
})

tools({
    "iamcco/markdown-preview.nvim",
    lazy = true,
    ft = { "markdown", "pandoc.markdown", "rmd" },
    cmd = { "MarkdownPreview" },
    init = conf.mkdp,
    build = [[sh -c "cd app && yarn install"]],
})

tools({
    "akinsho/toggleterm.nvim",
    lazy = true,
    cmd = { "FocusTerm", "TermTrace", "TermExec", "ToggleTerm", "Htop", "GDash" },
    config = function()
        require("modules.tools.toggleterm")
    end,
    keys = {
        "<leader>t0",
        "<leader>t1",
        "<leader>t2",
        "<leader>t3",
        "<leader>t4",
        "<leader>t!",
        "<leader>gh",
        "<leader>tf",
        "<leader>th",
        "<leader><Tab>",
        "<c-t>",
    },
})

tools({
    "wakatime/vim-wakatime",
    lazy = true,
})

tools({ "ilAYAli/scMRU.nvim", lazy = true, cmd = { "MruRepos", "Mru", "Mfu", "MruAdd", "MruDel" } })

tools({
    url = "https://gitlab.com/yorickpeterse/nvim-pqf",
    event = "VeryLazy",
    config = function()
        lambda.highlight.plugin("pqf", {
            theme = {
                ["doom-one"] = { { qfPosition = { link = "Todo" } } },
                ["horizon"] = { { qfPosition = { link = "String" } } },
            },
        })
        require("pqf").setup()
    end,
})
tools({
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
        lambda.highlight.plugin("bqf", { { BqfPreviewBorder = { fg = { from = "Comment" } } } })
    end,
})
tools({
    "stevearc/qf_helper.nvim",
    ft = "qf",
    cmd = {
        "QFOpen",
        "QFNext",
        "QFPrev",
        "QFToggle",
    },
    config = function()
        require("qf_helper").setup({
            prefer_loclist = false,
        })
    end,
})

tools({
    "voldikss/vim-translator",
    lazy = true,
    init = function()
        vim.g.translator_source_lang = "jp"
    end,
    cmd = { "Translate", "TranslateW", "TranslateR", "TranslateH", "TranslateL" },
})

tools({
    "ttibsi/pre-commit.nvim",
    lazy = true,
    cmd = "Precommit",
})

tools({
    "lambdalisue/suda.vim",
    lazy = true,
    cmd = {
        "SudaRead",
        "SudaWrite",
    },
    init = function()
        vim.g.suda_smart_edit = 1
    end,
})

tools({
    "barklan/capslock.nvim",
    lazy = true,
    keys = "<leader><leader>;",
    config = function()
        require("capslock").setup()
        vim.keymap.set(
            { "i", "c", "n" },
            "<leader><leader>;",
            "<Plug>CapsLockToggle<Cr>",
            { noremap = true, desc = "Toggle CapsLock" }
        )
    end,
})

tools({
    "dstein64/vim-startuptime",
    lazy = true,
    cmd = "StartupTime",
    config = function()
        vim.g.startuptime_tries = 15
        vim.g.startuptime_exe_args = { "+let g:auto_session_enabled = 0" }
    end,
})

tools({
    "chrisgrieser/nvim-genghis",
    lazy = true,
    dependencies = { "stevearc/dressing.nvim" },
    cmd = {
        "GenghiscopyFilepath",
        "GenghiscopyFilename",
        "Genghischmodx",
        "GenghisrenameFile",
        "GenghiscreateNewFile",
        "GenghisduplicateFile",
        "Genghistrash",
        "Genghismove",
    },
    config = function()
        local genghis = require("genghis")
        lambda.command("GenghiscopyFilepath", genghis.copyFilepath, {})
        lambda.command("GenghiscopyFilename", genghis.copyFilename, {})
        lambda.command("Genghischmodx", genghis.chmodx, {})
        lambda.command("GenghisrenameFile", genghis.renameFile, {})
        lambda.command("GenghiscreateNewFile", genghis.createNewFile, {})
        lambda.command("GenghisduplicateFile", genghis.duplicateFile, {})
        lambda.command("Genghistrash", function()
            genghis.trashFile({ trashLocation = "/home/viv/.local/share/Trash/" })
        end, {})
        lambda.command("Genghismove", genghis.moveSelectionToNewFile, {})
    end,
})

tools({
    "tyru/capture.vim",
    lazy = true,
    cmd = "Capture",
})

tools({
    "thinca/vim-qfreplace",
    lazy = true,
    cmd = "Qfreplace",
})
tools({
    "willothy/flatten.nvim",
    cond = lambda.config.tools.use_flatten,
    priority = 1001,
    opts = {
        window = { open = "alternate" },
        callbacks = {
            block_end = function()
                require("toggleterm").toggle()
            end,
            post_open = function(_, winnr, _, is_blocking)
                if is_blocking then
                    require("toggleterm").toggle()
                else
                    vim.api.nvim_set_current_win(winnr)
                end
            end,
        },
    },
})

-- The goal of nvim-fundo is to make Neovim's undo file become stable and useful.
tools({
    "kevinhwang91/nvim-fundo",
    event = "BufReadPre",
    cond = lambda.config.tools.use_fundo, -- messes with some buffers which is really not that amazing | will have to see if there is a better fix for this
    cmd = { "FundoDisable", "FundoEnable" },
    dependencies = "kevinhwang91/promise-async",
    build = function()
        require("fundo").install()
    end,
    config = true,
})

tools({
    "AntonVanAssche/date-time-inserter.nvim",
    lazy = true,
    cmd = {
        "InsertDate",
        "InsertTime",
        "InsertDateTime",
    },
    config = true,
})

tools({
    "chomosuke/term-edit.nvim",
    lazy = true, -- or ft = 'toggleterm' if you use toggleterm.nvim
    event = "TermEnter",
    config = function()
        require("term-edit").setup({
            prompt_end = "[»#$] ",
            mapping = {
                n = { s = false, S = false },
            },
        })
    end,
})

tools({
    "m-demare/attempt.nvim",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("attempt").setup()
        require("telescope").load_extension("attempt")
    end,
})

tools({
    "FluxxField/bionic-reading.nvim",
    lazy = true,
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
        file_types = {
            ["text"] = {
                "any", -- highlight any node
            },
            ["lua"] = {
                "any",
            },
            ["python"] = { "any" },
        },
        hl_group_value = {
            link = "Bold", -- you could do italic
        },
        treesitter = false, -- this does not work right now
    },
})

tools({
    "tpope/vim-eunuch",
    cmd = {
        "Delete",
        "Unlink",
        "Move",
        "Rename",
        "Chmod",
        "Mkdir",
        "Cfind",
        "Clocate",
        "Lfind",
        "Wall",
        "SudoWrite",
        "SudoEdit",
    },
})
tools({
    "smjonas/live-command.nvim",
    cond = lambda.config.tools.use_live_command,
    event = "VeryLazy",
    opts = {
        commands = {
            Norm = { cmd = "norm" },
            Glive = { cmd = "g" },
            Dlive = { cmd = "d" },
            Qlive = {
                cmd = "norm",
                -- This will transform ":5Qlive a" into ":norm 5@a"
                args = function(opts)
                    local reg = opts.fargs and opts.fargs[1] or "q"
                    local count = opts.fargs and opts.fargs[2] or (opts.count == -1 and "" or opts.count)
                    return count .. "@" .. reg
                end,
                range = "",
            },
        },
    },
    config = function(_, opts)
        require("live-command").setup(opts)
    end,
})
tools({
    "norcalli/nvim-terminal.lua",
    ft = "terminal",
    config = function()
        require("terminal").setup()
    end,
})
