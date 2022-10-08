local vim = vim
local fn = vim.fn
local api = vim.api

local function replace_termcodes(str)
    return api.nvim_replace_termcodes(str, true, true, true)
end

vim.keymap.set({ "n", "v", "o", "i", "c" }, "<Plug>(StopHL)", 'execute("nohlsearch")[-1]', { expr = true })

local function stop_hl()
    if vim.v.hlsearch == 0 or api.nvim_get_mode().mode ~= "n" then
        return
    end
    api.nvim_feedkeys(replace_termcodes("<Plug>(StopHL)"), "m", false)
end

local function hl_search()
    local col = api.nvim_win_get_cursor(0)[2]
    local curr_line = api.nvim_get_current_line()
    local ok, match = pcall(fn.matchstrpos, curr_line, fn.getreg("/"), 0)
    if not ok then
        return
    end
    local _, p_start, p_end = unpack(match)
    -- if the cursor is in a search result, leave highlighting on
    if col < p_start or col > p_end then
        stop_hl()
    end
end

local save_excluded = {
    "neo-tree",
    "neo-tree-popup",
    "lua.luapad",
    "gitcommit",
    "NeogitCommitMessage",
}
local function can_save()
    return lambda.empty(fn.win_gettype())
        and lambda.empty(vim.bo.buftype)
        and not lambda.empty(vim.bo.filetype)
        and vim.bo.modifiable
        and not vim.tbl_contains(save_excluded, vim.bo.filetype)
end

lambda.augroup("VimrcIncSearchHighlight", {
    {
        event = { "CursorMoved" },
        command = function()
            hl_search()
        end,
    },
    {
        event = { "InsertEnter" },
        command = function()
            stop_hl()
        end,
    },
    {
        event = { "OptionSet" },
        pattern = { "hlsearch" },
        command = function()
            vim.schedule(function()
                vim.cmd.redrawstatus()
            end)
        end,
    },
    {
        event = "RecordingEnter",
        command = function()
            vim.opt.hlsearch = false
        end,
    },
    {
        event = "RecordingLeave",
        command = function()
            vim.opt.hlsearch = true
        end,
    },
})

local smart_close_filetypes = {
    "help",
    "git-status",
    "git-log",
    "gitcommit",
    "dbui",
    "fugitive",
    "fugitiveblame",
    "LuaTree",
    "log",
    "tsplayground",
    "qf",
    "startuptime",
    "lspinfo",
    "neotest-summary",
}

local smart_close_buftypes = {} -- Don't include no file buffers as diff buffers are nofile

local function smart_close()
    if fn.winnr("$") ~= 1 then
        api.nvim_win_close(0, true)
    end
end

lambda.augroup("SmartClose", {
    {
        -- Auto open grep quickfix window
        event = { "QuickFixCmdPost" },
        pattern = { "*grep*" },
        command = "cwindow",
    },
    {
        -- Close certain filetypes by pressing q.
        event = { "FileType" },
        pattern = "*",
        command = function()
            local is_unmapped = fn.hasmapto("q", "n") == 0

            local is_eligible = is_unmapped
                or vim.wo.previewwindow
                or vim.tbl_contains(smart_close_buftypes, vim.bo.buftype)
                or vim.tbl_contains(smart_close_filetypes, vim.bo.filetype)

            if is_eligible then
                vim.keymap.set("n", "q", smart_close, { buffer = 0, nowait = true })
            end
        end,
    },
    {
        -- Close quick fix window if the file containing it was closed
        event = { "BufEnter" },
        pattern = "*",
        command = function()
            if fn.winnr("$") == 1 and vim.bo.buftype == "quickfix" then
                api.nvim_buf_delete(0, { force = true })
            end
        end,
    },
    {
        -- automatically close corresponding loclist when quitting a window
        event = { "QuitPre" },
        pattern = "*",
        nested = true,
        command = function()
            if vim.bo.filetype ~= "qf" then
                vim.cmd("silent! lclose")
            end
        end,
    },
})
lambda.augroup("TextYankHighlight", {
    {
        -- don't execute silently in case of errors
        event = { "TextYankPost" },
        pattern = "*",
        command = function()
            vim.highlight.on_yank({
                timeout = 200,
                on_visual = false,
                higroup = "Visual",
            })
        end,
    },
})

