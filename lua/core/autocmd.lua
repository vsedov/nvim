local fn, api, v, env, cmd, fmt = vim.fn, vim.api, vim.v, vim.env, vim.cmd, string.format
----------------------------------------------------------------------------------------------------
-- HLSEARCH
----------------------------------------------------------------------------------------------------
-- In order to get hlsearch working the way I like i.e. on when using /,?,N,n,*,#, etc. and off when
-- When I'm not using them, I need to set the following:
-- The mappings below are essentially faked user input this is because in order to automatically turn off
-- the search highlight just changing the value of 'hlsearch' inside a function does not work
-- read `:h nohlsearch`. So to have this workaround I check that the current mouse position is not a search
-- result, if it is we leave highlighting on, otherwise I turn it off on cursor moved by faking my input
-- using the expr mappings below.
--
-- This is blambda.d on the implementation discussed here:
-- https://github.com/neovim/neovim/issues/5581

vim.keymap.set({ "n", "v", "o", "i", "c" }, "<Plug>(StopHL)", 'execute("nohlsearch")[-1]', { expr = true })

lambda.augroup("ExternalCommands", {
    {
        -- Open images in an image viewer (probably Preview)
        event = { "BufEnter" },
        pattern = { "*.png", "*.jpg", "*.gif" },
        command = function()
            cmd(fmt('silent! "%s | :bw"', vim.g.open_command .. " " .. fn.expand("%")))
        end,
    },
})

lambda.augroup("CheckOutsideTime", {
    {
        -- automatically check for changed files outside vim
        event = { "WinEnter", "BufWinEnter", "BufWinLeave", "BufRead", "BufEnter", "FocusGained" },
        command = "silent! checktime",
    },
})

lambda.augroup("TextYankHighlight", {
    {
        -- don't execute silently in clambda. of errors
        event = { "TextYankPost" },
        command = function()
            vim.highlight.on_yank({ timeout = 500, on_visual = false, higroup = "Visual" })
        end,
    },
})

