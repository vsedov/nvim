local config = {}

function config.autopairs()

  local has_autopairs, autopairs = pcall(require, "nvim-autopairs")
  if not has_autopairs then
    print("autopairs not loaded")

    local loader = require("packer").loader
    loader("nvim-autopairs")
    has_autopairs, autopairs = pcall(require, "nvim-autopairs")
    if not has_autopairs then
      print("autopairs not installed")
      return
    end
  end
  local npairs = require("nvim-autopairs")
  local Rule = require("nvim-autopairs.rule")
  npairs.setup({
    disable_filetype = { "TelescopePrompt", "guihua", "guihua_rust", "clap_input" },
    autopairs = { enable = true },
    ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""), -- "[%w%.+-"']",
    enable_check_bracket_line = false,
    html_break_line_filetype = { "html", "vue", "typescriptreact", "svelte", "javascriptreact" },
    check_ts = true,
    ts_config = {
      lua = { "string" }, -- it will not add pair on that treesitter node
      -- go = {'string'},
      javascript = { "template_string" },
      java = false, -- don't check treesitter on java
    },
    fast_wrap = {
      map = "<M-e>",
      chars = { "{", "[", "(", '"', "'", "`" },
      pattern = string.gsub([[ [%'%"%`%+%)%>%]%)%}%,%s] ]], "%s+", ""),
      end_key = "$",
      keys = "qwertyuiopzxcvbnmasdfghjkl",
      check_comma = true,
      hightlight = "Search",
    },
  })



  local ts_conds = require("nvim-autopairs.ts-conds")
  -- you need setup cmp first put this after cmp.setup()

  npairs.add_rules({
    Rule(" ", " "):with_pair(function(opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({ "()", "[]", "{}" }, pair)
    end),
    Rule("(", ")")
      :with_pair(function(opts)
        return opts.prev_char:match(".%)") ~= nil
      end)
      :use_key(")"),
    Rule("{", "}")
      :with_pair(function(opts)
        return opts.prev_char:match(".%}") ~= nil
      end)
      :use_key("}"),
    Rule("[", "]")
      :with_pair(function(opts)
        return opts.prev_char:match(".%]") ~= nil
      end)
      :use_key("]"),
    Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
    Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
  })

  -- If you want insert `(` after select function or method item
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  local cmp = require("cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

  if load_coq() then
    local remap = vim.api.nvim_set_keymap
    local npairs = require("nvim-autopairs")

    npairs.setup({ map_bs = false })

    vim.g.coq_settings = { keymap = { recommended = false } }

    -- these mappings are coq recommended mappings unrelated to nvim-autopairs
    remap("i", "<esc>", [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
    remap("i", "<c-c>", [[pumvisible() ? "<c-e><c-c>" : "<c-c>"]], { expr = true, noremap = true })
    remap("i", "<tab>", [[pumvisible() ? "<c-n>" : "<tab>"]], { expr = true, noremap = true })
    remap("i", "<s-tab>", [[pumvisible() ? "<c-p>" : "<bs>"]], { expr = true, noremap = true })

    -- skip it, if you use another global object
    _G.MUtils = {}

    MUtils.CR = function()
      if vim.fn.pumvisible() ~= 0 then
        if vim.fn.complete_info({ "selected" }).selected ~= -1 then
          return npairs.esc("<c-y>")
        else
          -- you can change <c-g><c-g> to <c-e> if you don't use other i_CTRL-X modes
          return npairs.esc("<c-g><c-g>") .. npairs.autopairs_cr()
        end
      else
        return npairs.autopairs_cr()
      end
    end
    remap("i", "<cr>", "v:lua.MUtils.CR()", { expr = true, noremap = true })

    MUtils.BS = function()
      if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ "mode" }).mode == "eval" then
        return npairs.esc("<c-e>") .. npairs.autopairs_bs()
      else
        return npairs.autopairs_bs()
      end
    end
    remap("i", "<bs>", "v:lua.MUtils.BS()", { expr = true, noremap = true })
  end

  -- skip it, if you use another global object
end

local esc = function(cmd)
  return vim.api.nvim_replace_termcodes(cmd, true, false, true)
end

function config.hexokinase()
  vim.g.Hexokinase_optInPatterns = {
    "full_hex",
    "triple_hex",
    "rgb",
    "rgba",
    "hsl",
    "hsla",
    "colour_names",
  }
  vim.g.Hexokinase_highlighters = {
    "virtual",
    "sign_column", -- 'background',
    "backgroundfull",
    -- 'foreground',
    -- 'foregroundfull'
  }
end

function config.lightspeed()
  require("lightspeed").setup({
    ignore_case = false,
    exit_after_idle_msecs = { labeled = nil, unlabeled = 1000 },

    -- s/x
    grey_out_search_area = true,
    highlight_unique_chars = true,
    match_only_the_start_of_same_char_seqs = true,
    jump_on_partial_input_safety_timeout = 400,
    substitute_chars = { ["\r"] = "¬" },
    -- Leaving the appropriate list empty effectively disables

    cycle_group_fwd_key = "<space>",
    cycle_group_bwd_key = "<tab>",

    -- f/t
    limit_ft_matches = 4,
    repeat_ft_with_target_char = false,
  })
end

function config.discord()
  --i don\'t want to deal with vscode , The One True Text Editor
  -- Editor For The True Traditionalist
  require("presence"):setup({
    -- General options
    auto_update = true, -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
    neovim_image_text = "Editor For The True Traditionalist", -- Text displayed when hovered over the Neovim image
    -- neovim_image_text   = "The One True Text Editor", -- Text displayed when hovered over the Neovim image
    main_image = "file", -- Main image display (either "neovim" or "file")
    client_id = "793271441293967371", -- Use your own Discord application client id (not recommended)
    log_level = nil, -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
    debounce_timeout = 10, -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
    enable_line_number = false, -- Displays the current line number instead of the current project

    -- Rich Presence text options
    editing_text = "Editing %s", -- Format string rendered when an editable file is loaded in the buffer
    file_explorer_text = "Browsing %s", -- Format string rendered when browsing a file explorer
    git_commit_text = "Committing changes", -- Format string rendered when commiting changes in git
    plugin_manager_text = "Managing plugins", -- Format string rendered when managing plugins
    reading_text = "Reading %s", -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer
    workspace_text = "Working on %s", -- Workspace format string (either string or function(git_project_name: string|nil, buffer: string): string)
    line_number_text = "Line %s out of %s", -- Line number format string (for when enable_line_number is set to true)
  })
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
      -- print("ctx", vim.inspect(ctx))
      -- Only update commentstring for tsx filetypes
      if
        vim.bo.filetype == "typescriptreact"
        or vim.bo.filetype == "javascript"
        or vim.bo.filetype == "css"
        or vim.bo.filetype == "html"
      then
        require("ts_context_commentstring.internal").update_commentstring()
      end
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

function config.neorg()
  local loader = require("packer").loader
  if not packer_plugins["nvim-treesitter"].loaded then
    loader("nvim-treesitter")
  end
  if not packer_plugins["neorg-telescope"].loaded then
    loader("telescope.nvim")
    loader("neorg-telescope")
  end

  require("neorg").setup({
    -- Tell Neorg what modules to load
    load = {
      ["core.defaults"] = {}, -- Load all the default modules
      ["core.norg.concealer"] = {}, -- Allows for use of icons
      ["core.norg.dirman"] = { -- Manage your directories with Neorg
        config = { workspaces = { my_workspace = "~/neorg" } },
      },
      ["core.keybinds"] = { -- Configure core.keybinds
        config = {
          default_keybinds = true, -- Generate the default keybinds
          neorg_leader = "<Leader>o", -- This is the default if unspecified
        },
      },
      ["core.norg.completion"] = { config = { engine = "nvim-cmp" } },
      ["core.integrations.telescope"] = {}, -- Enable the telescope module
    },
  })
  local neorg_callbacks = require("neorg.callbacks")

  neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
    -- Map all the below keybinds only when the "norg" mode is active
    keybinds.map_event_to_mode("norg", {
      n = { -- Bind keys in normal mode
        { "<C-s>", "core.integrations.telescope.find_linkable" },
      },

      i = { -- Bind in insert mode
        { "<C-i>", "core.integrations.telescope.insert_link" },
      },
    }, { silent = true, noremap = true })
  end)
end

function config.vim_cursorwod()
  vim.api.nvim_command("augroup user_plugin_cursorword")
  vim.api.nvim_command("autocmd!")
  vim.api.nvim_command("autocmd FileType NvimTree let b:cursorword = 0")
  vim.api.nvim_command("autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif")
  vim.api.nvim_command("autocmd InsertEnter * let b:cursorword = 0")
  vim.api.nvim_command("autocmd InsertLeave * let b:cursorword = 1")
  vim.api.nvim_command("augroup END")
end

function config.hlslens()
  -- body
  -- vim.cmd([[packadd nvim-hlslens]])
  vim.cmd([[noremap <silent> n <Cmd>execute('normal! ' . v:count1 . 'n')<CR> <Cmd>lua require('hlslens').start()<CR>]])
  vim.cmd([[noremap <silent> N <Cmd>execute('normal! ' . v:count1 . 'N')<CR> <Cmd>lua require('hlslens').start()<CR>]])
  vim.cmd([[noremap * *<Cmd>lua require('hlslens').start()<CR>]])
  vim.cmd([[noremap # #<Cmd>lua require('hlslens').start()<CR>]])
  vim.cmd([[noremap g* g*<Cmd>lua require('hlslens').start()<CR>]])
  vim.cmd([[noremap g# g#<Cmd>lua require('hlslens').start()<CR>]])
  vim.cmd([[nnoremap <silent> <leader>l :noh<CR>]])
  require("hlslens").setup({
    calm_down = true,
    -- nearest_only = true,
    nearest_float_when = "always",
  })
  vim.cmd([[aug VMlens]])
  vim.cmd([[au!]])
  vim.cmd([[au User visual_multi_start lua require('utils.vmlens').start()]])
  vim.cmd([[au User visual_multi_exit lua require('utils.vmlens').exit()]])
  vim.cmd([[aug END]])
end

-- Exit                  <Esc>       quit VM
-- Find Under            <C-n>       select the word under cursor
-- Find Subword Under    <C-n>       from visual mode, without word boundaries
-- Add Cursor Down       <M-Down>    create cursors vertically
-- Add Cursor Up         <M-Up>      ,,       ,,      ,,
-- Select All            \\A         select all occurrences of a word
-- Start Regex Search    \\/         create a selection with regex search
-- Add Cursor At Pos     \\\         add a single cursor at current position
-- Reselect Last         \\gS        reselect set of regions of last VM session

-- Mouse Cursor    <C-LeftMouse>     create a cursor where clicked
-- Mouse Word      <C-RightMouse>    select a word where clicked
-- Mouse Column    <M-C-RightMouse>  create a column, from current cursor to
--                                   clicked position
function config.vmulti()
  vim.g.VM_mouse_mappings = 1
  -- mission control takes <C-up/down> so remap <M-up/down> to <C-Up/Down>
  -- vim.api.nvim_set_keymap("n", "<M-n>", "<C-n>", {silent = true})
  -- vim.api.nvim_set_keymap("n", "<M-Down>", "<C-Down>", {silent = true})
  -- vim.api.nvim_set_keymap("n", "<M-Up>", "<C-Up>", {silent = true})
  -- for mac C-L/R was mapped to mission control
  -- print('vmulti')
  vim.g.VM_silent_exit = 1
  vim.g.VM_show_warnings = 0
  vim.g.VM_default_mappings = 1
  vim.cmd([[
      let g:VM_maps = {}
      let g:VM_maps['Find Under'] = '<C-n>'
      let g:VM_maps['Find Subword Under'] = '<C-n>'
      let g:VM_maps['Select All'] = '<C-M-n>'
      let g:VM_maps['Seek Next'] = 'n'
      let g:VM_maps['Seek Prev'] = 'N'
      let g:VM_maps["Undo"] = 'u'
      let g:VM_maps["Redo"] = '<C-r>'
      let g:VM_maps["Remove Region"] = '<cr>'
      let g:VM_maps["Add Cursor Down"] = '<M-Down>'
      let g:VM_maps["Add Cursor Up"] = "<M-Up>"
      let g:VM_maps["Mouse Cursor"] = "<M-LeftMouse>"
      let g:VM_maps["Mouse Word"] = "<M-RightMouse>"
      let g:VM_maps["Add Cursor At Pos"] = '<M-i>'
  ]])
end

return config
