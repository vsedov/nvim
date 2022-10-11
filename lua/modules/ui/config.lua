local api = vim.api
local config = {}
packer_plugins = packer_plugins or {} -- supress warning

function config.fidget()
    local relative = "editor"
    require("fidget").setup({
        align = {
            bottom = false, -- align fidgets along bottom edge of buffer
            right = true, -- align fidgets along right edge of buffer
        },
        timer = {
            spinner_rate = 100, -- frame rate of spinner animation, in ms
            fidget_decay = 500, -- how long to keep around empty fidget, in ms
            task_decay = 300, -- how long to keep around completed task, in ms
        },
        window = {
            relative = relative, -- where to anchor the window, either `"win"` or `"editor"`
            blend = 100, -- `&winblend` for the window
            zindex = nil, -- the `zindex` value for the window
        },
        fmt = {
            leftpad = true, -- right-justify text in fidget box
            stack_upwards = false, -- list of tasks grows upwards
            max_width = 0, -- maximum width of the fidget box
            -- function to format fidget title
            fidget = function(fidget_name, spinner)
                return string.format("%s %s", spinner, fidget_name)
            end,
            -- function to format each task line
            task = function(task_name, message, percentage)
                return string.format(
                    "%s%s [%s]",
                    message,
                    percentage and string.format(" (%s%%)", percentage) or "",
                    task_name
                )
            end,
        },

        debug = {
            logging = false, -- whether to enable logging, for debugging
            strict = false, -- whether to interpret LSP strictly
        },
    })
    lambda.augroup("CloseFidget", {
        {
            event = { "VimLeavePre", "LspDetach" },
            command = "silent! FidgetClose",
        },
    })
end

function config.notify()
    require("utils.ui.highlights").plugin("notify", {
        { NotifyERRORBorder = { bg = { from = "NormalFloat" } } },
        { NotifyWARNBorder = { bg = { from = "NormalFloat" } } },
        { NotifyINFOBorder = { bg = { from = "NormalFloat" } } },
        { NotifyDEBUGBorder = { bg = { from = "NormalFloat" } } },
        { NotifyTRACEBorder = { bg = { from = "NormalFloat" } } },
        { NotifyERRORBody = { link = "NormalFloat" } },
        { NotifyWARNBody = { link = "NormalFloat" } },
        { NotifyINFOBody = { link = "NormalFloat" } },
        { NotifyDEBUGBody = { link = "NormalFloat" } },
        { NotifyTRACEBody = { link = "NormalFloat" } },
    })

    local notify = require("notify")
    notify.setup({
        timeout = 3000,
        stages = "slide",
        top_down = false,
        background_colour = "NormalFloat",

        max_width = function()
            return math.floor(vim.o.columns * 0.8)
        end,
        max_height = function()
            return math.floor(vim.o.lines * 0.8)
        end,
        render = function(...)
            local notif = select(2, ...)
            local style = notif.title[1] == "" and "minimal" or "default"
            require("notify.render")[style](...)
        end,
    })
    vim.notify = notify

    vim.keymap.set("n", "|+", ":lua require('notify').dismiss()<CR>", { noremap = true, silent = true })
    require("telescope").load_extension("notify")
end

function config.notifier()
    require("notifier").setup({
        notify = {
            clear_time = 10000, -- Time in milisecond before removing a vim.notifiy notification, 0 to make them sticky
            min_level = vim.log.levels.INFO, -- Minimum log level to print the notification
        },
    })
