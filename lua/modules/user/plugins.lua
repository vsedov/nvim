local user = require("core.pack").package

user({
    "axieax/urlview.nvim",
    lazy = true,
    keys = {
        { "\\u", vim.cmd.UrlView, desc = "view buffer URLS " },
    },
    config = true,
})

-- Potential Hydra
user({
    "superDross/spellbound.nvim",
    keys = {
        {
            "<c-g>w",
            desc = "toggle spellbound",
        },
        { "<c-g>n", desc = "fix right" },
        { "<c-g>N", desc = "fix left" },
    },
    init = function()
        vim.o.dictionary = "/usr/share/dict/directory-list-2.3-medium.txt"
        -- default settings
        vim.g.spellbound_settings = {
            mappings = {
                toggle_map = "<c-g>w",
                fix_right = "<c-g>n",
                fix_left = "<c-g>p",
            },
            language = "en_gb",
            autospell_filetypes = { "*.txt", "*.md", "*.rst", "*.norg" },
            autospell_gitfiles = true,
            number_suggestions = 10,
            return_to_position = true,
        }
    end,
})
user({
    "Zeioth/markmap.nvim",
    lazy = true,
    build = "yarn global add markmap-cli",
    cmd = { "MarkmapOpen", "MarkmapSave", "MarkmapWatch", "MarkmapWatchStop" },
    opts = {
        html_output = "/tmp/markmap.html", -- (default) Setting a empty string "" here means: [Current buffer path].html
        hide_toolbar = false, -- (default)
        grace_period = 3600000, -- (default) Stops markmap watch after 60 minutes. Set it to 0 to disable the grace_period.
    },
    config = function(_, opts)
        require("markmap").setup(opts)
    end,
})

-- Potential Hydra, save those mappings perhaps ?
user({
    "azabiong/vim-highlighter",
    keys = {
        {
            "m<cr>",
            desc = "Highlight word",
        },
        {
            "m<bs>",
            desc = "Highlight delete",
        },
        {
            "mD>",
            desc = "Highlight clear",
        },
        {
            "m;",
            "<cmd>Hi}<cr>",
        },
    },
    init = function()
        vim.cmd("let HiSet = 'm<cr>'")

        vim.cmd("let HiErase = 'm<bs>'")
        vim.cmd("let HiClear = 'mD'")
    end,
})

-- # Ngl
-- ngl i do not get why this isnt  hydra actually
user({
    "KaitlynEthylia/TreePin",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = {
        "TPPin",
        "TPRoot",
        "TPGrow",
        "TPShrink",
        "TPClear",
        "TPGo",
        "TpHide",
        "TPToggle",
    },
    keys = {
        { ",tp", "<cmd>TPPin<CR>", desc = "TreePin Pin" },
        { ",tc", "<cmd>TPClear<CR>", desc = "TreePin Clear" },
        { ",tt", "<cmd>TPToggle<CR>", desc = "TreePin Toggle" },
        { ",tr", "<cmd>TPRoot<CR>", desc = "TreePin Root" },
        { ",tj", "<cmd>TPGrow<CR>", desc = "TreePin Grow" },
        { ",tk", "<cmd>TPShrink<CR>", desc = "TreePin Shrink" },
        {
            ",tg",
            function()
                vim.cmd("normal! m'")
                vim.cmd("TPGo")
            end,
            desc = "TreePin Go",
        },
        { ",ts", "<cmd>TPShow<CR>", desc = "TreePin Show" },
        { ",th", "<cmd>TPHide<CR>", desc = "TreePin Hide" },
    },
    opts = {
        seperator = "▔",
    },
})
-- user({
--     "lewis6991/whatthejump.nvim",
--     cond = false,
--     keys = { "<c-i>", "<c-o>" },
-- })
--  ──────────────────────────────────────────────────────────────────────
user({
    "thinca/vim-qfreplace",
    ft = "qf",
    lazy = true,
})

user({
    "creativenull/dotfyle-metadata.nvim",
    cmd = "DotfyleGenerate",
})

user({
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = true,
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    event = { "User KittyScrollbackLaunch" },
    config = true,
})