lambda.augroup("Utilities", {
    {
        -- @source: https://vim.fandom.com/wiki/Use_gf_to_open_a_file_via_its_URL
        event = { "BufReadCmd" },
        pattern = { "file:///*" },
        nested = true,
        command = function(args)
            vim.cmd.bdelete({ bang = true })
            vim.cmd.edit(vim.uri_to_fname(args.file))
        end,
    },
    {
        event = { "FileType" },
        pattern = { "gitcommit", "gitrebase" },
        command = "set bufhidden=delete",
    },
    {
        event = { "FileType" },
        pattern = {
            "norg",
            "NeogitCommitMessage",
            "markdown",
        },
        -- NOTE: setting spell only works using opt_local otherwise it leaks into subsequent windows        -- command = function(args)
        --     vim.opt_local.spell = vim.api.nvim_buf_line_count(args.buf) < 8000
        -- end,
        command = function(args)
            vim.opt_local.spell = true
        end,
    },
    {
        event = { "BufWritePre", "FileWritePre" },
        pattern = { "*" },
        command = "silent! call mkdir(expand('<afile>:p:h'), 'p')",
    },
    {
        event = { "BufLeave" },
        pattern = { "*" },
        command = function()
            if can_save() then
                vim.cmd.update({ mods = { silent = true } })
            end
        end,
    },

    {
        event = { "BufWritePost" },
        pattern = { "*" },
        nested = true,
        command = function()
            if lambda.empty(vim.bo.filetype) or fn.exists("b:ftdetect") == 1 then
                vim.cmd([[
            unlet! b:ftdetect
            filetype detect
            echom 'Filetype set to ' . &ft
          ]])
            end
        end,
    },
})

lambda.augroup("buffer", {
    { event = { "BufRead", "BufNewFile" }, pattern = "*.norg", command = "setlocal filetype=norg" },
    { event = { "BufEnter", "BufWinEnter" }, pattern = "*.norg", command = [[set foldlevel=1000]] },
    { event = { "BufNewFile", "BufRead", "BufWinEnter" }, pattern = "*.tex", command = [[set filetype=tex]] },
    -- Reload vim config automatically
    {
        event = "BufWritePost",
        pattern = [[$VIM_PATH/{*.vim,*.yaml,vimrc}]],
        command = [[source $MYVIMRC | redraw]],
        nested = true,
    },

    -- -- Reload Vim script automatically if setlocal autoread
    {
        event = { "BufWritePost", "FileWritePost" },
        pattern = "*.vim",
        command = [[ if &l:autoread > 0 | source <afile> | echo 'source ' . bufname('%') | endif]],
        nested = true,
    },
    {
        event = "BufWritePre",
        pattern = { "/tmp/*", "COMMIT_EDITMSG", "MERGE_MSG", "*.tmp", "*.bak" },
        command = function()
            vim.opt_local.undofile = false
        end,
    },

    {
        event = "BufWritePre",
        pattern = "*",
        command = function()
            local function auto_mkdir(dir, force)
                if
                    vim.fn.empty(dir) == 1
                    or string.match(dir, "^%w%+://")
                    or vim.fn.isdirectory(dir) == 1
                    or string.match(dir, "^suda:")
                then
                    return
                end
                if not force then
                    vim.fn.inputsave()
                    local result = vim.fn.input(string.format('"%s" does not exist. Create? [y/N]', dir), "")
                    if vim.fn.empty(result) == 1 then
                        print("Canceled")
                        return
                    end
                    vim.fn.inputrestore()
                end
                vim.fn.mkdir(dir, "p")
            end

            auto_mkdir(vim.fn.expand("%:p:h"), vim.v.cmdbang)
        end,
        nested = false,
    },
})

