local config = {}

function config.refactor()
    local refactor = require("refactoring")

    refactor.setup({
        prompt_func_return_type = {
            go = true,
            java = true,

            cpp = false,
            c = false,
            h = false,
            hpp = false,
            cxx = false,
        },
        prompt_func_param_type = {
            go = false,
            java = false,
            cpp = false,
            c = false,
            h = false,
            hpp = false,
            cxx = false,
        },

        print_var_statements = {
            python = {
                'ic(f"{ %s }")',
            },
        },
    })

    lprint("refactor")
    _G.ts_refactors = function()
        -- telescope refactoring helper
        local function _refactor(prompt_bufnr)
            local content = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
            require("telescope.actions").close(prompt_bufnr)
            require("refactoring").refactor(content.value)
        end

        require("telescope.pickers")
            .new({}, {
                prompt_title = "refactors",
                finder = require("telescope.finders").new_table({
                    results = require("refactoring").get_refactors(),
                }),
                sorter = require("telescope.config").values.generic_sorter({}),
                attach_mappings = function(_, map)
                    map("i", "<CR>", _refactor)
                    map("n", "<CR>", _refactor)
                    return true
                end,
            })
            :find()
    end
end

function config.debugprint()
    require("debugprint").setup({
        create_keymaps = true,
    })

    vim.keymap.set(
        "n",
        "dvl",
        "<cmd>lua require('debugprint').debugprint({ ignore_treesitter = true, variable = true })<CR>",
        { noremap = true, desc = { "Debug print var above" } }
    )
    vim.keymap.set(
        "n",
        "dvl",
        "<cmd>lua require('debugprint').debugprint({ ignore_treesitter = true, above = true, variable = true })<CR>",
        { noremap = true, desc = { "Debug print var above" } }
    )
end

function config.code_runner()
    require("code_runner").setup({
        mode = "float",
        -- Commands used with 'Jaq'

        -- Uses external commands such as 'g++' and 'cargo'
        filetype = {
            javascript = "node",
            java = "cd $dir && javac $dir && java $fileName",
            c = "gcc $file -o $dir && ./$fileNameWithoutExt",
            cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
            python = "cd $dir && poetry run python $fileName ",
        },
    })
end

function config.trouble()
    require("trouble").setup({})
end

function config.dev_comments()
    require("dev_comments").setup({
        -- Enables vim.notify messages
        debug = false,
        -- Creates <Plug> mappings
        default_mappings = true,
        -- Create user commands
        default_commands = true,
        -- Each call of dev-comments is cached
        -- Play around with the reset autocommands for more aggressive caching
        cache = {
            enabled = true,
            reset_autocommands = { "BufWritePost", "BufWinEnter" },
        },
        -- Improves performance when searching in a large directory
        -- Requires ripgrep or grep
        pre_filter = {
            -- If search fails, uses plenary scandir (very slow)
            fallback_to_plenary = true,
        },
        -- Highlight for the tag in picker (not in buffer)
        highlight = {
            tags = {
                ["TODO"] = "TSWarning",
                ["NOTE"] = "TSWarning",
                ["PERF"] = "TSWarning",
                ["HACK"] = "TSWarning",
                ["WARNING"] = "TSWarning",
                ["OPTIM"] = "TSWarning",
                ["TRIAL"] = "TSWarning",
                ["REVISIT"] = "TSDanger",
                ["FIXME"] = "TSDanger",
                ["XXX"] = "TSDanger",
                ["BUG"] = "TSDanger",
            },
            -- Used if lookup fails for a given tag
            fallback = "TSNote",
        },
    })

    -- <Plug> keymaps
    vim.keymap.set("n", "<Plug>DevCommentsTelescopeCurrent", function()
        require("telecope").extensions.dev_comments.current({})
    end, { silent = true })
    vim.keymap.set("n", "<Plug>DevCommentsTelescopeOpen", function()
        require("telecope").extensions.dev_comments.open({})
    end, { silent = true })
    vim.keymap.set("n", "<Plug>DevCommentsTelescopeAll", function()
        require("telecope").extensions.dev_comments.open({})
    end, { silent = true })
    vim.keymap.set("n", "<Plug>DevCommentsCyclePrev", function()
        require("dev_comments.cycle").goto_prev()
    end, { silent = true })
    vim.keymap.set("n", "<Plug>DevCommentsCycleNext", function()
        require("dev_comments.cycle").goto_next()
    end, { silent = true })

    -- Keybinds
    vim.keymap.set("n", "[w", "<Plug>DevCommentsCyclePrev")
    vim.keymap.set("n", "]w", "<Plug>DevCommentsCycleNext")
end

function config.luadev()
    vim.cmd([[vmap <leader><leader>lr <Plug>(Luadev-Run)]])
end

function config.luapad()
    require("luapad").setup({
        count_limit = 150000,
        error_indicator = true,
        eval_on_move = true,
        error_highlight = "WarningMsg",
        on_init = function()
            print("Hello from Luapad!")
        end,
        context = {
            the_answer = 42,
            shout = function(str)
                return (string.upper(str) .. "!")
            end,
        },
    })
end

function config.dap_config()
    require("modules.lang.dap.init").config()
end

function config.dapui()
    require("modules.lang.dap.init").dapui()
end