-- This is nice
user({
    "Sam-programs/expand.nvim",
    keys = { "<c-Space>" },
    dependencies = { "Sam-Programs/indent.nvim" },
    config = function()
        require("expand").setup({
            filetypes = {
                lua = {
                    -- if we are expanding on an unnamed function might aswell add the pairs
                    { "function\\s*$", { "()", "end" } },
                    { "function", { "", "end" } },
                    { "if", { " then", "end" } },
                    -- regex for a lua variable
                    { "^\\s*\\w\\+\\s*\\w*\\s*=\\s*$", { "{", "}" } },
                    { "", { " do", "end" } },
                },
                sh = {
                    { "elif", { " ;then", "" } },
                    { "if", { " ;then", "if" } },
                    { "case", { "", "esac" } },
                    { "while", { " do", "done" } },
                    { "for", { " do", "done" } },
                    { "", { "{", "}" } },
                },
                bash = {
                    { "elif", { " ;then", "" } },
                    { "if", { " ;then", "if" } },
                    { "case", { "", "esac" } },
                    { "while", { " do", "done" } },
                    { "for", { " do", "done" } },
                    { "", { "{", "}" } },
                },
                zsh = {
                    { "elif", { " then", "" } },
                    { "if", { " then", "if" } },
                    { "case", { "", "esac" } },
                    { "while", { " do", "done" } },
                    { "for", { " do", "done" } },
                    { "", { "{", "}" } },
                },
                c = {
                    { ".*(.*)", { "{", "}" } },
                    { "", { "{", "};" } },
                },
                cpp = {
                    { ".*(.*)", { "{", "}" } },
                    { "", { "{", "};" } },
                },
                python = {
                    {
                        "print",
                        {
                            "(",
                            ")",
                        },
                    },
                    { ".*(.*)", { ":", "" } },
                    { "", { ":", "" } },

                    {

                        "def",
                        {
                            "():",
                            "",
                        },
                    },
                },
            },

            hotkey = "<C-Space>",
        })
    end,
})

user({
    "nkakouros-original/scrollofffraction.nvim",
    event = "VeryLazy",
    config = function()
        require("scrollofffraction").setup()
    end,
})

user({
    "vidocqh/data-viewer.nvim",
    ft = {
        "csv",
        "tsv",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "kkharji/sqlite.lua", -- Optional, sqlite support
    },
    config = true,
    cmd = {
        "DataViewer",
        "DataViewerNextTable",
        "DataViewerPrevTable",
        "DataViewerClose",
    },
})

user({
    "theKnightsOfRohan/csvlens.nvim",
    dependencies = {
        "akinsho/toggleterm.nvim",
    },
    cmd = "Csvlens",
    config = true,
})
user({

    "neph-iap/easycolor.nvim",
    dependencies = { "stevearc/dressing.nvim" }, -- Optional, but provides better UI for editing the formatting template
    opts = {},
    cmd = {
        "EasyColor",
    },
})

-- TRIAL: (vsedov) (10:51:37 - 13/11/23): I am not sure what to think about this.