lambda.augroup("WindowBehaviours", {
    {
        event = { "CmdwinEnter" }, -- map q to close command window on quit
        pattern = { "*" },
        command = "nnoremap <silent><buffer><nowait> q <C-W>c",
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
})

local save_excluded = {
    "neo-tree",
    "neo-tree-popup",
    "lua.luapad",
    "gitcommit",
    "NeogitCommitMessage",
}
local function can_save()
    return lambda.falsy(fn.win_gettype())
        and lambda.falsy(vim.bo.buftype)
        and not lambda.falsy(vim.bo.filetype)
        and vim.bo.modifiable
        and not vim.tbl_contains(save_excluded, vim.bo.filetype)
end

lambda.augroup("Utilities", {
    {
        ---@source: https://vim.fandom.com/wiki/Use_gf_to_open_a_file_via_its_URL
        event = { "BufReadCmd" },
        pattern = { "file:///*" },
        nested = true,
        command = function(args)
            cmd.bdelete({ bang = true })
            cmd.edit(vim.uri_to_fname(args.file))
        end,
    },
})

lambda.augroup("TerminalAutocommands", {
    {
        event = { "TermOpen" },
        command = function()
            if vim.bo.filetype == "" or vim.bo.filetype == "toggleterm" or vim.bo.buftype == "terminal" then
                local opts = { silent = false, buffer = 0 }
                -- vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
                -- vim.keymap.set("t", "<c-s>", [[<C-\><C-n>]], opts)

                vim.keymap.set("t", "<C-h>", "<Cmd>wincmd h<CR>", opts)
                vim.keymap.set("t", "<C-j>", "<Cmd>wincmd j<CR>", opts)
                vim.keymap.set("t", "<C-k>", "<Cmd>wincmd k<CR>", opts)
                vim.keymap.set("t", "<C-l>", "<Cmd>wincmd l<CR>", opts)

                vim.keymap.set("t", "]t", "<Cmd>tablast<CR>")
                vim.keymap.set("t", "[t", "<Cmd>tabnext<CR>")
                vim.keymap.set("t", ";<S-Tab>", "<Cmd>bprev<CR>")
                vim.keymap.set("t", ";<Tab>", "<Cmd>close \\| :bnext<cr>")
            end
        end,
    },
})
------------------------------------------------------------------------------//

local mkview_filetype_blocklist = {
    diff = true,
    gitcommit = true,
    hgcommit = true,
    ["neo-tree"] = true,
    harpoon = true,
}
local function should_mkview()
    return vim.bo.buftype == ""
        and vim.fn.getcmdwintype() == ""
        and mkview_filetype_blocklist[vim.bo.filetype] == nil
        and vim.fn.exists("$SUDO_USER") == 0 -- Don't create root-owned files.
end
function loadview()
    if should_mkview() then
        vim.api.nvim_command("silent! loadview")
        vim.api.nvim_command("silent! " .. vim.fn.line(".") .. "foldopen!")
    end
end

function mkview()
    if should_mkview() then
        local success, err = pcall(function()
            if vim.fn.exists("*haslocaldir") and vim.fn.haslocaldir() then
                -- We never want to save an :lcd command, so hack around it...
                vim.api.nvim_command("cd -")
                vim.api.nvim_command("mkview")
                vim.api.nvim_command("lcd -")
            else
                vim.api.nvim_command("mkview")
            end
        end)
        if not success then
            if
                err ~= nil
                and err:find("%f[%w]E186%f[%W]") == nil -- No previous directory: probably a `git` operation.
                and err:find("%f[%w]E190%f[%W]") == nil -- Could be name or path length exceeding NAME_MAX or PATH_MAX.
                and err:find("%f[%w]E5108%f[%W]") == nil
            then
                error(err)
            end
        end
    end
end

-- local valid = {
--     "python",
--     "lua",
-- }
-- lambda.augroup("SaveFoldsWhenWriting", {
--     {
--         event = "BufWritePost",
--         pattern = valid,
--         command = function()
--             if valid[vim.bo.filetype] then
--                 mkview()
--             end
--         end,
--     },
--     {
--         event = "QuitPre",
--         pattern = valid,
--         command = function()
--             if valid[vim.bo.filetype] then
--                 if vim.fn.exists("b:mkview") == 1 then
--                     mkview()
--                 end
--             end
--         end,
--     },
--     {
--         event = "BufWinEnter",
--         pattern = valid,
--         command = function()
--             if valid[vim.bo.filetype] then
--                 loadview()
--             end
--         end,
--     },
-- })
--
-- -- ref: https://github.com/omega-nvim/omega-nvim/blob/main/lua/omega/core/autocommands.lua
-- lambda.augroup("Omega", {
--
--     {
--
--         event = { "BufAdd", "BufEnter", "tabnew" },
--         command = function(args)
--             if vim.t.bufs == nil then
--                 vim.t.bufs = vim.api.nvim_get_current_buf() == args.buf and {} or { args.buf }
--             else
--                 local bufs = vim.t.bufs
--
--                 -- check for duplicates
--                 if
--                     vim.bo[args.buf].buflisted
--                     and (args.event == "BufEnter" or args.buf ~= vim.api.nvim_get_current_buf())
--                     and vim.api.nvim_buf_is_valid(args.buf)
--                     and (args.event == "BufEnter" or vim.bo[args.buf].buflisted)
--                     and not vim.tbl_contains(bufs, args.buf)
--                 then
--                     table.insert(bufs, args.buf)
--                     vim.t.bufs = bufs
--                 end
--             end
--         end,
--     },
--     {
--         event = { "BufNewFile", "BufRead", "TabEnter", "TermOpen" },
--         command = function()
--             if lambda.config.buffer.use_bufferline then
--                 if #vim.fn.getbufinfo({ buflisted = 1 }) >= 2 or #vim.api.nvim_list_tabpages() >= 2 then
--                     vim.opt.showtabline = 2
--                 end
--             end
--         end,
--     },
-- })
vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Auto Format Japanese Punctuation in Latex Files",
    group = aug,
    pattern = "*.tex",
    command = [[
  normal m`
  silent! %s/、/，/g
  silent! %s/。/．/g
  normal ``
  ]],
})