end
function config.neo_tree()
    if not packer_plugins["nui.nvim"].loaded then
        vim.cmd([[packadd nui.nvim ]])
    end
    if not packer_plugins["nvim-window-picker"].loaded then
        vim.cmd([[packadd nvim-window-picker ]])
    end
    local highlights = require("utils.ui.highlights")

    highlights.plugin("NeoTree", {
        { NeoTreeNormal = { link = "PanelBackground" } },
        { NeoTreeNormalNC = { link = "PanelBackground" } },
        { NeoTreeRootName = { underline = true } },
        { NeoTreeCursorLine = { link = "Visual" } },
        { NeoTreeStatusLine = { link = "PanelSt" } },
        { NeoTreeTabActive = { bg = { from = "PanelBackground" }, bold = true } },
        {
            NeoTreeTabInactive = {
                bg = { from = "PanelDarkBackground", alter = 15 },
                fg = { from = "Comment" },
            },
        },
        {
            NeoTreeTabSeparatorInactive = {
                inherit = "NeoTreeTabInactive",
                fg = { from = "PanelDarkBackground", attr = "bg" },
            },
        },
        {
            NeoTreeTabSeparatorActive = {
                inherit = "PanelBackground",
                fg = { from = "Comment" },
            },
        },
    })
    vim.g.neo_tree_remove_legacy_commands = 1
    require("neo-tree").setup({
        sources = {
            "filesystem",
            "buffers",
            "git_status",
            "diagnostics",
        },
        source_selector = {
            winbar = true,
            separator_active = " ",
        },
        close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
        popup_border_style = "solid", -- "double", "none", "rounded", "shadow", "single" or "solid
        enable_git_status = true,
        enable_diagnostics = true,
        git_status_async = true,
        event_handlers = {
            {
                event = "neo_tree_buffer_enter",
                handler = function()
                    highlights.set("Cursor", { blend = 100 })
                end,
            },
            {
                event = "neo_tree_buffer_leave",
                handler = function()
                    highlights.set("Cursor", { blend = 0 })
                end,
            },
        },
        use_popups_for_input = false,
        default_component_configs = {
            indent = {
                indent_size = 2,
                padding = 1, -- extra padding on left hand side
                -- indent guides
                with_markers = true,
                indent_marker = "│",
                last_indent_marker = "└",
                highlight = "NeoTreeIndentMarker",
                -- expander config, needed for nesting files
                with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
                expander_collapsed = "",
                expander_expanded = "",
                expander_highlight = "NeoTreeExpander",
            },
            diagnostics = {
                highlights = {
                    hint = "DiagnosticHint",
                    info = "DiagnosticInfo",
                    warn = "DiagnosticWarn",
                    error = "DiagnosticError",
                },
            },
            icon = {
                folder_closed = "",
                folder_open = "",
                folder_empty = "ﰊ",
                default = "*",
            },
            modified = {
                symbol = "[+]",
                highlight = "NeoTreeModified",
            },
            name = {
                trailing_slash = false,
                use_git_status_colors = true,
            },
            git_status = {
                symbols = {
                    -- Change type
                    added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
                    modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
                    deleted = "✖", -- this can only be used in the git_status source
                    renamed = "", -- this can only be used in the git_status source
                    -- Status type
                    untracked = "",
                    ignored = "",
                    unstaged = "",
                    staged = "",
                    conflict = "",
                },
            },
        },
        window = {
            position = "left",
            width = 35,
            mappings = {
                ["<space>"] = "toggle_node",
                ["<2-LeftMouse>"] = "open",
                ["<cr>"] = "open",
                ["S"] = "open_split",
                ["s"] = "open_vsplit",
                ["t"] = "open_tabnew",
                ["w"] = "open_with_window_picker",
                ["C"] = "close_node",
                ["a"] = "add",
                ["A"] = "add_directory",
                ["d"] = "delete",
                ["r"] = "rename",
                ["y"] = "copy_to_clipboard",
                ["x"] = "cut_to_clipboard",
                ["p"] = "paste_from_clipboard",
                ["c"] = "copy", -- takes text input for destination
                ["m"] = "move", -- takes text input for destination
                ["q"] = "close_window",
                ["R"] = "refresh",
            },
        },
        nesting_rules = {},
        filesystem = {
            filtered_items = {
                visible = false, -- when true, they will just be displayed differently than normal items
                hide_dotfiles = true,
                hide_gitignored = true,
                hide_hidden = true, -- only works on Windows for hidden files/directories
                hide_by_name = {
                    "node_modules",
                },
                hide_by_pattern = { -- uses glob style patterns
                    "*.meta",
                },
                always_show = { -- remains visible even if other settings would normally hide it
                    ".gitignored",
                },
                never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                    ".DS_Store",
                    "thumbs.db",
                },
            },
            follow_current_file = true, -- This will find and focus the file in the active buffer every
            -- time the current file is changed while the tree is open.
            group_empty_dirs = true, -- when true, empty folders will be grouped together
            hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
            -- in whatever position is specified in window.position
            -- "open_current",  -- netrw disabled, opening a directory opens within the
            -- window like netrw would, regardless of window.position
            -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
            use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
        }, -- instead of relying on nvim autocmd events.
        buffers = {
            show_unloaded = true,
            window = {
                mappings = {
                    ["bd"] = "buffer_delete",
                    ["<bs>"] = "navigate_up",
                    ["."] = "set_root",
                },
            },
        },
        git_status = {
            window = {
                position = "float",
                mappings = {
                    ["A"] = "git_add_all",
                    ["gu"] = "git_unstage_file",
                    ["ga"] = "git_add_file",
                    ["gr"] = "git_revert_file",
                    ["gc"] = "git_commit",
                    ["gp"] = "git_push",
                    ["gg"] = "git_commit_and_push",
                },
            },
        },
    })