user({
    "mangelozzi/nvim-rgflow.lua",
    keys = {
        -- ";rG",
        -- ";rg",
        -- ";ro",
        -- ";ra",
        -- ";rc",
        -- ";rO",
        -- ";r?",

        {
            ";rG",
            desc = "rgflow: open blank",
        },
        {
            ";rg",
            desc = "rgflow: open cword",
        },
        {
            ";ro",
            desc = "rgflow: open paste",
        },
        {
            ";ra",
            desc = "rgflow: open again",
        },
        {
            ";rc",
            desc = "rgflow: abort",
        },
        {
            ";rO",
            desc = "rgflow: print cmd",
        },
        {
            ";r?",
            desc = "rgflow: print status",
        },
    },
    config = function()
        require("rgflow").setup({
            default_trigger_mappings = false,
            default_ui_mappings = true,
            default_quickfix_mappings = true,
            mappings = {
                trigger = {
                    -- Normal mode maps
                    n = {
                        [";rG"] = "open_blank", -- open UI - search pattern = blank
                        [";rg"] = "open_cword", -- open UI - search pattern = <cword>
                        [";ro"] = "open_paste", -- open UI - search pattern = First line of unnamed register as the search pattern
                        [";ra"] = "open_again", -- open UI - search pattern = Previous search pattern
                        [";rc"] = "abort", -- close UI / abort searching / abortadding results
                        [";rO"] = "print_cmd", -- Print a version of last run rip grep that can be pasted into a shell
                        [";r?"] = "print_status", -- Print info about the current state of rgflow (mostly useful for deving on rgflow)
                    },
                    -- Visual/select mode maps
                    x = {
                        [";rg"] = "open_visual", -- open UI - search pattern = current visual selection
                    },
                },
            },
            cmd_flags = "--smart-case --fixed-strings --no-fixed-strings --no-ignore --ignore --max-columns 500",
        })
    end,
})
-- ah this is better than tint, i think
-- lets disable this for now.
user({
    "miversen33/sunglasses.nvim",
    event = "VeryLazy",
    cond = lambda.config.ui.use_tint,
    config = true,
    opts = {
        excluded_filetypes = {

            "harpoon",
            "harpoon-menu",
            "dashboard",
            "lspsagafinder",
            "packer",
            "checkhealth",
            "mason",
            "NvimTree",
            "neo-tree",
            "plugin",
            "lazy",
            "TelescopePrompt",
            "alpha",
            "toggleterm",
            "sagafinder",
            "better_term",
            "fugitiveblame",
            "starter",
            "NeogitPopup",
            "NeogitStatus",
            "DiffviewFiles",
            "DiffviewFileHistory",
            "DressingInput",
            "spectre_panel",
            "zsh",
            "registers",
            "startuptime",
            "OverseerList",
            "Navbuddy",
            "noice",
            "notify",
            "saga_codeaction",
            "sagarename",
        },
    },
})

user({
    "chipsenkbeil/distant.nvim",
    cmd = { "Distant" },
    config = function()
        require("distant"):setup()
    end,
})

user({
    "mrshmllow/open-handlers.nvim",
    -- We modify builtin functions, so be careful lazy loading
    lazy = false,
    cond = vim.ui.open ~= nil,
    config = function()
        local oh = require("open-handlers")

        oh.setup({
            -- In order, each handler is tried.
            -- The first handler to successfully open will be used.
            handlers = {
                oh.issue, -- A builtin which handles github and gitlab issues
                oh.commit, -- A builtin which handles git commits
                oh.native, -- Default native handler. Should always be last
            },
        })
    end,
})
user({
    "rolv-apneseth/tfm.nvim",
    cmd = {
        "Tfm",
        "TfmSplit",
        "TfmVsplit",
        "TfmTabedit",
    },
    opts = {
        -- TFM to use
        -- Possible choices: "ranger" | "nnn" | "lf" | "yazi" (default)
        file_manager = "ranger",
        -- Replace netrw entirely
        -- Default: false
        replace_netrw = true,
        -- Enable creation of commands
        -- Default: false
        -- Commands:
        --   Tfm: selected file(s) will be opened in the current window
        --   TfmSplit: selected file(s) will be opened in a horizontal split
        --   TfmVsplit: selected file(s) will be opened in a vertical split
        --   TfmTabedit: selected file(s) will be opened in a new tab page
        enable_cmds = true,
        -- Custom keybindings only applied within the TFM buffer
        -- Default: {}
        keybindings = {
            ["<ESC>"] = "q",
        },
        -- Customise UI. The below options are the default
        ui = {
            border = lambda.style.border.type_0,
            height = 1,
            width = 1,
            x = 0.5,
            y = 0.5,
        },
    },
})
-- Well this is nice

user({
    "ariel-frischer/bmessages.nvim",
    event = "CmdlineEnter",
    cmd = {
        "Bmessages",
        "BmessagesVS",
        "Bmessagessp",
    },
    opts = {},
})

user({
    "2kabhishek/nerdy.nvim",
    dependencies = {
        "stevearc/dressing.nvim",
        "nvim-telescope/telescope.nvim",
    },
    cmd = "Nerdy",
})