local activate_spelling = {
    "txt",
    "norg",
    "tex",
    "md",
}

lambda.augroup("WindowBehaviours", {
    {
        -- map q to close command window on quit
        event = { "CmdwinEnter" },
        pattern = { "*" },
        command = "nnoremap <silent><buffer><nowait> q <C-W>c",
    },
    -- Automatically jump into the quickfix window on open
    {
        event = { "QuickFixCmdPost" },
        pattern = { "[^l]*" },
        nested = true,
        command = "cwindow",
    },
    {
        event = { "QuickFixCmdPost" },
        pattern = { "l*" },
        nested = true,
        command = "lwindow",
    },
    {
        event = { "BufWinEnter" },
        command = function(args)
            if vim.wo.diff then
                vim.diagnostic.disable(args.buf)
            end
        end,
    },
    {
        event = { "BufWinLeave" },
        command = function(args)
            if vim.wo.diff then
                vim.diagnostic.enable(args.buf)
            end
        end,
    },

    { event = "CmdLineEnter", pattern = "*", command = [[set nosmartcase]] },
    { event = "CmdLineLeave", pattern = "*", command = [[set smartcase]] },

    -- Force write shada on leaving nvim
    {
        event = "VimLeave",
        pattern = "*",
        command = [[if has('nvim') | wshada! | else | wviminfo! | endif]],
    },
    {
        event = "VimEnter",
        pattern = "*",
        command = function()
            if vim.fn.bufname("%") ~= "" then
                return
            end
            local byte = vim.fn.line2byte(vim.fn.line("$") + 1)
            if byte ~= -1 or byte > 1 then
                return
            end
            vim.bo.buftype = "nofile"
            vim.bo.swapfile = false
            vim.bo.undofile = false
            vim.bo.fileformat = "unix"
        end,
    },
})

lambda.augroup("CheckOutsideTime", {
    {
        -- automatically check for changed files outside vim
        event = { "WinEnter", "BufWinEnter", "BufWinLeave", "BufRead", "BufEnter", "FocusGained" },
        pattern = "*",
        command = "silent! checktime",
    },
})

--- automatically clear commandline messages after a few seconds delay
--- source: http://unix.stackexchange.com/a/613645
---@return function
local function clear_commandline()
    --- Track the timer object and stop any previous timers before setting
    --- a new one so that each change waits for 10secs and that 10secs is
    --- deferred each time
    local timer
    return function()
        if timer then
            timer:stop()
        end
        timer = vim.defer_fn(function()
            if fn.mode() == "n" then
                vim.cmd([[echon '']])
            end
        end, 10000)
    end
end

lambda.augroup("ClearCommandMessages", {
    {
        event = { "CmdlineLeave", "CmdlineChanged" },
        pattern = { ":" },
        command = clear_commandline(),
    },
})

lambda.augroup("UpdateVim", {
    {
        event = { "FocusLost" },
        pattern = { "*" },
        command = "silent! wall",
    },
    -- Make windows equal size when vim resizes
    {
        event = { "VimResized" },
        pattern = { "*" },
        command = "wincmd =",
    },
})

local cursorline_exclude = { "alpha", "toggleterm" }

---@param buf number
---@return boolean
local function should_show_cursorline(buf)
    return vim.bo[buf].buftype ~= "terminal"
        and not vim.wo.previewwindow
        and vim.wo.winhighlight == ""
        and vim.bo[buf].filetype ~= ""
        and not vim.tbl_contains(cursorline_exclude, vim.bo[buf].filetype)
end