end

function config.satellite()
    require("satellite").setup({
        handlers = {
            gitsigns = {
                enable = true,
            },
            marks = {
                enable = false,
            },
        },
        excluded_filetypes = {
            "packer",
            "neo-tree",
            "norg",
            "neo-tree-popup",
            "dapui_scopes",
            "dapui_stacks",
        },
    })
end

function config.ufo()
    vim.cmd([[packadd promise-async]])
    local ufo = require("ufo")
    local hl = require("utils.ui.highlights")
    local opt, strwidth = vim.opt, vim.api.nvim_strwidth

    local function handler(virt_text, _, end_lnum, width, truncate, ctx)
        local result = {}
        local padding = ""
        local cur_width = 0
        local suffix_width = strwidth(ctx.text)
        local target_width = width - suffix_width

        for _, chunk in ipairs(virt_text) do
            local chunk_text = chunk[1]
            local chunk_width = strwidth(chunk_text)
            if target_width > cur_width + chunk_width then
                table.insert(result, chunk)
            else
                chunk_text = truncate(chunk_text, target_width - cur_width)
                local hl_group = chunk[2]
                table.insert(result, { chunk_text, hl_group })
                chunk_width = strwidth(chunk_text)
                if cur_width + chunk_width < target_width then
                    padding = padding .. (" "):rep(target_width - cur_width - chunk_width)
                end
                break
            end
            cur_width = cur_width + chunk_width
        end

        local end_text = ctx.get_fold_virt_text(end_lnum)
        -- reformat the end text to trim excess whitespace from indentation usually the first item is indentation
        if end_text[1] and end_text[1][1] then
            end_text[1][1] = end_text[1][1]:gsub("[%s\t]+", "")
        end

        table.insert(result, { " ⋯ ", "UfoFoldedEllipsis" })
        vim.list_extend(result, end_text)
        table.insert(result, { padding, "" })
        return result
    end

    opt.foldlevelstart = 99
    opt.sessionoptions:append("folds")

    hl.plugin("ufo", {
        { Folded = { bold = false, italic = false, bg = { from = "Normal", alter = -7 } } },
    })

    lambda.augroup("UfoSettings", {
        {
            event = "FileType",
            pattern = { "norg" },
            command = function()
                ufo.detach()
            end,
        },
    })

    local ft_map = {
        dart = { "lsp", "treesitter" },
    }

    ufo.setup({
        open_fold_hl_timeout = 0,
        fold_virt_text_handler = handler,
        enable_get_fold_virt_text = true,
        preview = { win_config = { winhighlight = "Normal:Normal,FloatBorder:Normal" } },
        provider_selector = function(_, filetype)
            return ft_map[filetype] or { "treesitter", "indent" }
        end,
    })

    vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "open all folds" })
    vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "close all folds" })
    vim.keymap.set("n", "zP", ufo.peekFoldedLinesUnderCursor, { desc = "preview fold" })
end