-- this is great although it needs some refinement, one of them being that hydra, and heirline would
-- need to be completely reloaded for this to work . meaning an auto command is required so when
-- ever a new colourscheme is loaded from pineapple, you need to reset hydra and heirline, else this
-- is a rather nice plugin.

user({
    "stevearc/aerial.nvim",
    cmd = {
        "AerialPrev",
        "AerialNext",
        "AerialToggle",
        "AerialOpenAll",
        "AerialClose",
        "AerialCloseAll",
        "AerialGo",
        "AerialInfo",
        "AerialNavToggle",
        "AerialNavOpen",
        "AerialNavClose",
    },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    config = true,
    keys = {
        {
            "<leader>sw",
            function()
                vim.cmd("AerialToggle")
            end,
            desc = "Aerial Toggle",
        },
    },
})

user({
    "cbochs/portal.nvim",
    dependencies = {
        "ThePrimeagen/harpoon", -- Optional: provides the "harpoon" query item
    },
    opts = {
        window_options = {
            border = "rounded",
            relative = "cursor",
            height = 5,
        },
        select_first = true,
    },
    cmd = "Portal",
    keys = {
        {
            "<C-i>",
            function()
                require("portal.builtin").jumplist.tunnel_forward()
            end,
            desc = "portal fwd",
        },
        {
            "]o",
            function()
                require("portal.builtin").jumplist.tunnel_forward()
            end,
            desc = "portal fwd",
        },

        {
            "[o",
            function()
                require("portal.builtin").jumplist.tunnel_backward()
            end,
            desc = "portal fwd",
        },
        {
            "<C-o>",
            function()
                require("portal.builtin").jumplist.tunnel_backward()
            end,
            desc = "portal bwd",
        },
        -- TODO: use other queries?
    },
})

user({
    "lopi-py/luau-lsp.nvim",
    ft = "lua",
    config = true,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
})

user({
    "subnut/nvim-ghost.nvim",
    cond = false,
    config = function()
        -- All autocommands should be in 'nvim_ghost_user_autocommands' group
        local augroup_nvim_ghost_user_autocommands = vim.api.nvim_create_augroup("nvim_ghost_user_autocommands", {})
        local function addWebsiteSettings(opts) --  {{{
            vim.api.nvim_create_autocmd({ "User" }, {
                group = augroup_nvim_ghost_user_autocommands,
                pattern = opts.pattern,
                desc = opts.desc,
                callback = opts.callback,
            })
        end --  }}}

        addWebsiteSettings({
            pattern = { "www.overleaf.com" },
            desc = "nvim-ghost: set Overleaf settings",
            callback = function() --  {{{
                vim.opt.filetype = "tex"
                vim.opt.foldenable = false
                vim.opt.wrap = true

                -- avoid being overwriten by ftplugin
                vim.schedule(function()
                    vim.opt.textwidth = 0
                    vim.opt.tabstop = 4
                    vim.opt.shiftwidth = 0
                end)

                -- taken from markdown ftplugin
                for _, key in pairs({ "j", "k", "0", "$" }) do
                    vim.keymap.set("n", key, "g" .. key, {
                        desc = string.format("remap %s for better text editing", key),
                    })
                end
            end, --  }}}
        })

        addWebsiteSettings({
            pattern = { "github.com" },
            desc = "nvim-ghost: set GitHub settings",
            callback = function()
                vim.opt.filetype = "markdown"
            end,
        })
    end,
})
user({
    "klafyvel/nvim-smuggler",
    ft = "julia",
    opts = {
        mappings = true, -- set to false to disable all mappings.
        map_smuggle = "<leader>cs", -- Use `[count]<leader>cs` in normal mode to send count lines.
        map_smuggle_range = "<leader>cs", -- Use `<leader>cs` in visual mode to send the current selection.
        map_smuggle_config = "<leader>ce", -- Use `<leader>ce` in normal mode to reconfigure the plugin.
        map_smuggle_operator = "gcs", -- Use `gcs[text object]` to send a text object in normal mode.
    },
    dependencies = { "nvim-neotest/nvim-nio" },
})
-- # better modes i think this was right
-- print("there are other things here")
user({
    "mvllow/modes.nvim",
    cond = true,
    event = "VeryLazy",
    config = true,
})

