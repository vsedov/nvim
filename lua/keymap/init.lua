local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_args = bind.map_args
local map_key = bind.map_key
local global = require("core.global")
require("keymap.config")

local plug_map = {
  ["i|<TAB>"] = map_cmd("v:lua.tab_complete()"):with_expr():with_silent(),
  ["i|<S-TAB>"] = map_cmd("v:lua.s_tab_complete()"):with_silent():with_expr(),
  ["s|<TAB>"] = map_cmd("v:lua.tab_complete()"):with_expr():with_silent(),
  ["s|<S-TAB>"] = map_cmd("v:lua.s_tab_complete()"):with_silent():with_expr(),

  -- -- -- person keymap
  -- -- ["n|mf"]             = map_cr("<cmd>lua require('internal.fsevent').file_event()<CR>"):with_silent():with_nowait():with_noremap();
  -- -- Lsp mapp work when insertenter and lsp start
  ["n|<leader>li"] = map_cr("LspInfo"):with_noremap():with_silent():with_nowait(),
  ["n|<leader>ll"] = map_cr("LspLog"):with_noremap():with_silent():with_nowait(),
  ["n|<leader>lr"] = map_cr("LspRestart"):with_noremap():with_silent():with_nowait(),

  -- -- Word Motion
  -- ["n|w"] = map_cmd(function() return "w"end ):with_silent():with_expr(),
  -- ["n|W"] = map_cmd('v:lua.word_motion_move("W")'):with_silent():with_expr(),

  -- have this for the time, i might use some root , not usre .
  ["n|<leader>cd"] = map_cmd("<cmd>cd %:p:h<CR>:pwd<CR>"):with_noremap():with_silent(),

  ["n|b"] = map_cmd('v:lua.word_motion_move_b("b")'):with_silent():with_expr(),
  ["n|B"] = map_cmd('v:lua.word_motion_move_b("B")'):with_silent():with_expr(),
  ["n|gE"] = map_cmd('v:lua.word_motion_move_gE("gE")'):with_silent():with_expr(),

  ["n|<C-]>"] = map_args("Template"),
  -- -- ["n|gt"]             = map_cmd("<cmd>lua vim.lsp.buf.type_definition()<CR>"):with_noremap():with_silent(),
  -- -- ["n|<Leader>cw"]     = map_cmd("<cmd>lua vim.lsp.buf.workspace_symbol()<CR>"):with_noremap():with_silent(),

  -- -- Plugin nvim-tree
  ["n|<Leader>e"] = map_cr("NvimTreeToggle"):with_noremap():with_silent(),
  ["n|<Leader>F"] = map_cr("NvimTreeFindFile"):with_noremap():with_silent(),

  -- -- Code actions ?
  ["n|<Leader>cw"] = map_cmd("<cmd>lua vim.lsp.buf.workspace_symbol()<CR>"):with_noremap():with_silent(),

  ["n|ga"] = map_cu("CodeActionMenu"):with_noremap():with_silent(),
  ["v|ga"] = map_cu("CodeActionMenu"):with_noremap():with_silent(),
  -- Back up .
  ["n|<Leader>ca"] = map_cu("<cmd>lua vim.lsp.buf.code_action()<CR>"):with_noremap():with_silent(),

  ["n|<Leader>gD"] = map_cmd("<cmd>lua vim.lsp.buf.type_definition()<CR>"):with_noremap():with_silent(),

  -- -- On n map commands
  ["n|gD"] = map_cmd("<cmd>lua vim.lsp.buf.declaration()<CR>"):with_noremap():with_silent(),
  ["n|gd"] = map_cmd("<cmd>lua vim.lsp.buf.definition()<CR>"):with_noremap():with_silent(),

  ["n|K"] = map_cmd("<cmd>lua vim.lsp.buf.hover()<CR>"):with_noremap():with_silent(),
  ["n|gi"] = map_cmd("<cmd>lua vim.lsp.buf.implementation()<CR>"):with_noremap():with_silent(),

  ["n|rn"] = map_cmd("<cmd>lua vim.lsp.buf.references()<CR>"):with_noremap():with_silent(),

  -- Depreciated, need to recode this part up.
  ["n|[d"] = map_cmd("<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>"):with_noremap():with_silent(),
  ["n|]d"] = map_cmd("<cmd>lua vim.lsp.diagnostic.goto_next()<CR>"):with_noremap():with_silent(),

  ["n|<localleader>d"] = map_cmd("<cmd>lua vim.diagnostic.open_float(0)<CR>"):with_noremap():with_silent(),
  ["n|<localleader>D"] = map_cmd(
    '<cmd>lua require"modules.completion.lsp_support".toggle_diagnostics_visibility()<CR>'
  )
    :with_noremap()
    :with_silent(),
  ["n|<localleader>dp"] = map_cmd('<cmd>lua require"modules.completion.lsp_support".PeekDefinition()<CR>')
    :with_noremap()
    :with_silent(),

  ["n|<localleader>dpt"] = map_cmd('<cmd>lua require"modules.completion.lsp_support".PeekTypeDefinition()<CR>')
    :with_noremap()
    :with_silent(),

  ["n|<localleader>dpi"] = map_cmd('<cmd>lua require"modules.completion.lsp_support".PeekImplementation()<CR>')
    :with_noremap()
    :with_silent(),

  -- -- SOMETHING WRONG HERE .
  ["n|<Leader>gr"] = map_cu("Lspsaga rename <cr>"):with_noremap():with_silent(),
  ["v|<Leader>gr"] = map_cu("Lspsaga rename <cr>"):with_noremap():with_silent(),

  ["n|gpd"] = map_cu("GotoPrev"):with_noremap(),
  ["n|gpi"] = map_cu("GotoImp"):with_noremap(),
  ["n|gpt"] = map_cu("GotoTel"):with_noremap(),

  ---
  -- LSP SPAGA :
  -- Lines 51, 57, 58, 60 , 64 would have to be remaped to teh following .
  ---

  -- ["n|<Leader>gr"] = map_cu("Lspsaga rename"):with_noremap():with_silent(),
  -- ["n|K"] = map_cu("<cmd>Lspsaga hover_doc<cr>"):with_noremap():with_silent(),
  -- ["n|[d"] = map_cmd("<cmd>Lspsaga diagnostic_jump_next()<CR>"):with_noremap():with_silent(),
  -- ["n|]d"] = map_cmd("<cmd>Lspsaga diagnostic_jump_prev()<CR>"):with_noremap():with_silent(),
  -- ["n|<localleader>d"] = map_cu("Lspsaga show_line_diagnostics"):with_noremap():with_silent(),
  -- ["n|<C-u>"] = map_cmd("<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<cr>"),
  -- ["n|<C-d>"] = map_cmd("<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<cr>"),

  -- -- Goto prev mapping
  --- WARNING THERE COULD BE AN ISSUE WITH THIS>
  -- --

  -- -- How to run some code .
  ["n|<Leader>r"] = map_cr("Jaq"):with_noremap():with_silent(),
  ["n|<Leader>rf"] = map_cr("RunFile"):with_noremap():with_silent(),
  ["n|<Leader>rp"] = map_cr("RunProject"):with_noremap():with_silent(),

  ["n|<F6>"] = map_cu("NeoRunner"):with_noremap():with_silent(),

  -- -- never go wrong with clap
  -- Figure out the error with clap, giving very annoying error j
  ["n|<F1>"] = map_cr("Clap"):with_noremap():with_silent(),


  ["n|<F2>"] = map_cu("MundoToggle"):with_noremap():with_silent(),
  ["n|<Leader><F2>"] = map_cu("UndotreeToggle"):with_noremap():with_silent(),

  -- Have file specific mappings - sooon .
  -- ["n|<F3>"] = map_cu("Black"):with_noremap():with_silent(),

  -- -- Plugin MarkdownPreview
  ["n|<Leader>om"] = map_cu("MarkdownPreview"):with_noremap():with_silent(),
  -- Plugin DadbodUI
  ["n|<Leader>od"] = map_cr("DBUIToggle"):with_noremap():with_silent(),

  -- Far.vim Conflicting
  ["n|<Leader>fz"] = map_cr("Farf"):with_noremap():with_silent(),
  ["v|<Leader>fz"] = map_cr("Farr"):with_noremap():with_silent(),
  ["n|<Leader>fzd"] = map_cr("Fardo"):with_noremap():with_silent(),
  ["n|<Leader>fzu"] = map_cr("Farundo"):with_noremap():with_silent(),

  -- -- Plugin Telescope

  ["v|<Leader>ga"] = map_cmd("<cmd>lua require('utils.telescope').code_actions()<CR>"):with_noremap():with_silent(),

  ["n|<Leader>qf"] = map_cu("Telescope lsp_workspace_diagnostics"):with_noremap():with_silent(),

  ["n|<Leader>bb"] = map_cu("Telescope buffers"):with_noremap():with_silent(),
  ["n|<Leader><C-r>"] = map_cu("Telescope registers"):with_noremap():with_silent(),
  ["n|<Leader>fr"] = map_cmd("<cmd>Telescope registers<cr>"):with_noremap():with_silent(),

  ["n|<F5>"] = map_cmd("<cmd>Cheatsheet<CR>"):with_noremap():with_silent(),

  -- ["n|<Leader>fz"] = map_cr('<cmd>lua require("telescope").extensions.zoxide.list()'):with_silent(),
  -- ["n|<Leader>fp"] = map_cr('<cmd>lua require("telescope").extensions.projects.projects()'):with_silent(),
  ["n|<Leader>fl"] = map_cu("Telescope loclist"):with_noremap():with_silent(),
  ["n|<Leader>fc"] = map_cu("Telescope git_commits"):with_noremap():with_silent(),
  ["n|<Leader>vv"] = map_cu("Telescope treesitter"):with_noremap():with_silent(),

  -- Extra telescope commands from utils.telescope
  ["n|<Leader>cl"] = map_cmd('<cmd>lua require"utils.telescope".neoclip()<CR>'):with_noremap():with_silent(),

  -------------------------- Find

  ["n|<Leader>up"] = map_cmd('<cmd>lua require"utils.telescope".find_updir()<CR>'):with_noremap():with_silent(),
  ["n|<Leader>ff"] = map_cmd('<cmd>lua require"utils.telescope".find_files()<CR>'):with_noremap():with_silent(),
  ["n|<Leader>fff"] = map_cmd('<cmd>lua require"utils.telescope".files()<CR>'):with_noremap():with_silent(),
  ["n|<Leader>fn"] = map_cmd('<cmd>lua require"utils.telescope".find_notes()<CR>'):with_noremap():with_silent(),
  ["n|<Leader>fs"] = map_cmd('<cmd>lua require"utils.telescope".find_string()<CR>'):with_noremap():with_silent(),
  ["n|<Leader>ft"] = map_cmd('<cmd>lua require"utils.telescope".search_only_certain_files()<CR>')
    :with_noremap()
    :with_silent(),

  ["n|<Leader>fh"] = map_cmd('<cmd>lua require"utils.telescope".help_tags()<CR>'):with_noremap():with_silent(),

  -- grep
  ["n|<Leader>fw"] = map_cmd([['<cmd>lua require"telescope.builtin".live_grep()<cr>' . expand('<cword>')]])
    :with_expr()
    :with_silent(),
  ["n|<Leader>fW"] = map_cu("Telescope grep_string"):with_noremap():with_silent(),
  ["n|<Leader>gw"] = map_cmd('<cmd>lua require"utils.telescope".grep_last_search()<CR>'):with_noremap():with_silent(),
  ["n|<Leader>cb"] = map_cmd('<cmd>lua require"utils.telescope".curbuf()<CR>'):with_noremap():with_silent(),
  ["n|<Leader>gv"] = map_cmd('<cmd>lua require"utils.telescope".grep_string_visual()<CR>'):with_noremap():with_silent(),

  -- git
  ["n|<Leader>fg"] = map_cu("Telescope git_files"):with_noremap():with_silent(),
  ["n|<Leader>fu"] = map_cmd('<cmd>lua require"utils.telescope".git_diff()<CR>'):with_noremap():with_silent(),

  ["n|<Leader>fb"] = map_cmd('<cmd>lua require("utils.telescope").file_browser()<cr>'):with_noremap():with_silent(),

  ["n|<Leader>ip"] = map_cmd('<cmd>lua require"utils.telescope".installed_plugins()<CR>'):with_noremap():with_silent(),
  ["n|<Leader>ch"] = map_cmd('<cmd>lua require"utils.telescope".command_history()<CR>'):with_noremap():with_silent(),

  -- Dot files
  ["n|<Leader>fd"] = map_cmd('<cmd>lua require"utils.telescope".load_dotfiles()<CR>'):with_noremap():with_silent(),

  -- Jump
  ["n|<Leader>fj"] = map_cmd('<cmd>lua require"utils.telescope".jump()<CR>'):with_noremap():with_silent(),

  -- lsp implmentation with telescop

  ["n|<Leader>ir"] = map_cmd('<cmd>lua require"utils.telescope".lsp_references()<CR>'):with_noremap():with_silent(),

  ["n|<Leader><Leader><Leader>"] = map_cmd('<cmd>lua require"utils.telescope".frequency()<CR>')
    :with_noremap()
    :with_silent(),

  -- ["n|<F4>"] = map_cu("Telescope dap commands"):with_noremap():with_silent(),

  -- ["in|<d-T>"] = map_cu("Telescope"):with_noremap():with_silent(),
  --     :with_expr(),

  -- kitty / mac users, have a nice time >.< || will be changed
  -- ["n|<d-f>"] = map_cmd([[':Telescope live_grep<cr>' . expand('<cword>')]]):with_expr():with_silent():with_expr(),
  -- ["n|<d-F>"] = map_cmd(
  --   [['<cmd> lua require("telescope").extensions.live_grep_raw.live_grep_raw()<CR>' .  ' --type ' . &ft . ' ' . expand('<cword>')]]
  -- ):with_expr():with_silent(),
  -- ["n|<d-f>"] = map_cr("<cmd> lua require'telescope.builtin'.live_grep({defulat_text=vim.fn.expand('cword')})"):with_noremap(),
  -- :with_silent(),
  -- ["n|<Leader>fs"] = map_cu('Telescope gosource'):with_noremap():with_silent(),

  -- Plugin Vista or SymbolsOutline
  ["n|<Leader>v"] = map_cu("SymbolsOutline"):with_noremap():with_silent(),

  -- Plugin vim_niceblock
  ["x|I"] = map_cmd("v:lua.enhance_nice_block('I')"):with_expr(),
  ["x|gI"] = map_cmd("v:lua.enhance_nice_block('gI')"):with_expr(),
  ["x|A"] = map_cmd("v:lua.enhance_nice_block('A')"):with_expr(),

  -- Plugin for debugigng

  -- git stuff
  ["n|<Leader>gt"] = map_cr(
    '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>'
  ):with_silent(),
  ["v|<Leader>gt"] = map_cr(
    '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>'
  ),
  ["n|<Leader>gY"] = map_cr('<cmd>lua require"gitlinker".get_repo_url()<cr>'):with_silent(),
  ["n|<Leader>gT"] = map_cr(
    '<cmd>lua require"gitlinker".get_repo_url({action_callback = require"gitlinker.actions".open_in_browser})<cr>'
  ):with_silent(),

  -- Nice command to list all breakpoints. .
  ["n|<Leader>lb"] = map_cr("Telescope dap list_breakpoints"):with_noremap():with_silent(),

  -- ["n|<LeftMouse>"] = map_cmd("<LeftMouse><cmd>lua vim.lsp.buf.hover()<CR>"):with_noremap():with_silent(),
  ["n|<RightMouse>"] = map_cmd("<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>"):with_noremap():with_silent(),

  ["n|<C-ScrollWheelUp>"] = map_cmd("<C-i>"):with_noremap():with_silent(),
  ["n|<C-ScrollWheelDown>"] = map_cmd("<C-o>"):with_noremap():with_silent(),

  -- Alternate togller
  ["n|<Leader>ta"] = map_cr("ToggleAlternate"):with_noremap():with_silent(),

  -- TZAtaraxis
  ["n|<Leader><Leader>1"] = map_cu("ZenMode"):with_noremap():with_silent(),
  ["n|<Leader><leader>2"] = map_cu("TZAtaraxis<CR>"):with_noremap():with_silent(),
  ["n|<Leader><Leader>3"] = map_cu("TZMinimalist<CR>"):with_noremap():with_silent(),
  ["n|<Leader><Leader>4"] = map_cu("TZFocus<CR>"):with_noremap():with_silent(),
  --- new
  ["n|<Leader>vf"] = map_cmd("<Plug>(ultest-run-file)"):with_silent(),
  ["n|<Leader>vn"] = map_cmd("<Plug>(ultest-run-nearest)"):with_silent(),
  ["n|<Leader>vg"] = map_cmd("<Plug>(ultest-output-jump)"):with_silent(),
  ["n|<Leader>vo"] = map_cmd("<Plug>(ultest-output-show)"):with_silent(),
  ["n|<Leader>vs"] = map_cmd("<Plug>(ultest-summary-toggle)"):with_silent(),
  ["n|<Leader>va"] = map_cmd("<Plug>(ultest-attach)"):with_silent(),
  ["n|<Leader>vx"] = map_cmd("<Plug>(ultest-stop-file)"):with_silent(),

  -- Quick Fix infomation and binds
  ["n|<Leader>xx"] = map_cr("<cmd>Trouble<CR>"):with_noremap():with_silent(),

  -- Nice highlighting for latex when writing notes Norg files only.
  ["n|<F9>"] = map_cr('<cmd> lua require("nabla").action()<CR>'):with_noremap(),
  ["n|<localleader>b"] = map_cr('<cmd> lua require("nabla").popup()<CR>'):with_noremap(),

  -- $ ... $ : inline form
  -- $$ ... $$ : wrapped form

  ["n|<F8>"] = map_cu("AerialToggle"):with_silent(),

  -- Neogen

  ["n|<Leader>d"] = map_cr("<cmd>lua require('neogen').generate()<CR>"):with_noremap():with_silent(),
}