-- might be something wrong with this, though im not sure what.
lambda.augroup("Cursorline", {
    {
        event = { "BufEnter" },
        pattern = { "*" },
        command = function(args)
            vim.wo.cursorline = should_show_cursorline(args.buf)
        end,
    },
    {
        event = { "BufLeave" },
        pattern = { "*" },
        command = function()
            vim.wo.cursorline = false
        end,
    },
})

lambda.augroup("TerminalAutocommands", {
    {
        event = { "TermClose" },
        pattern = "*",
        command = function()
            --- automatically close a terminal if the job was successful
            if not vim.v.event.status == 0 then
                vim.cmd.bdelete({ fn.expand("<abuf>"), bang = true })
            end
        end,
    },
})
lambda.augroup("HoudiniFix", {
    {
        pattern = "LightspeedSxLeave",
        event = "User",
        command = function()
            local ignore = vim.tbl_contains({ "terminal", "prompt" }, vim.opt.buftype:get())
            if vim.opt.modifiable:get() and not ignore then
                vim.cmd("normal! a")
            end
        end,
    },
})

lambda.augroup("AddTerminalMappings", {
    {
        event = { "TermOpen" },
        pattern = { "term://*" },
        command = function()
            if vim.bo.filetype == "" or vim.bo.filetype == "toggleterm" then
                local opts = { silent = false, buffer = 0 }
                vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
                vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
                vim.keymap.set("t", "<C-h>", "<Cmd>wincmd h<CR>", opts)
                vim.keymap.set("t", "<C-j>", "<Cmd>wincmd j<CR>", opts)
                vim.keymap.set("t", "<C-k>", "<Cmd>wincmd k<CR>", opts)
                vim.keymap.set("t", "<C-l>", "<Cmd>wincmd l<CR>", opts)
                vim.keymap.set("t", "]t", "<Cmd>tablast<CR>", {})
                vim.keymap.set("t", "[t", "<Cmd>tabnext<CR>", {})
                vim.keymap.set("t", "<S-Tab>", "<Cmd>bprev<CR>", {})
                vim.keymap.set("t", "<leader><Tab>", "<Cmd>close \\| :bnext<cr>", {})
            end
        end,
    },
})

--[[ Honestly cap locks are such a pain in the ass that its getting too annoying  ]]
--[[ i will use <c-;> and <c-g>c to enable them when i need to just in case ]]
lambda.augroup("CapLockDisable", {
    {
        event = "VimEnter",
        pattern = "*",
        command = "silent !setxkbmap -option ctrl:nocaps",
    },
    {
        event = "VimLeave",
        pattern = "*",
        command = "silent !setxkbmap -option",
    },
})

lambda.augroup("dwm", {
    {
        event = "TermOpen",
        pattern = "*",
        command = function()
            vim.b.dwm_disabled = true
        end,
    },
    {
        event = "FileType",
        pattern = "*",
        command = function()
            if vim.tbl_contains({ "neo-tree" }, vim.opt.filetype:get()) then
                vim.b.dwm_disabled = true
            end
        end,
    },
    {
        event = "BufRead",
        pattern = "*",
        command = function()
            if vim.tbl_contains({ "nofile" }, vim.opt.buftype:get()) then
                vim.b.dwm_disabled = true
            end
        end,
    },

    {
        event = "BufRead",
        pattern = "*",
        command = [[if &previewwindow | let b:dwm_disabled = 1 | endif]],
    },
})

lambda.setup_plugin("BufEnter", function()
    if lambda.config.use_lightspeed then
        return "lightspeed.nvim"
    end
    return "leap.nvim"
end, true)

lambda.augroup("FixNoice", {
    {
        event = "FileType",
        pattern = "NeogitCommitMessage",
        command = function()
            if lambda.config.use_noice then
                vim.cmd([[Noice disable]])
            end
        end,
    },
    {
        event = "BufLeave",
        pattern = "*gitStatus",
        command = function()
            if lambda.config.use_noice then
                -- and vim.bo.filetype == "NeogitStatus" then
                vim.cmd([[Noice enable]])
            end
        end,
    },
})