function config.fold_focus()
    local foldcus = require("foldcus")
    local NS = { noremap = true, silent = true }

    -- Fold multiline comments longer than or equal to 4 lines
    vim.keymap.set("n", "z;", function()
        foldcus.fold(4)
    end, NS)

    -- Fold multiline comments longer than or equal to the number of lines specified by args
    -- e.g. Foldcus 4
    vim.api.nvim_create_user_command("Foldcus", function(args)
        foldcus.fold(tonumber(args.args))
    end, { nargs = "*" })

    -- Delete folds of multiline comments longer than or equal to 4 lines
    vim.keymap.set("n", "z'", function()
        foldcus.unfold(4)
    end, NS)

    -- Delete folds of multiline comments longer than or equal to the number of lines specified by args
    -- e.g. Unfoldcus 4
    vim.api.nvim_create_user_command("Unfoldcus", function(args)
        foldcus.unfold(tonumber(args.args))
    end, { nargs = "*" })
end
function config.blankline()
    vim.opt.termguicolors = true
    vim.opt.list = true

    -- test this for now, not sure if i like this or not .
    -- vim.opt.listchars:append("space:⋅")
    -- vim.opt.listchars:append("eol:↴")
    -- vim.opt.listchars:append("space:⋅")
    -- vim.opt.listchars:append("eol:↴")
    require("indent_blankline").setup({
        enabled = true,
        -- char_list = { "", "┊", "┆", "¦", "|", "¦", "┆", "┊", "" },
        show_foldtext = false,
        -- context_char = "┃",
        -- indent_blankline_context_char_list = { "", "┊", "┆", "¦", "|", "¦", "┆", "┊", "" },
        char = "│", -- ┆ ┊ 
        context_char = "▎",
        char_priority = 12,
        show_current_context = true,
        show_current_context_start = true,
        show_current_context_start_on_current_line = false,
        show_first_indent_level = true,
        filetype_exclude = {
            "dbout",
            "neo-tree-popup",
            "dap-repl",
            "startify",
            "dashboard",
            "log",
            "fugitive",
            "gitcommit",
            "packer",
            "vimwiki",
            "markdown",
            "json",
            "txt",
            "vista",
            "help",
            "NvimTree",
            "git",
            "TelescopePrompt",
            "undotree",
            "flutterToolsOutline",
            "norg",
            "org",
            "orgagenda",
            "", -- for all buffers without a file type
        },
        buftype_exclude = { "terminal", "nofile", "dashboard" },
        context_patterns = {
            "class",
            "function",
            "method",
            "block",
            "list_literal",
            "selector",
            "^if",
            "^table",
            "if_statement",
            "while",
            "for",
        },
    })
    -- useing treesitter instead of char highlight
    -- vim.g.indent_blankline_char_highlight_list =
    -- {"WarningMsg", "Identifier", "Delimiter", "Type", "String", "Boolean"}
end

function config.indentguides()
    require("indent_guides").setup({
        -- put your options in here
        indent_soft_pattern = "\\s",
    })
end

function config.close_buffers()
    require("close_buffers").setup({
        preserve_window_layout = { "this" },
        next_buffer_cmd = function(windows)
            require("bufferline").cycle(1)
            local bufnr = vim.api.nvim_get_current_buf()

            for _, window in ipairs(windows) do
                vim.api.nvim_win_set_buf(window, bufnr)
            end
        end,
    })
    vim.api.nvim_create_user_command("Kwbd", function()
        require("close_buffers").delete({ type = "this" })
    end, { range = true })
end

function config.modes()
    require("modes").setup({
        colors = {
            copy = "#f5c359",
            delete = "#c75c6a",
            insert = "#78ccc5",
            visual = "#9745be",
        },

        -- Set opacity for cursorline and number background
        line_opacity = 0.15,

        -- Enable cursor highlights
        set_cursor = true,

        -- Enable cursorline initially, and disable cursorline for inactive windows
        -- or ignored filetypes
        set_cursorline = true,

        -- Enable line number highlights to match cursorline
        set_number = true,

        -- Disable modes highlights in specified filetypes
        -- Please PR commonly ignored filetypes
        ignore_filetypes = { "NvimTree", "TelescopePrompt", "NeoTree" },
        plugins = {
            presets = {
                operators = false,
            },
        },
    })
end

