local Hydra = require("hydra")
local loader = require("packer").loader

local gitrepo = vim.fn.isdirectory(".git/index")
--[[ local line = vim.fn.line ]]

local function wrap(fn, ...)
    local args = { ... }
    local nargs = select("#", ...)
    return function()
        fn(unpack(args, nargs))
    end
end

local function diffmaster()
    local branch = "origin/master"
    local master = vim.fn.systemlist("git rev-parse --verify develop")
    if not master[1]:find("^fatal") then
        branch = "origin/master"
    else
        master = vim.fn.systemlist("git rev-parse --verify master")
        if not master[1]:find("^fatal") then
            branch = "origin/master"
        else
            master = vim.fn.systemlist("git rev-parse --verify main")
            if not master[1]:find("^fatal") then
                branch = "origin/main"
            end
        end
    end
    local current_branch = vim.fn.systemlist("git branch --show-current")[1]
    -- git rev-list --boundary feature/FDEL-3386...origin/main | grep "^-"
    -- local cmd = string.format([[git rev-list --boundary %s...%s | grep "^-"]], current_branch, branch)
    local cmd = string.format([[git merge-base %s %s ]], branch, current_branch)
    local hash = vim.fn.systemlist(cmd)[1]

    if hash then
        vim.notify("DiffviewOpen " .. hash)
        vim.cmd("DiffviewOpen " .. hash)
    else
        vim.notify("DiffviewOpen " .. branch)
        vim.cmd("DiffviewOpen " .. branch)
    end
end

if gitrepo then
    loader("keymap-layer.nvim vgit.nvim gitsigns.nvim vim-fugitive")

    local hint = [[
  ^^^^----------------------------------------------^^^^
  ^^^^                   Gitsigns                   ^^^^
  ^^^^----------------------------------------------^^^^
  _J_ : next hunk                   _D_ : diffthis
  _K_ : prev hunk                   _p_ : Preview H
  _s_ : stagehunk                   _S_ : stage buf
  _r_ : reset hunk                  _R_ : Reset Buffer
  _x_ : show del                    _u_ : ustage hunk
  _b_ : gutterView                  _B_ : blame_line
  _/_ : show base                   _i_ : Select hunk
  _Qq_ : Setqflist all              _Qw_ : Setqflist
  ^^^^-----------------------------------------------^^^^
  ^^^^                     VGIT                      ^^^^
  ^^^^-----------------------------------------------^^^^
  _k_ : proj diff                   _g_ : diff staged
  _dd_ : diff preview               _P_ : projStaged
  _f_ : proj hunkQF                 _U_ : unstagebuf
                    _G_ : stage diff
  ^^^^------------------------------------------------^^^^
  ^^^^                    Personal                    ^^^^
  ^^^^------------------------------------------------^^^^
  _d_: diftree                      _M_ : difmast
  _c_ : conflict                    _m_ : merge
  _H_ : filehist                    _l_ : log
  ^^^^------------------------------------------------^^^^

        _<Enter>_ => Neogit _q_ => exit => _<Esc>_
]]

    local ok, gitsigns = pcall(require, "gitsigns")
    if ok then
        local vgit = require("vgit")
        local gs = package.loaded.gitsigns
        Hydra({
            name = "Git Mode",
            hint = hint,
            config = {
                color = "pink",
                invoke_on_body = true,
                hint = {
                    position = "bottom",
                    border = "single",
                },
                on_enter = function()
                    vim.cmd.mkview()
                    vim.cmd("silent! %foldopen!")
                    vim.bo.modifiable = false
                    gitsigns.toggle_linehl(true)
                    gitsigns.toggle_deleted(true)
                end,
                on_exit = function()
                    local cursor_pos = vim.api.nvim_win_get_cursor(0)
                    vim.cmd.loadview()
                    vim.api.nvim_win_set_cursor(0, cursor_pos)
                    vim.cmd("normal zv")
                    gitsigns.toggle_signs(false)
                    gitsigns.toggle_linehl(false)
                    gitsigns.toggle_deleted(false)
                end,
            },
            mode = { "n", "x" },
            body = "<leader>h",
            heads = {
                {
                    "J",
                    function()
                        if vim.wo.diff then
                            return "]c"
                        end
                        vim.schedule(function()
                            gitsigns.next_hunk()
                        end)
                        return "<Ignore>"
                    end,
                    { expr = true, desc = "next hunk" },
                },
                {
                    "K",
                    function()
                        if vim.wo.diff then
                            return "[c"
                        end
                        vim.schedule(function()
                            gitsigns.prev_hunk()
                        end)
                        return "<Ignore>"
                    end,
                    { expr = true, desc = "prev hunk" },
                },
                { "s", ":Gitsigns stage_hunk<CR>", { silent = true } },

                {
                    "i",
                    function()
                        local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
                        if mode == "V" then -- visual-line mode
                            local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
                            vim.api.nvim_feedkeys(esc, "x", false) -- exit visual mode
                            vim.cmd("'<,'>gitsigns select_hunk")
                        end
                    end,
                    { desc = "Select hunk" },
                },

                { "u", gitsigns.undo_stage_hunk },
                { "S", gitsigns.stage_buffer },
                { "p", gitsigns.preview_hunk },
                { "x", gitsigns.toggle_deleted, { nowait = true } },
                { "r", gitsigns.reset_hunk },
                { "D", wrap(gitsigns.diffthis, "~") },
                { "R", ":Gitsigns reset_buffer<CR>", { silent = true } },

                { "Qq", wrap(gitsigns.setqflist, "all") },
                { "Qw", wrap(gitsigns.setqflist) },
                {
                    "B",
                    function()
                        gitsigns.blame_line({ full = true })
                    end,
                    { desc = "blame_line" },
                },
                { "/", gitsigns.show, { exit = true } }, -- show the base of the file
                { "b", gitsigns.blame_line },

                { "d", ":DiffviewOpen<CR>", { silent = true, exit = true } },
                { "M", diffmaster, { silent = true, exit = true } },
                { "H", ":DiffviewFileHistory<CR>", { silent = true, exit = true } },

                { "k", vgit.project_diff_preview, { exit = true } },
                { "dd", vgit.buffer_diff_preview, { exit = true } },
                { "g", vgit.buffer_diff_staged_preview, { exit = true } },
                { "P", vgit.project_staged_hunks_preview },
                { "f", vgit.project_hunks_qf },
                { "U", vgit.buffer_unstage },
                { "G", vgit.buffer_diff_staged_preview },

                { "<Enter>", ":tcd %:p:h<cr>:Neogit<cr>", { exit = true } },
                { "q", nil, { exit = true, nowait = true } },
                { "<Esc>", nil, { exit = true } },

                { "l", ":Flogsplit<CR>", { exit = true, nowait = true } },
                { "m", ":Git mergetool<CR>" },
                { "c", ":GitConflictListQf<CR>" },
            },
        })
    end
end