bind.nvim_load_mapping(plug_map)

-- Might be used, not sure how .
-- ["n|<Leader>dd"] = map_cu("lua require('dap').continue()"):with_noremap():with_silent(),
-- ["n|<Leader>do"] = map_cr("<cmd> lua require'dap'.step_over()<CR>"):with_noremap():with_silent(),
-- ["n|<Leader>di"] = map_cr("<cmd> lua require'dap'.step_into()<CR>"):with_noremap():with_silent(),
-- ["n|<Leader>dO"] = map_cr("<cmd> lua require'dap'.step_out()<CR>"):with_noremap():with_silent(),
-- ["n|<Leader>b"] = map_cr("<cmd> lua require'dap'.toggle_breakpoint()<CR>"):with_noremap():with_silent(),
-- ["n|<Leader>dr"] = map_cr("<cmd> lua require'dap'.repl.open()<CR>"):with_noremap():with_silent(),
-- ["n|<Leader>drr"] = map_cr('<cmd> lua require"dap".repl.toggle({width = 50}, "belowright vsplit")<cr>')
--   :with_noremap()
--   :with_silent(),
-- ["n|<Leader>dl"] = map_cr("<cmd> lua require'dap'.repl.run_last()<CR>"):with_noremap():with_silent(),
-- ["n|<Leader>xr"] = map_cr("<Cmd>lua require('dapui').eval()<CR>"):with_noremap():with_silent(),
-- ["n|C"] = map_cr('<cmd>lua require"dap".run_to_cursor()<CR>'):with_noremap():with_silent(),