function config.modicator()
    local modicator = require("modicator")

    print("here")
    modicator.setup({
        line_numbers = true,
        cursorline = false,
        highlights = {
            modes = {
                ["n"] = modicator.get_highlight_fg("CursorLineNr"),
                ["i"] = modicator.get_highlight_fg("Question"),
                ["v"] = modicator.get_highlight_fg("Type"),
                ["V"] = modicator.get_highlight_fg("Type"),
                ["�"] = modicator.get_highlight_fg("Type"),
                ["s"] = modicator.get_highlight_fg("Keyword"),
                ["S"] = modicator.get_highlight_fg("Keyword"),
                ["R"] = modicator.get_highlight_fg("Title"),
                ["c"] = modicator.get_highlight_fg("Constant"),
            },
        },
    })
end

function config.transparent()
    require("transparent").setup({
        enable = false,
        -- additional groups that should be clear
        extra_groups = {
            -- example of akinsho/nvim-bufferline.lua
            "BufferLineTabClose",
            "BufferlineBufferSelected",
            "BufferLineFill",
            "BufferLineBackground",
            "BufferLineSeparator",
            "BufferLineIndicatorSelected",
        },
        -- groups you don't want to clear
        exclude = {},
    })
end

function config.dim()
    require("neodim").setup({
        alpha = 0.5,
        blend_color = "#000000",
        update_in_insert = {
            enable = true,
            delay = 100,
        },
        hide = {
            virtual_text = true,
            signs = true,
            underline = true,
        },
    })
end

function config.tint()
    require("tint").setup({
        tint = -30,
        highlight_ignore_patterns = {
            "WinSeparator",
            "St.*",
            "Comment",
            "Panel.*",
            "Telescope.*",
            "Bqf.*",
        },
        window_ignore_function = function(win_id)
            if vim.wo[win_id].diff or vim.fn.win_gettype(win_id) ~= "" then
                return true
            end
            local buf = vim.api.nvim_win_get_buf(win_id)
            local b = vim.bo[buf]
            local ignore_bt = { "terminal", "prompt", "nofile" }
            local ignore_ft = {
                "neo-tree",
                "packer",
                "diff",
                "toggleterm",
                "Neogit.*",
                "Telescope.*",
                "qf",
            }
            return lambda.any(b.bt, ignore_bt) or lambda.any(b.ft, ignore_ft)
        end,
    })
end

function config.colourutils()
    require("colortils").setup()
end

function config.clock_setup()
    lambda.lazy_load({
        events = "BufEnter",
        augroup_name = "clock",
        condition = function()
            return lambda.config.use_clock and vim.fn.getcwd():match(vim.fn.stdpath("config"))
        end,
        plugin = "clock.nvim",
    })
end

function config.clock()
    local c = require("clock")
    local f = vim.fn

    c.setup({
        border = {
            "🭽",
            "▔",
            "🭾",
            "▕",
            "🭿",
            "▁",
            "🭼",
            "▏",
        },
        row = vim.o.lines - 5,
    })
    if f.getcwd():match(f.stdpath("config")) then
        c.Clock:new():count_up({
            duration = { minutes = 30 },
            threshold = { late = "00:15" }, -- at 15mins the clock will become red
        })
    end
end

function config.dashboard_setup()
    lambda.lazy_load({
        events = "BufEnter",
        augroup_name = "dashboard",
        condition = lambda.config.use_dashboard,
        plugin = "dashboard",
    })
end

