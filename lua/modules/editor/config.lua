local config = {}
function config.norg()
    require("modules.editor.neorg")
end

function config.acc_jk()
    require("accelerated-jk").setup({
        mode = "time_driven",
        enable_deceleration = false,
        acceleration_limit = 150,
        acceleration_table = { 7, 12, 17, 21, 24, 26, 28, 30 },
        deceleration_table = { { 150, 9999 } },
    })
    vim.keymap.set("n", "j", "<Plug>(accelerated_jk_gj)", {})
    vim.keymap.set("n", "k", "<Plug>(accelerated_jk_gk)", {})
end

function config.setup_yanky()
    local default_keymaps = {
        { "n", "y", "<Plug>(YankyYank)" },
        { "x", "y", "<Plug>(YankyYank)" },

        { "n", "p", "<Plug>(YankyPutAfter)" },
        { "n", "P", "<Plug>(YankyPutBefore)" },

        { "x", "p", "<Plug>(YankyPutAfter)" },
        { "x", "P", "<Plug>(YankyPutBefore)" },

        { "n", "gp", "<Plug>(YankyGPutAfter)" },
        { "n", "gP", "<Plug>(YankyGPutBefore)" },

        { "x", "gp", "<Plug>(YankyGPutAfter)" },
        { "x", "gP", "<Plug>(YankyGPutBefore)" },

        { "n", "<Leader>n", "<Plug>(YankyCycleForward)" },
        { "n", "<Leader>N", "<Plug>(YankyCycleBackward)" },
    }
    for _, m in ipairs(default_keymaps) do
        vim.keymap.set(m[1], m[2], m[3], {})
    end
end

function config.config_yanky()
    local mapping = require("yanky.telescope.mapping")
    require("yanky").setup({
        ring = {
            history_length = 50,
            storage = "shada",
            sync_with_numbered_registers = true,
        },
        picker = {
            telescope = {
                mappings = {
                    default = mapping.put("p"),
                    i = {
                        ["<c-p>"] = mapping.put("p"),
                        ["<c-k>"] = mapping.put("P"),
                        ["<c-x>"] = mapping.delete(),
                    },
                    n = {
                        p = mapping.put("p"),
                        P = mapping.put("P"),
                        d = mapping.delete(),
                    },
                },
            },
        },
        system_clipboard = {
            sync_with_ring = true,
        },
        highlight = {
            on_put = true,
            on_yank = true,
            timer = 500,
        },
        preserve_cursor_position = {
            enabled = true,
        },
    })
    require("telescope").load_extension("yank_history")
    vim.keymap.set("n", "<leader>yu", "<cmd>Telescope yank_history<cr>", {})
end

function config.comment()
    require("Comment").setup({
        padding = true,
        sticky = true,
        ignore = nil,
        mappings = {
            basic = true,
            extra = true,
            extended = true,
        },
        pre_hook = function(ctx)
            local U = require("Comment.utils")

            local location = nil
            if ctx.ctype == U.ctype.block then
                location = require("ts_context_commentstring.utils").get_cursor_location()
            elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                location = require("ts_context_commentstring.utils").get_visual_start_location()
            end

            return require("ts_context_commentstring.internal").calculate_commentstring({
                key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
                location = location,
            })
        end,
        post_hook = function(ctx)
            -- lprint(ctx)
            if ctx.range.scol == -1 then
                -- do something with the current line
            else
                -- print(vim.inspect(ctx), ctx.range.srow, ctx.range.erow, ctx.range.scol, ctx.range.ecol)
                if ctx.range.ecol > 400 then
                    ctx.range.ecol = 1
                end
                if ctx.cmotion > 1 then
                    -- 322 324 0 2147483647
                    vim.fn.setpos("'<", { 0, ctx.range.srow, ctx.range.scol })
                    vim.fn.setpos("'>", { 0, ctx.range.erow, ctx.range.ecol })
                    vim.cmd([[exe "norm! gv"]])
                end
            end
        end,
    })
end

