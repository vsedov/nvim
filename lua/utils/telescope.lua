local telescope = require("telescope")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local resolve = require("telescope.config.resolve")
local make_entry = require("telescope.make_entry")
local previewers = require("telescope.previewers")
local sorters = require("telescope.sorters")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local builtin = require("telescope.builtin")
local state = require("telescope.state")
local action_set = require("telescope.actions.set")
local themes = require("telescope.themes")
local action_layout = require("telescope.actions.layout")
local actions_layout = require("telescope.actions.layout")
local Path = require("plenary.path")
local scan = require("plenary.scandir")
local action_state = require("telescope.actions.state")
local utils = require("telescope.utils")

-- https://github.com/max397574/NeovimConfig/blob/2267d7dfa8a30148516e2f5a6bb0e5ecc5de2c3c/lua/configs/telescope.lua
local function reloader()
    RELOAD("plenary")
    RELOAD("telescope")
    RELOAD("utils.telescope")
end
local function flash(prompt_bufnr)
    if lambda.config.movement.movement_type == "flash" then
        require("flash").jump({
            pattern = "^",
            highlight = { label = { after = { 0, 0 } } },
            search = {
                mode = "search",
                exclude = {
                    function(win)
                        return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
                    end,
                },
            },
            action = function(match)
                local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                picker:set_selection(match.pos[1] - 1)
            end,
        })
    else
        vim.notify(
            "you have reverted back to leap , but you =did not code this up yet, please insert the codeed version of this search"
        )
    end
end
local function rectangular_border(opts)
    return vim.tbl_deep_extend("force", opts or {}, {
        borderchars = {
            prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
            results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
            preview = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" },
        },
    })
end
local open_cmd = "xdg-open"
function dropdown(opts)
    return require("telescope.themes").get_dropdown(rectangular_border(opts))
end

function ivy(opts)
    return require("telescope.themes").get_ivy(vim.tbl_deep_extend("keep", opts or {}, {
        borderchars = {
            preview = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" },
        },
    }))
end
local custom_actions = {}

function custom_actions.send_to_qflist(prompt_bufnr)
    require("telescope.actions").send_to_qflist(prompt_bufnr)
    require("user").qflist.open()
end

function custom_actions.smart_send_to_qflist(prompt_bufnr)
    require("telescope.actions").smart_send_to_qflist(prompt_bufnr)
    require("user").qflist.open()
end