function config.dashboard_config()
    vim.g.indentLine_fileTypeExclude = { "dashboard" }
    local home = os.getenv("HOME")
    local db = require("dashboard")
    db.custom_header = {
        "┍━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┑",
        "│ ⣇⣿⠘⣿⣿⣿⡿⡿⣟⣟⢟⢟⢝⠵⡝⣿⡿⢂⣼⣿⣷⣌⠩⡫⡻⣝⠹⢿⣿⣷ │",
        "│ ⡆⣿⣆⠱⣝⡵⣝⢅⠙⣿⢕⢕⢕⢕⢝⣥⢒⠅⣿⣿⣿⡿⣳⣌⠪⡪⣡⢑⢝⣇ │",
        "│ ⡆⣿⣿⣦⠹⣳⣳⣕⢅⠈⢗⢕⢕⢕⢕⢕⢈⢆⠟⠋⠉⠁⠉⠉⠁⠈⠼⢐⢕⢽ │",
        "│ ⡗⢰⣶⣶⣦⣝⢝⢕⢕⠅⡆⢕⢕⢕⢕⢕⣴⠏⣠⡶⠛⡉⡉⡛⢶⣦⡀⠐⣕⢕ │",
        "│ ⡝⡄⢻⢟⣿⣿⣷⣕⣕⣅⣿⣔⣕⣵⣵⣿⣿⢠⣿⢠⣮⡈⣌⠨⠅⠹⣷⡀⢱⢕ │",
        "│ ⡝⡵⠟⠈⢀⣀⣀⡀⠉⢿⣿⣿⣿⣿⣿⣿⣿⣼⣿⢈⡋⠴⢿⡟⣡⡇⣿⡇⡀⢕ │",
        "│ ⡝⠁⣠⣾⠟⡉⡉⡉⠻⣦⣻⣿⣿⣿⣿⣿⣿⣿⣿⣧⠸⣿⣦⣥⣿⡇⡿⣰⢗⢄ │",
        "│ ⠁⢰⣿⡏⣴⣌⠈⣌⠡⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣬⣉⣉⣁⣄⢖⢕⢕⢕ │",
        "│ ⡀⢻⣿⡇⢙⠁⠴⢿⡟⣡⡆⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣵⣵⣿ │",
        "│ ⡻⣄⣻⣿⣌⠘⢿⣷⣥⣿⠇⣿⣿⣿⣿⣿⣿⠛⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿ │",
        "│ ⣷⢄⠻⣿⣟⠿⠦⠍⠉⣡⣾⣿⣿⣿⣿⣿⣿⢸⣿⣦⠙⣿⣿⣿⣿⣿⣿⣿⣿⠟ │",
        "│ ⡕⡑⣑⣈⣻⢗⢟⢞⢝⣻⣿⣿⣿⣿⣿⣿⣿⠸⣿⠿⠃⣿⣿⣿⣿⣿⣿⡿⠁⣠ │",
        "│ ⡝⡵⡈⢟⢕⢕⢕⢕⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⠿⠋⣀⣈⠙ │",
        "│ ⡝⡵⡕⡀⠑⠳⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⢉⡠⡲⡫⡪⡪⡣ │",
        "┕━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┙",
        "                                  ",
        "                                  ",
        "                                  ",
    }
    db.custom_footer = {
        "	",
        "▷ nya-nvim ◁",
    }
    db.hide_statusline = true -- boolean default is true.it will hide statusline in dashboard buffer and auto open in other buffer
    db.hide_tabline = true -- boolean default is true.it will hide tabline in dashboard buffer and auto open in other buffer
    db.custom_center = {
        {
            icon = "  ",
            desc = "Recently latest session                 ",
            shortcut = "SPC s l",
            action = "SessionLoad",
        },
        {
            icon = "  ",
            desc = "Workspaces                              ",
            shortcut = "SPC s l",
            action = "Telescope workspaces",
        },
        {
            icon = "  ",
            desc = "Recently opened files                   ",
            action = "DashboardFindHistory",
            shortcut = "SPC f h",
        },
        {
            icon = "  ",
            desc = "Find  File                              ",
            action = "Telescope find_files find_command=rg,--hidden,--files",
            shortcut = "SPC f f",
        },
        {
            icon = "  ",
            desc = "File Browser                            ",
            action = "Telescope file_browser",
            shortcut = "SPC f b",
        },
        {
            icon = "  ",
            desc = "Find  word                              ",
            action = "Telescope live_grep",
            shortcut = "SPC f w",
        },
        {
            icon = "  ",
            desc = "Open Personal dotfiles                  ",
            action = "Telescope dotfiles",
            shortcut = "SPC f d",
        },
    }
    -- 	{
    -- 	a = { description = { '  Find File                        ' }, command = 'Telescope find_files' },
    -- 	b = { description = { '  Recents                          ' }, command = 'Telescope oldfiles' },
    -- 	c = { description = { '  Find Word                        ' }, command = 'Telescope live_grep' },
    -- 	d = { description = { 'ﱐ  New File                         ' }, command = 'DashboardNewFile' },
    -- 	e = { description = { '  Bookmarks                        ' }, command = 'Telescope marks' },
    -- 	f = { description = { '  Open Help Doc                    ' }, command = 'view ~/.config/nvim/doc/helpdoc.md' },
    -- }
    --