user({
    "jinh0/eyeliner.nvim",
    keys = { "f", "F", "t", "T" },
    opts = {
        dim = true,
        highlight_on_key = true,
    },
})
user({
    "olimorris/persisted.nvim", -- Session management
    lazy = true,
    opts = {
        use_git_branch = true,
        silent = true,
        -- autoload = true,
        should_autosave = function()
            local excluded_filetypes = {
                "alpha",
                "oil",
                "lazy",
                "",
            }

            for _, filetype in ipairs(excluded_filetypes) do
                if vim.bo.filetype == filetype then
                    return false
                end
            end

            return true
        end,
    },
    cmd = {
        "Sessions",
        "SessionSave",
        "SessionStart",
        "SessionStop",
        "SessionDelete",
        "SessionToggle",
    },
})
user({
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    config = function()
        require("silicon").setup({
            -- Configuration here, or leave empty to use defaults
            -- # use julia
            output = {
                -- (string) The full path of the file to save to.
                file = "",
                -- (boolean) Whether to copy the image to clipboard instead of saving to file.
                clipboard = true,
                -- (string) Where to save images, defaults to the current directory.
                --  e.g. /home/user/Pictures
                path = ".",
                -- (string) The filename format to use. Can include placeholders for date and time.
                -- https://time-rs.github.io/book/api/format-description.html#components
                format = "silicon_[year][month][day]_[hour][minute][second].png",
            },
            font = "JuliaMono",
            watermark = {
                text = "  Viv",
            },
            window_title = function()
                return vim.fn.fnamemodify(vim.fn.bufname(vim.fn.bufnr()), ":~:.")
            end,
        })
    end,
})

user({
    "xiyaowong/transparent.nvim",
    config = true,
    cmd = {
        "TransparentEnable",
        "TransparentDisable",
        "TransparentToggle",
    },
})
user({
    "zeioth/garbage-day.nvim",
    dependencies = "neovim/nvim-lspconfig",
    event = "VeryLazy",
    opts = {
        aggressive_mode = true, -- I dont know why you would not have this enabled; i guess ima  bit confused for the case.
        -- your options here
    },
})
user({
    "kmontocam/nvim-conda",
    cmd = { "CondaActivate", "CondaDeactivate" },
})
-- TRIAL: (vsedov) (10:51:37 - 13/11/23): I am not sure what to think about this.
user({
    "carbon-steel/detour.nvim",
    keys = { "<c-w><cr>", ";;t", ";;g", ";;p" },
    config = function()
        vim.keymap.set("n", "<c-w><CR>", ":Detour<cr>")
        -- A keymap for selecting a terminal buffer to open in a popup
        vim.keymap.set("n", ";;t", function()
            require("detour").Detour() -- Open a detour popup

            -- Switch to a blank buffer to prevent any accidental changes.
            vim.cmd.enew()
            vim.bo.bufhidden = "delete"

            require("telescope.builtin").buffers({}) -- Open telescope prompt
            vim.api.nvim_feedkeys("term", "n", true) -- popuplate prompt with "term"
        end)
        vim.keymap.set("n", ";;g", function()
            local current_path = vim.fn.expand("%:p:h")
            local command = "a" -- go into terminal mode
                .. "cd "
                .. current_path
                .. "<CR>"
                .. "tig<CR>" -- run tig
            command = vim.api.nvim_replace_termcodes(command, true, false, true)

            require("detour").Detour() -- open a detour popup
            vim.cmd.terminal() -- open a terminal buffer
            vim.bo.bufhidden = "delete" -- close the terminal when window closes
            vim.api.nvim_feedkeys(command, "n", false)
        end)
        -- Wrap any TUI inside a popup
        vim.keymap.set("n", ";;p", function()
            require("detour").Detour() -- open a detour popup
            vim.cmd.terminal() -- open a terminal buffer
            vim.bo.bufhidden = "delete" -- close the terminal when window closes
            -- Run the `top` command
            local text = vim.api.nvim_replace_termcodes("atop<CR>", true, false, true)
            vim.api.nvim_feedkeys(text, "n", false)
        end)
    end,
})