function custom_actions.fzf_multi_select(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local num_selections = table.getn(picker:get_multi_selection())

    if num_selections > 1 then
        -- actions.file_edit throws - context of picker seems to change
        -- actions.file_edit(prompt_bufnr)
        actions.send_selected_to_qflist(prompt_bufnr)
        actions.open_qflist()
    else
        actions.file_edit(prompt_bufnr)
    end
end

-- Amazing Layout taken from https://github.com/max397574/NeovimConfig/blob/2267d7dfa8a30148516e2f5a6bb0e5ecc5de2c3c/lua/configs/telescope.lua
local set_prompt_to_entry_value = function(prompt_bufnr)
    local entry = action_state.get_selected_entry()
    if not entry or not type(entry) == "table" then
        return
    end

    action_state.get_current_picker(prompt_bufnr):reset_prompt(entry.ordinal)
end

local Job = require("plenary.job")
local new_maker = function(filepath, bufnr, opts)
    filepath = vim.fn.expand(filepath)
    Job:new({
        command = "file",
        args = { "--mime-type", "-b", filepath },
        on_exit = function(j)
            local mime_class = vim.split(j:result()[1], "/")[1]
            local mime_type = j:result()[1]
            if
                mime_class == "text"
                or (mime_class == "application" and mime_type ~= "application/x-pie-executable")
            then
                previewers.buffer_previewer_maker(filepath, bufnr, opts)
            else
                -- maybe we want to write something to the buffer here
                vim.schedule(function()
                    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
                end)
            end
        end,
    }):sync()
end

local M = {}
M.multi_selection_open_vsplit = function(prompt_bufnr)
    M._multiopen(prompt_bufnr, "vsplit")
end
M.multi_selection_open_split = function(prompt_bufnr)
    M._multiopen(prompt_bufnr, "split")
end
M.multi_selection_open_tab = function(prompt_bufnr)
    M._multiopen(prompt_bufnr, "tabe")
end
M.multi_selection_open = function(prompt_bufnr)
    M._multiopen(prompt_bufnr, "edit")
end

M.setup = function()
    local icons = lambda.style.icons
    require("telescope").setup({
        defaults = {
            borderchars = {
                prompt = { " ", "▕", "▁", "▏", "▏", "▕", "🭿", "🭼" },
                results = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" },
                preview = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" },
            },
            preview = {
                hide_on_startup = true,
            },
            buffer_previewer_maker = new_maker,
            dynamic_preview_title = fa,
            prompt_prefix = icons.misc.telescope .. " ",
            selection_caret = icons.misc.chevron_right .. " ",
            cycle_layout_list = { "flex", "horizontal", "vertical", "bottom_pane", "center" },
            mappings = {
                n = {
                    s = flash,
                    ["q"] = actions.close,
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-o>"] = actions.select_vertical,
                    ["<C-Q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    ["<C-a>"] = actions.send_to_qflist + actions.open_qflist,
                    ["<C-h>"] = "which_key",
                    ["<C-l>"] = actions_layout.toggle_preview,
                    -- ["<C-y>"] = set_prompt_to_entry_value,
                    ["<C-u>"] = actions.preview_scrolling_up,
                    ["<C-d>"] = actions.preview_scrolling_down,
                    ["<C-f>"] = require("telescope.actions").cycle_history_prev,

                    ["<c-v>"] = custom_actions.multi_selection_open_vsplit,
                    ["<c-S>"] = custom_actions.multi_selection_open_split,
                    ["<c-t>"] = custom_actions.multi_selection_open_tab,

                    ["<C-n>"] = function(prompt_bufnr)
                        local results_win = state.get_status(prompt_bufnr).results_win
                        local height = vim.api.nvim_win_get_height(results_win)
                        action_set.shift_selection(prompt_bufnr, math.floor(height / 2))
                    end,

                    ["<C-s>"] = function(prompt_bufnr)
                        local results_win = state.get_status(prompt_bufnr).results_win
                        local height = vim.api.nvim_win_get_height(results_win)
                        action_set.shift_selection(prompt_bufnr, -math.floor(height / 2))
                    end,

                    ["<cr>"] = custom_actions.multi_selection_open,
                },

                i = {
                    ["<c-v>"] = custom_actions.multi_selection_open_vsplit,
                    ["<c-s>"] = custom_actions.multi_selection_open_split,
                    ["<c-t>"] = custom_actions.multi_selection_open_tab,
                    ["<C-j>"] = actions.move_selection_next,
                    ["<c-o>"] = action_layout.toggle_prompt_position,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-y>"] = set_prompt_to_entry_value,
                    ["<C-o>"] = actions.select_vertical,
                    ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    ["<C-a>"] = actions.send_to_qflist + actions.open_qflist,
                    ["<c-l>"] = flash,
                    ["<C-w>"] = "which_key",
                    ["<C-l>"] = actions_layout.toggle_preview,

                    ["<C-d>"] = actions.preview_scrolling_down,
                    ["<C-u>"] = actions.preview_scrolling_up,

                    ["<C-n>"] = function(prompt_bufnr)
                        local results_win = state.get_status(prompt_bufnr).results_win
                        local height = vim.api.nvim_win_get_height(results_win)
                        action_set.shift_selection(prompt_bufnr, math.floor(height / 2))
                    end,
                    ["<C-p>"] = function(prompt_bufnr)
                        local results_win = state.get_status(prompt_bufnr).results_win
                        local height = vim.api.nvim_win_get_height(results_win)
                        action_set.shift_selection(prompt_bufnr, -math.floor(height / 2))
                    end,
                },
            },
            file_ignore_patterns = {
                "%.jpg",
                "%.jpeg",
                "%.png",
                "%.otf",
                "%.ttf",
                "%.DS_Store",
                "^.git/",
                "^node_modules/",
                "^site-packages/",
                "^abbreviations/",
                "abbreviations/",
                "abbreviations",
            },
            history = {
                path = vim.fn.stdpath("data") .. "/telescope_history.sqlite3",
            },
            layout_strategy = "flex",
            layout_config = {
                horizontal = {
                    preview_width = 0.55,
                },
            },
            extensions = {

                file_browser = {
                    -- theme = "ivy",
                    mappings = {
                        ["i"] = {},
                        ["n"] = {},
                    },
                },
                ast_grep = {
                    command = {
                        "ast-grep",
                        "--json=stream",
                    }, -- must have --json and -p
                    grep_open_files = false, -- search in opened files
                    lang = nil, -- string value, specify language for ast-grep `nil` for default
                },
                frecency = {
                    default_workspace = "CWD",
                    show_unindexed = false, -- Show all files or only those that have been indexed
                    ignore_patterns = { "*.git/*", "*/tmp/*", "*node_modules/*", "*vendor/*" },
                    workspaces = {
                        conf = vim.env.DOTFILES,
                        project = vim.env.PROJECTS_DIR,
                    },
                },
                fzf = {
                    fuzzy = true, -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true, -- override the file sorter
                    case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                },
                egrepify = {
                    prefixes = {
                        ["!"] = {
                            flag = "invert-match",
                        },
                    },
                },
            },
            pickers = {

                buffers = {
                    sort_mru = true,
                    sort_lastused = true,
                    show_all_buffers = true,
                    ignore_current_buffer = true,
                    previewer = false,
                    mappings = {
                        i = { ["<c-x>"] = "delete_buffer" },
                        n = { ["<c-x>"] = "delete_buffer" },
                    },
                },
                oldfiles = dropdown(),
                live_grep = {
                    file_ignore_patterns = { ".git/", "%.svg", "%.lock" },
                    max_results = 2000,
                },
                current_buffer_fuzzy_find = {
                    previewer = false,
                    shorten_path = false,
                },
                colorscheme = {
                    enable_preview = true,
                },
                find_files = {
                    hidden = true,
                },
                keymaps = {
                    layout_config = {
                        height = 18,
                        width = 0.5,
                    },
                },
                git_branches = dropdown(),
                git_bcommits = {
                    layout_config = {
                        horizontal = {
                            preview_width = 0.55,
                        },
                    },
                },
                git_commits = {
                    layout_config = {
                        horizontal = {
                            preview_width = 0.55,
                        },
                    },
                },
                reloader = dropdown(),
            },
            --
        },
    })
end

M._multiopen = function(prompt_bufnr, open_cmd)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local num_selections = table.getn(picker:get_multi_selection())
    local border_contents = picker.prompt_border.contents[1]
    if not (string.find(border_contents, "Find Files") or string.find(border_contents, "Git Files")) then
        actions.select_default(prompt_bufnr)
        return
    end
    if num_selections > 1 then
        vim.cmd("bw!")
        for _, entry in ipairs(picker:get_multi_selection()) do
            vim.cmd(string.format("%s %s", open_cmd, entry.value))
        end
        vim.cmd("stopinsert")
    else
        if open_cmd == "vsplit" then
            actions.file_vsplit(prompt_bufnr)
        elseif open_cmd == "split" then
            actions.file_split(prompt_bufnr)
        elseif open_cmd == "tabe" then
            actions.file_tab(prompt_bufnr)
        else
            actions.file_edit(prompt_bufnr)
        end
    end
end
M.projects = function()
    telescope.extensions.projects.projects()
end

M.project_search = function()
    require("telescope.builtin").find_files({
        previewer = false,
        layout_strategy = "vertical",
        cwd = require("lspconfig").util.root_pattern(".git")(vim.fn.expand("%:p")),
    })
end

--- Plugins to be loaded, lazily
M.neoclip = function()
    local opts = {
        winblend = 10,
        layout_strategy = "flex",
        layout_config = {
            prompt_position = "top",
            width = 0.8,
            height = 0.6,
            horizontal = { width = { padding = 0.15 } },
            vertical = { preview_height = 0.70 },
        },
        borderchars = {
            prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
            results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
            preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        },
        border = {},
        shorten_path = false,
    }
    local dropdown = require("telescope.themes").get_dropdown(opts)
    telescope.extensions.neoclip.default(dropdown)
end

M.refactor = function()
    local opts = {
        sorting_strategy = "ascending",
        scroll_strategy = "cycle",
        prompt_prefix = "  ",
        layout_config = {
            prompt_position = "top",
        },
    }

    telescope.extensions.refactoring.refactors(opts)
end

M.howdoi = function()
    telescope.setup({
        extensions = {
            howdoi = vim.tbl_deep_extend("force", { num_answers = 10 }, require("telescope.themes").get_ivy()),
        },
    })
    reloader()
    telescope.extensions.howdoi.howdoi()
end

M.files = function(opts)
    reloader()

    opts = opts or {}

    vim.fn.system("git status")
    local is_not_git = vim.v.shell_error > 0
    if is_not_git then
        require("telescope.builtin").find_files(opts)
        return
    end

    if opts.cwd then
        opts.cwd = vim.fn.expand(opts.cwd)
    else
        --- Find root of git directory and remove trailing newline characters
        opts.cwd = string.gsub(vim.fn.system("git rev-parse --show-toplevel"), "[\n\r]+", "")
    end

    -- By creating the entry maker after the cwd options,
    -- we ensure the maker uses the cwd options when being created.
    opts.entry_maker = opts.entry_maker or make_entry.gen_from_file(opts)

    pickers
        .new(opts, {
            prompt_title = "Git File",
            finder = finders.new_oneshot_job({ "git", "ls-files", "--recurse-submodules" }, opts),
            previewer = previewers.cat.new(opts),
            sorter = conf.file_sorter(opts),
        })
        :find()
end

M.jump = function()
    reloader()

    builtin.jumplist({ layout_strategy = "vertical" })
end

M.egrep = function()
    local dropdown = require("telescope.themes").get_ivy({})

    require("telescope").extensions.egrepify.egrepify(dropdown)
end

M.buffers = function()
    local dropdown = require("telescope.themes").get_ivy({})
    builtin.buffers(dropdown)
end

M.ag = function(text_to_find)
    text_to_find = text_to_find or vim.fn.input(" Enter item you want to surf: ")
    local default_opts = {
        entry_maker = function(entry)
            local split = vim.split(entry, ":")
            local rel_filepath = split[1]
            local abs_filepath = vim.fn.getcwd() .. "/" .. rel_filepath
            local line_num = tonumber(split[2])
            return {
                value = entry,
                display = function(display_entry)
                    local hl_group
                    local display = utils.transform_path({}, display_entry.value)

                    display, hl_group = utils.transform_devicons(display_entry.path, display, false)

                    if hl_group then
                        return display, { { { 1, 3 }, hl_group } }
                    else
                        return display
                    end
                end,
                ordinal = rel_filepath,
                filename = rel_filepath,
                path = abs_filepath,
                lnum = line_num,
            }
        end,
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                vim.cmd(":e " .. "+" .. selection.lnum .. " " .. selection.path)
            end)
            return true
        end,
    }
    local opts = default_opts

    local args = { "ag", text_to_find }
    pickers
        .new(opts, {
            prompt_title = "Silver Searcher",
            finder = finders.new_oneshot_job(args, opts),
            previewer = conf.grep_previewer(opts),
            sorter = conf.file_sorter(opts),
        })
        :find()
end

M.theme = function(opts)
    return vim.tbl_deep_extend("force", {
        sorting_strategy = "ascending",
        layout_strategy = "flex",
        results_title = false,
        preview_title = false,
        preview = true,
        winblend = 30,
        width = 100,
        results_height = 15,
        results_width = 0.37,
        border = false,
        borderchars = {
            { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
            results = { "─", "│", "─", "│", "├", "┬", "┴", "╰" },
            preview = { "─", "│", "─", "│", "╭", "┤", "╯", "╰" },
        },
    }, opts or {})
end

M.search_only_certain_files = function()
    builtin.find_files({
        find_command = {
            "rg",
            "--files",
            "--type",
            vim.fn.input("Type: "),
        },
    })
end

-- find files in the upper directory YES
M.find_updir = function()
    local up_dir = vim.fn.getcwd():gsub("(.*)/.*$", "%1")
    local opts = {
        cwd = up_dir,
    }

    builtin.find_files(opts)
end

M.folder_grep = function(opts)
    local os_sep = Path.path.sep
    opts = opts or {}
    local data = {}

    scan.scan_dir(vim.loop.cwd(), {
        hidden = opts.hidden,
        only_dirs = true,
        respect_gitignore = opts.respect_gitignore,
        on_insert = function(entry)
            table.insert(data, entry .. os_sep)
        end,
    })

    table.insert(data, 1, "." .. os_sep)

    pickers
        .new(opts, {
            prompt_title = "Folders for Live Grep",
            finder = finders.new_table({ results = data, entry_maker = make_entry.gen_from_file(opts) }),
            previewer = conf.file_previewer(opts),
            sorter = conf.file_sorter(opts),
            attach_mappings = function(prompt_bufnr)
                action_set.select:replace(function()
                    local current_picker = action_state.get_current_picker(prompt_bufnr)
                    local dirs = {}
                    local selections = current_picker:get_multi_selection()
                    if vim.tbl_isempty(selections) then
                        table.insert(dirs, action_state.get_selected_entry().value)
                    else
                        for _, selection in ipairs(selections) do
                            table.insert(dirs, selection.value)
                        end
                    end
                    actions._close(prompt_bufnr, current_picker.initial_mode == "insert")
                    require("telescope.builtin").live_grep({ search_dirs = dirs })
                end)
                return true
            end,
        })
        :find()
end

-- show implementations of the current thingy using language server
M.lsp_implementations = function()
    local opts = {
        layout_strategy = "vertical",
        layout_config = {
            prompt_position = "top",
        },
        sorting_strategy = "ascending",
        ignore_filename = false,
    }
    builtin.lsp_implementations(opts)
end

local function lsp_ref_from_qf(opts)
    opts = opts or {}

    local displayer = entry_display.create({
        -- separator = "▏",
        separator = " ",
        items = {
            { width = 8 },
            { width = 20 },
            { remaining = true },
        },
    })

    local make_display = function(entry)
        -- print("entry:")
        -- dump(entry)
        local filename = require("telescope.utils").transform_path(opts, entry.filename)

        local line_info = {
            -- table.concat({ entry.lnum, entry.col }, ":"),
            "("
                .. entry.lnum
                .. ")",
            "TelescopeResultsLineNr",
        }
        -- if #filename > 20 then
        --     filename = filename:sub(-20, -1)
        -- end

        return displayer({
            line_info,
            -- entry.text:gsub(".* | ", ""),
            -- string.rep(" ", 30 - #vim.trim(entry.text)),
            vim.trim(entry.text),
            filename,
        })
    end

    return function(entry)
        local filename = entry.filename or vim.api.nvim_buf_get_name(entry.bufnr)

        return {
            valid = true,

            value = entry,
            ordinal = (not opts.ignore_filename and filename or "") .. " " .. entry.text,
            display = make_display,

            bufnr = entry.bufnr,
            filename = filename,
            lnum = entry.lnum,
            col = entry.col,
            text = entry.text,
            start = entry.start,
            finish = entry.finish,
        }
    end
end

M.lsp_references = function()
    reloader()
    local opts = themes.get_dropdown({
        -- local opts = themes.get_ivy({
        prompt_title = "~ LSP References ~",
        preview_title = "~ File Preview ~ ",
        results_title = "~ References ~",
        layout_config = {
            -- preview_width = 0.5,
            height = 0.6,
            anchor = "S",
        },
        preview = {
            hide_on_startup = false,
        },
    })
    local params = vim.lsp.util.make_position_params()
    params.context = { includeDeclaration = true }

    vim.lsp.buf_request(0, "textDocument/references", params, function(err, result, _ctx, _config)
        if err then
            vim.api.nvim_err_writeln("Error when finding references: " .. err.message)
            return
        end

        local locations = {}
        if result then
            vim.list_extend(locations, vim.lsp.util.locations_to_items(result) or {})
        end

        if vim.tbl_isempty(locations) then
            return
        end
        -- print("locations:")
        -- dump(locations)

        pickers
            .new(opts, {
                finder = finders.new_table({
                    results = locations,
                    entry_maker = lsp_ref_from_qf(),
                }),
                previewer = conf.qflist_previewer(opts),
                sorter = conf.generic_sorter(opts),
            })
            :find()
    end)
end

M.command_history = function()
    reloader()

    builtin.command_history(M.theme())
end

M.load_dotfiles = function()
    reloader()

    local has_telescope = pcall(require, "telescope.builtin")
    if has_telescope then
        local themes = require("telescope.themes")

        local results = {}
        local dotfiles = require("core.global").home .. "/.dotfiles"
        for file in io.popen('find "' .. dotfiles .. '" -type f'):lines() do
            if not file:find("fonts") then
                table.insert(results, file)
            end
        end

        local global = require("core.global")
        for file in io.popen('find "' .. global.vim_path .. '" -type f'):lines() do
            table.insert(results, file)
        end

        builtin.dotfiles = function(opts)
            opts = themes.get_dropdown({})
            pickers
                .new(opts, {
                    prompt = "dotfiles",
                    finder = finders.new_table({ results = results }),
                    previewer = previewers.cat.new(opts),
                    sorter = sorters.get_generic_fuzzy_sorter(),
                })
                :find()
        end
    end
    builtin.dotfiles()
end

M.git_conflicts = function(opts)
    opts.entry_maker = opts.entry_maker or make_entry.gen_from_file({})

    pickers
        .new(opts, {
            prompt_title = "Git Conflicts",
            finder = finders.new_oneshot_job(
                vim.tbl_flatten({ "git", "diff", "--name-only", "--diff-filter=U" }),
                opts
            ),
            previewer = conf.file_previewer(opts),
            sorter = conf.file_sorter(opts),
        })
        :find()
end

-- Path grep
M.live_grep_in_path = function(path)
    local _path = path or vim.fn.input("Dir: ", "", "dir")
    builtin.live_grep({
        search_dirs = { _path },
    })
end

-- Path grep
M.live_grep = function()
    telescope.extensions.live_grep_args.live_grep_args()
end

M.file_browser = function()
    reloader()
    local opts

    opts = {
        sorting_strategy = "ascending",
        scroll_strategy = "cycle",
    }

    telescope.extensions.file_browser.file_browser(opts)
end

M.find_notes = function()
    reloader()
    local opts = {
        cwd = "~/notes",
        prompt_title = "~ Notes ~",
    }
    builtin.find_files(opts)
end

M.help_tags = function()
    reloader()
    -- local opts = themes.get_ivy({
    local opts = {
        prompt_title = "~ Help Tags ~",
        initial_mode = "insert",
        sorting_strategy = "ascending",
        layout_config = {
            prompt_position = "top",
            preview_width = 0.75,
            -- horizontal = {
            --   preview_width = 0.55,
            --   results_width = 0.8,
            -- },
            -- vertical = {
            --   mirror = false,
            -- },
            -- width = 0.87,
            height = 0.6,
        },
        preview = {
            preview_cutoff = 120,
            preview_width = 80,
            hide_on_startup = false,
        },
    }
    builtin.help_tags(opts)
end

M.code_actions = function()
    local opts = {
        -- winblend = 10,
        prompt_title = "~ Code Actions ~",
        border = false,
        previewer = false,
        shorten_path = false,
    }
    builtin.lsp_code_actions(themes.get_dropdown(opts))
end

M.find_string = function()
    reloader()
    -- local opts = themes.get_ivy({
    local opts = {
        shorten_path = false,
        prompt_title = "~ Live Grep ~",
        file_ignore_patterns = {
            "vendor/*",
            "node_modules",
            "%.jpg",
            "%.jpeg",
            "%.png",
            "%.svg",
            "%.otf",
            "%.ttf",
        },
    }
    -- winblend = 15,
    builtin.live_grep(opts)
end

M.grep_last_search = function(opts)
    reloader()
    opts = opts or {}

    -- \<getreg\>\C
    -- -> Subs out the search things
    local register = vim.fn.getreg("/"):gsub("\\<", ""):gsub("\\>", ""):gsub("\\C", "")

    opts.path_display = { "shorten" }
    opts.word_match = "-w"
    opts.search = register
    opts.prompt_title = "~ Last Search Grep ~"

    builtin.grep_string(opts)
end

M.curbuf = function()
    reloader()
    local opts = {
        -- winblend = 10,
        -- border = false,
        -- previewer = false,
        shorten_path = false,
        prompt_position = "top",
        prompt_title = "~ Current Buffer ~",
        layout_config = { prompt_position = "top", height = 0.4 },
    }
    vim.cmd("normal! m'")
    builtin.current_buffer_fuzzy_find(opts)
end

M.git_status = function()
    reloader()
    local opts = {
        -- layout_strategy = "horizontal",
        git_icons = {
            added = "",
            changed = "",
            copied = "",
            deleted = "",
            renamed = "",
            unmerged = "‡",
            untracked = "",
        },
        border = true,
        prompt_title = "~ Git Status ~",
        preview_title = "~ Diff Preview ~ ",
        results_title = "~ Changed Files ~",
        layout_config = {
            width = 0.99,
            height = 0.69,
            preview_width = 0.7,
            prompt_position = "top",
        },
        preview = {
            hide_on_startup = true,
        },
    }
    require("telescope.builtin").git_status(opts)
end

M.git_diff = function()
    reloader()
    local cwd = vim.fn.expand(vim.loop.cwd())
    local function entry_maker()
        return function(entry)
            local mod, file = string.match(entry, "(..).*%s[->%s]?(.+)")
            return {
                value = file,
                status = mod,
                ordinal = entry,
                display = file,
                path = Path:new({ cwd, file }):absolute(),
            }
        end
    end
    local git_cmd = { "git", "status", "-s", "--", "." }
    local output = require("telescope.utils").get_os_command_output(git_cmd, cwd)
    local opts = {
        -- layout_strategy = "horizontal",
        finder = finders.new_table({
            results = output,
            entry_maker = entry_maker(),
        }),
        border = true,
        prompt_title = "~ Git Diff ~",
        preview_title = "~ Diff ~ ",
        results_title = "~ Changed Files ~",
        preview = {
            hide_on_startup = false,
        },
    }
    require("telescope.builtin").git_status(opts)
end

M.find_files = function()
    local opts = {
        prompt_title = "~ Find Files ~",
        find_command = { "rg", "-g", "!.git", "--files", "--hidden", "--no-ignore" },
        layout_config = {
            prompt_position = "top",
        },
    }
    builtin.find_files(opts)
end

---------------------------------------------------------------------------------------------------------------------

local function enter(prompt_bufnr)
    local selected = action_state.get_selected_entry()
    local cmd = "colorscheme " .. selected[1]
    vim.cmd(cmd)
    local nvimColor = "vim.cmd([[colorscheme " .. " " .. selected[1] .. "]])"
    vim.fn.jobstart(nvimColor)
    actions.close(prompt_bufnr)
end

local function next_color(prompt_bufnr)
    actions.move_selection_next(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    local cmd = "colorscheme " .. selection[1]
    vim.cmd(cmd)
end

local function prev_color(prompt_bufnr)
    actions.move_selection_previous(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    local cmd = "colorscheme " .. selection[1]
    vim.cmd(cmd)
end

local function preview(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    local cmd = "colorscheme " .. selection[1]
    vim.cmd(cmd)
end

M.colorscheme = function()
    -- loader("tokyodark.nvim tokyonight.nvim")
    local before_color = vim.api.nvim_exec("colorscheme", true)
    local need_restore = true

    local colors = { before_color }
    if not vim.tbl_contains(colors, before_color) then
        table.insert(colors, 1, before_color)
    end

    colors = vim.list_extend(
        colors,
        vim.tbl_filter(function(color)
            return color ~= before_color
        end, vim.fn.getcompletion("themer", "color"))
    )
    local opts = {
        prompt_title = "Themer Finder",
        results_title = "Change colorscheme",
        path_display = { "smart" },
        finder = finders.new_table({
            results = colors,
        }),
        prompt_position = "bottom",
        previewer = false,
        winblend = 0,
        layout_config = {
            prompt_position = "bottom", -- top bottom
        },
        attach_mappings = function(prompt_bufnr, map)
            map("i", "<cr>", enter)

            map("i", "<S-Tab>", prev_color)
            map("i", "<Tab>", next_color)

            map("i", "k", prev_color)
            map("i", "j", next_color)

            map("n", "p", preview)
            map("n", "<cr>", enter)

            return true
        end,
        sorter = require("telescope.config").values.generic_sorter({}),
    }
    local colorschemes = pickers.new(themes.get_ivy(), opts)
    colorschemes:find()
end

M.devdocs_ft = function()
    local input = vim.fn.input("Search String: ")
    if input == nil or input == "" then
        return
    end
    local input_with_filetype = vim.bo.filetype .. " " .. input
    vim.fn.jobstart(string.format("%s 'https://devdocs.io/#q=%s'", open_cmd, input_with_filetype))
end

M.devdocs_search = function()
    local input = vim.fn.input("Search String: ")
    vim.fn.jobstart(string.format("%s 'https://devdocs.io/#q=%s'", open_cmd, input))
end

M.google_search = function()
    local input = vim.fn.input("Search String: ")
    if input == nil or input == "" then
        return
    end
    local path = "https://www.google.com/search?q=" .. input
    vim.fn.jobstart({ open_cmd, path }, { detach = true })
end

return M