end

function config.dressing()
    -- NOTE: the limit is half the max lines because this is the cursor theme so
    -- unless the cursor is at the top or bottom it realistically most often will
    -- only have half the screen available
    local function get_height(self, _, max_lines)
        local results = #self.finder.results
        local PADDING = 4 -- this represents the size of the telescope window
        local LIMIT = math.floor(max_lines / 2)
        return (results <= (LIMIT - PADDING) and results + PADDING or LIMIT)
    end

    require("utils.ui.highlights").plugin("dressing", { { FloatTitle = { inherit = "Visual", bold = true } } })

    require("dressing").setup({
        input = {
            insert_only = false,
            winblend = 2,
            border = lambda.style.border.type_0,
        },
        select = {
            get_config = function(opts)
                -- center the picker for treesitter prompts
                if opts.kind == "codeaction" then
                    return {
                        backend = "telescope",
                        telescope = require("telescope.themes").get_cursor({
                            layout_config = { height = get_height },
                        }),
                    }
                end
            end,
            backend = "telescope",
            telescope = require("telescope.themes").get_dropdown({
                layout_config = { height = get_height },
            }),
        },
    })
end

function config.noice()
    require("noice").setup({
        popupmenu = {
            enabled = false, -- disable if you use something like cmp-cmdline
        },
        cmdline = {
            view = "cmdline", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
            opts = { buf_options = { filetype = "vim" } }, -- enable syntax highlighting in the cmdline
            menu = "wild", -- @type "popup" | "wild", -- what style of popupmenu do you want to use?
            icons = {
                ["/"] = { icon = " ", hl_group = "DiagnosticWarn" },
                ["?"] = { icon = " ", hl_group = "DiagnosticWarn" },
                [":"] = { icon = " ", hl_group = "DiagnosticInfo", firstc = false },
            },
        },
        history = {
            view = "split",
            opts = { enter = true },
            filter = { event = "msg_show", ["not"] = { kind = { "search_count", "echo" } } },
        },
        throttle = 1000 / 30, -- how frequently does Noice need to check for ui updates? This has no effect when in blocking mode.
        views = {},
        routes = {},
    })
end

function config.illuminate()
    -- default configuration
    require("illuminate").configure({
        -- providers: provider used to get references in the buffer, ordered by priority
        providers = {
            "lsp",
            "treesitter",
            "regex",
        },
        -- delay: delay in milliseconds
        delay = 100,
        -- filetype_overrides: filetype specific overrides.
        -- The keys are strings to represent the filetype while the values are tables that
        -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
        filetype_overrides = {},
        -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
        filetypes_denylist = {
            "dirvish",
            "fugitive",
        },
        -- filetypes_allowlist: filetypes to illuminate, this is overriden by filetypes_denylist
        filetypes_allowlist = {},
        -- modes_denylist: modes to not illuminate, this overrides modes_allowlist
        modes_denylist = {},
        -- modes_allowlist: modes to illuminate, this is overriden by modes_denylist
        modes_allowlist = {},
        -- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
        -- Only applies to the 'regex' provider
        -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
        providers_regex_syntax_denylist = {},
        -- providers_regex_syntax_allowlist: syntax to illuminate, this is overriden by providers_regex_syntax_denylist
        -- Only applies to the 'regex' provider
        -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
        providers_regex_syntax_allowlist = {},
        -- under_cursor: whether or not to illuminate under the cursor
        under_cursor = true,
    })
end

function config.beacon()
    local beacon = require("beacon")
    beacon.setup({
        minimal_jump = 20,
        ignore_buffers = { "terminal", "nofile", "neorg://Quick Actions" },
        ignore_filetypes = {
            "qf",
            "neo-tree",
            "NeogitCommitMessage",
            "NeogitPopup",
            "NeogitStatus",
            "packer",
            "trouble",
        },
    })
    lambda.augroup("BeaconCmds", {
        {
            event = "BufReadPre",
            pattern = "*.norg",
            command = function()
                beacon.beacon_off()
            end,
        },
    })
end

return config