function config.comment_box()
    require("comment-box").setup({
        box_width = 70, -- width of the boxex
        borders = { -- symbols used to draw a box
            top = "─",
            bottom = "─",
            left = "│",
            right = "│",
            top_left = "╭",
            top_right = "╮",
            bottom_left = "╰",
            bottom_right = "╯",
        },
        line_width = 70, -- width of the lines
        line = { -- symbols used to draw a line
            line = "─",
            line_start = "─",
            line_end = "─",
        },
        outer_blank_lines = false, -- insert a blank line above and below the box
        inner_blank_lines = false, -- insert a blank line above and below the text
        line_blank_line_above = false, -- insert a blank line above the line
        line_blank_line_below = false, -- insert a blank line below the line
    })

    local keymap = vim.keymap.set
    local cb = require("comment-box")

    keymap({ "n", "v" }, "<Leader>cb", cb.lbox, {})
    keymap({ "n", "v" }, "<Leader>cc", cb.cbox, {})

    keymap("n", "<Leader>cl", cb.line, {})
    keymap("i", "<M-p>", cb.line, {})
end

function config.winshift()
    require("winshift").setup({
        highlight_moving_win = true, -- Highlight the window being moved
        focused_hl_group = "Visual", -- The highlight group used for the moving window
        moving_win_options = {
            wrap = false,
            cursorline = false,
            cursorcolumn = false,
            colorcolumn = "",
        },
        window_picker_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        window_picker_ignore = {
            -- This table allows you to indicate to the window picker that a window
            -- should be ignored if its buffer matches any of the following criteria.
            filetype = { -- List of ignored file types
                "NvimTree",
            },
            buftype = { -- List of ignored buftypes
                "terminal",
                "quickfix",
            },
            bufname = { -- List of regex patterns matching ignored buffer names
                [[.*foo/bar/baz\.qux]],
            },
        },
    })
end
function config.neoscroll()
    require("cinnamon").setup({
        extra_keymaps = true,
        scroll_limit = 150,
    })
end

function config.discord()
    --i don\'t want to deal with vscode , The One True Text Editor
    -- Editor For The True Traditionalist
    require("presence"):setup({
        -- General options
        auto_update = true, -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
        neovim_image_text = "Editor For The True Traditionalist", -- Text displayed when hovered over the Neovim image
        main_image = "file", -- Main image display (either "neovim" or "file")
        client_id = "793271441293967371", -- Use your own Discord application client id (not recommended)
        log_level = nil, -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
        debounce_timeout = 10, -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
        enable_line_number = true, -- Displays the current line number instead of the current project
        blacklist = {}, -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
        buttons = true, -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
        file_assets = {}, -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)

        -- Rich Presence text options
        editing_text = "Editing %s", -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
        file_explorer_text = "Browsing %s", -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
        git_commit_text = "Committing changes", -- Format string rendered when committing changes in git (either string or function(filename: string): string)
        plugin_manager_text = "Managing plugins", -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
        reading_text = "Reading %s", -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
        workspace_text = "Working on %s", -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
        line_number_text = "Line %s out of %s", -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
    })
end

function config.dial()
    local dial = require("dial.map")
    local augend = require("dial.augend")
    require("dial.config").augends:register_group({
        -- default augends used when no group name is specified
        default = {
            augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
            augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
            augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
        },

        -- augends used when group with name `mygroup` is specified
        mygroup = {
            augend.integer.alias.decimal,
            augend.constant.alias.bool, -- boolean value (true <-> false)
            augend.date.alias["%m/%d/%Y"], -- date (02/19/2022, etc.)
        },
    })
    local map = vim.keymap.set
    map("n", "<C-a>", dial.inc_normal(), { remap = false })
    map("n", "<C-x>", dial.dec_normal(), { remap = false })
    map("v", "<C-a>", dial.inc_visual(), { remap = false })
    map("v", "<C-x>", dial.dec_visual(), { remap = false })
    map("v", "g<C-a>", dial.inc_gvisual(), { remap = false })
    map("v", "g<C-x>", dial.dec_gvisual(), { remap = false })
end

function config.hlargs()
    require("hlargs").setup({
        excluded_argnames = {
            declarations = { "use", "use_rocks", "_" },
            usages = {
                lua = { "self", "use", "use_rocks", "_" },
            },
        },
    })
end
return config