function config.neotest()
    vim.cmd([[packadd neotest-python]])
    vim.cmd([[packadd neotest-plenary]])
    vim.cmd([[packadd neotest-vim-test]])
    vim.cmd([[packadd overseer.nvim]])

    local add_cmd = vim.api.nvim_create_user_command

    require("neotest").setup({
        adapters = {
            require("neotest-python")({
                dap = { justMyCode = true },
            }),
            require("neotest-plenary"),
            require("neotest-vim-test")({
                ignore_file_types = { "python", "vim", "lua" },
            }),
        },
        diagnostic = {
            enabled = true,
        },
        consumers = {
            overseer = require("neotest.consumers.overseer"),
        },
        overseer = {
            enabled = true,
            -- When this is true (the default), it will replace all neotest.run.* commands
            force_default = true,
        },
        highlights = {
            adapter_name = "NeotestAdapterName",
            border = "NeotestBorder",
            dir = "NeotestDir",
            expand_marker = "NeotestExpandMarker",
            failed = "NeotestFailed",
            file = "NeotestFile",
            focused = "NeotestFocused",
            indent = "NeotestIndent",
            namespace = "NeotestNamespace",
            passed = "NeotestPassed",
            running = "NeotestRunning",
            skipped = "NeotestSkipped",
            test = "NeotestTest",
        },
        icons = {
            child_indent = "│",
            child_prefix = "├",
            collapsed = "─",
            expanded = "╮",
            failed = "✖",
            final_child_indent = " ",
            final_child_prefix = "╰",
            non_collapsible = "─",
            passed = "✔",
            running = "🗘",
            skipped = "ﰸ",
            unknown = "?",
        },
        output = {
            enabled = true,
            open_on_run = "short",
        },
        run = {
            enabled = true,
        },
        status = {
            enabled = true,
        },
        strategies = {
            integrated = {
                height = 40,
                width = 120,
            },
        },
        summary = {
            enabled = true,
            expand_errors = true,
            follow = true,
            mappings = {
                attach = "a",
                expand = { "<CR>", "<2-LeftMouse>" },
                expand_all = "e",
                jumpto = "i",
                output = "o",
                run = "r",
                short = "O",
                stop = "u",
            },
        },
    })

    -- cmd = { "TestNear", "TestCurrent", "TestSummary", "TestOutput", "TestStrat" , "TestStop"},
    -- test nearest file
    add_cmd("TestNear", function()
        require("neotest").run.run()
    end, { force = true })

    add_cmd("TestCurrent", function()
        require("neotest").run.run(vim.fn.expand("%"))
    end, { force = true })

    add_cmd("TestSummary", function()
        require("neotest").summary.toggle()
    end, { force = true })

    add_cmd("TestOutput", function()
        require("neotest").output.open({ enter = true })
    end, { force = true })

    add_cmd("TestStrat", function(args)
        local options = { "dap", "integrated" }
        if vim.tbl_contains(options, args.arg) then
            require("neotest").run.run({ strategy = args.args })
        else
            require("neotest").run.run({ strategy = "integrated" })
        end
    end, {
        force = true,
        nargs = 1,
    })

    add_cmd("TestStop", function()
        require("neotest").run.stop()
    end, { force = true })

    add_cmd("TestAttach", function()
        require("neotest").run.attach()
    end, { force = true })
end

function config.overseer()
    require("modules.lang.overseer")
end

function config.coverage()
    require("coverage").setup()
end

function config.python_dev()
    require("py").setup({
        leader = "<leader><leader>",
        mappings = false,
        taskipy = true,
        poetry_install_every = 1,
        ipython_in_vsplit = 1,
        ipython_auto_install = 1,
        ipython_auto_reload = 1,
        ipython_send_imports = 1,
        envrc = {
            "layout_poetry",
            "export PYTHONPATH=$(pwd)",
            '#eval "$(register-python-argcomplete cz)"',
        },
        use_direnv = true,
    })
end

function config.goto_preview()
    local telescope = require("telescope.themes")

    require("goto-preview").setup({
        width = 80, -- Width of the floating window
        height = 15, -- Height of the floating window
        border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }, -- Border characters of the floating window
        default_mappings = false, -- Bind default mappings
        debug = false, -- Print debug information
        opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
        resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
        post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
        references = { -- Configure the telescope UI for slowing the references cycling window.
            telescope = {
                require("telescope.themes").get_dropdown({
                    winblend = 15,
                    layout_config = {
                        prompt_position = "top",
                        width = 64,
                        height = 15,
                    },
                    border = {},
                    previewer = false,
                    shorten_path = false,
                }),
            },
        },
        -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
        focus_on_open = true, -- Focus the floating window when opening it.
        dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
        force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
        bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
    })
    vim.keymap.set("n", "gt", function()
        require("goto-preview").goto_preview_definition()
    end, { desc = "goto def", noremap = true })

    vim.keymap.set("n", "gi", function()
        require("goto-preview").goto_preview_implementation()
    end, { desc = "goto imp", noremap = true })

    vim.keymap.set("n", "gR", function()
        require("goto-preview").goto_preview_references()
    end, { desc = "goto referece", noremap = true })

    vim.keymap.set("n", "gC", function()
        require("goto-preview").close_all_win()
    end, { desc = "goto close all", noremap = true })
end

function config.regexplainer()
    vim.cmd([[packadd nui.nvim]])
    require("regexplainer").setup({
        -- 'narrative'
        mode = "narrative", -- TODO: 'ascii', 'graphical'

        -- automatically show the explainer when the cursor enters a regexp
        auto = false,

        -- filetypes (i.e. extensions) in which to run the autocommand
        filetypes = {
            "html",
            "js",
            "cjs",
            "mjs",
            "ts",
            "jsx",
            "tsx",
            "cjsx",
            "mjsx",
            "go",
            "lua",
            "vim",
            "python",
        },

        mappings = {
            toggle = "<localleader><localleader>",
        },

        narrative = {
            separator = "\n",
        },
    })
end

return config