-- TODO:  Convert this to a hydra config, so that i can just run a hydra and should be fine, ;p,
-- hydra should be good enough
user({
    "benlubas/molten-nvim",
    dependencies = {
        "3rd/image.nvim",
        -- "quarto-dev/quarto-nvim",
        -- "jmbuhr/otter.nvim",
        "hrsh7th/nvim-cmp",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
    },
    build = ":UpdateRemotePlugins",
    ft = { "python", "julia" },
    init = function()
        -- these are examples, not defaults. Please see the readme
        vim.g.molten_image_provider = "image.nvim"

        vim.g.molten_tick_rate = 200

        -- Output Windowquarto.runner
        vim.g.molten_auto_open_output = false
        vim.g.molten_output_win_max_height = 30

        -- Virtual Text
        vim.g.molten_virt_text_output = true
    end,
    config = function()
        -- vim.cmd([[UpdateRemotePlugins]])
        -- local keymap = vim.keymap.set
        -- keymap("n", ";pe", "<CMD>MoltenEvaluateOperator<CR>", { desc = "Evaluate Operator" })
        -- keymap("n", ";pl", "<CMD>MoltenEvaluateLine<CR>", { desc = "Evaluate Line" })
        -- keymap("n", ";pr", "<CMD>MoltenReevaluateCell<CR>", { desc = "Re-evaluate cell" })
        -- keymap("n", ";pd", "<CMD>MoltenDelete<CR>", { desc = "Delete cell" })
        -- keymap("n", ";ps", "<CMD>MoltenEnterOutput<CR>", { desc = "Show/enter output window" })
        -- keymap("n", ";ph", "<CMD>MoltenHideOutput<CR>", { desc = "Hide output window" })
        -- keymap("n", "]q", "<CMD>MoltenNext<CR>", { desc = "Goto next cell" })
        -- keymap("n", "[q", "<CMD>MoltenPrev<CR>", { desc = "Goto prev cell" })
        -- keymap("v", ";pe", ":<C-u>MoltenEvaluateVisual<CR>", { desc = "Evaluate visual selection" })

        -- local runner = require("quarto.runner")
        -- vim.keymap.set("n", "<localleader>rc", runner.run_cell, { desc = "run cell", silent = true })
        -- vim.keymap.set("n", "<localleader>ra", runner.run_above, { desc = "run cell and above", silent = true })
        -- vim.keymap.set("n", "<localleader>rA", runner.run_all, { desc = "run all cells", silent = true })
        -- vim.keymap.set("n", "<localleader>rl", runner.run_line, { desc = "run line", silent = true })
        -- vim.keymap.set("v", "<localleader>r", runner.run_range, { desc = "run visual range", silent = true })
        -- vim.keymap.set("n", "<localleader>RA", function()
        --     runner.run_all(true)
        -- end, { desc = "run all cells of all languages", silent = true })

        vim.keymap.set("n", "<localleader>ip", function()
            local venv = os.getenv("VIRTUAL_ENV")
            if venv ~= nil then
                venv = string.match(venv, "/.+/(.+)")
                vim.cmd(("MoltenInit %s"):format(venv))
            else
                vim.cmd("MoltenInit python3")
            end
        end, { desc = "Initialize Molten for python3", silent = true, noremap = true })

        -- vim.api.nvim_create_user_command(
        --     "JupyterInit",
        --     "! $HOME/.config/nvim/jupyter_init.sh <args>",
        --     { desc = "Init Jupiter kernel with name", nargs = 1 }
        -- )
        -- vim.api.nvim_create_user_command("JupyterConvert", function()
        --     if vim.bo.filetype ~= "quarto" then
        --         return
        --     end
        --     local path = vim.fn.expand("%:p")
        --     local notebook_path = string.sub(path, 1, -4) .. "ipynb"
        --     vim.cmd("! quarto convert " .. path .. " -o " .. notebook_path)
        -- end, { desc = "Convert from Quarto notebook to Jupyter notebook" })
    end,
})
