local bind = require("keymap.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_args = bind.map_args
require("keymap.config")

local plug_map = {

	-- person keymap
	["n|mf"] = map_cr("<cmd>lua require('internal.fsevent').file_event()<CR>")
		:with_silent()
		:with_nowait()
		:with_noremap(),

	-- Packer
	["n|<leader>pu"] = map_cr("PackerUpdate"):with_silent():with_noremap():with_nowait(),
	["n|<leader>pi"] = map_cr("PackerInstall"):with_silent():with_noremap():with_nowait(),
	["n|<leader>pc"] = map_cr("PackerCompile"):with_silent():with_noremap():with_nowait(),

	-- Lsp mapp work when insertenter and lsp start
	["n|<leader>li"] = map_cr("LspInfo"):with_noremap():with_silent():with_nowait(),
	["n|<leader>ll"] = map_cr("LspLog"):with_noremap():with_silent():with_nowait(),
	["n|<leader>lr"] = map_cr("LspRestart"):with_noremap():with_silent():with_nowait(),

	["n|<Leader>cw"] = map_cmd("<cmd>lua vim.lsp.buf.workspace_symbol()<CR>"):with_noremap():with_silent(),

	["n|<C-]>"] = map_args("Template"),
	["n|<Leader>tf"] = map_cu("DashboardNewFile"):with_noremap():with_silent(),

	-- I used code action decent sometimes it doesnt work

	-- All commands with leader
	["n|<Leader>gD"] = map_cmd("<cmd>lua vim.lsp.buf.type_definition()<CR>"):with_noremap():with_silent(),
	["n|<Leader>gr"] = map_cmd("<cmd>lua vim.lsp.buf.rename()<CR>"):with_noremap():with_silent(),

	["n|ga"] = map_cmd("CodeActionMenu"):with_noremap():with_silent(),

	["n|<Leader>ca"] = map_cu("<cmd>lua vim.lsp.buf.code_action()<CR>"):with_noremap():with_silent(),

	["n|<Leader>ggi"] = map_cu("LazyGit"):with_noremap():with_silent(),

	-- On n map commands
	["n|gD"] = map_cmd("<cmd>lua vim.lsp.buf.declaration()<CR>"):with_noremap():with_silent(),
	-- ["n|gd"] = map_cmd("<cmd>lua vim.lsp.buf.definition()<CR>"):with_noremap():with_silent(),

	["n|K"] = map_cmd("<cmd>lua vim.lsp.buf.hover()<CR>"):with_noremap():with_silent(),
	["n|gi"] = map_cmd("<cmd>lua vim.lsp.buf.implementation()<CR>"):with_noremap():with_silent(),

	["n|<C-k>"] = map_cmd("<cmd>lua vim.lsp.buf.signature_help()<CR>"):with_noremap():with_silent(),
	["n|rn"] = map_cmd("<cmd>lua vim.lsp.buf.references()<CR>"):with_noremap():with_silent(),

	["n|[d"] = map_cmd("<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>"):with_noremap():with_silent(),
	["n|]d"] = map_cmd("<cmd>lua vim.lsp.diagnostic.goto_next()<CR>"):with_noremap():with_silent(),

	-- never go wrong with clap
	["n|<F1>"] = map_cr("Clap"):with_noremap():with_silent(),
	["n|<Leader><F1>"] = map_cu("Clap grep ++query=<cword> |  startinsert"),

	["n|<Leader>fq"] = map_cu("Clap grep ++query=<Cword>"):with_noremap():with_silent(),
	["v|<A-w>"] = map_cu("Clap maps +mode=v | startinsert"),
 
	["n|<Leader>cl"] = map_cu("Telescope neoclip a extra=star,plus,b"):with_noremap():with_silent(),

	["n|<F2>"] = map_cu("MundoToggle"):with_noremap():with_silent(),
	["n|<Leader><F2>"] = map_cu("UndotreeToggle"):with_noremap():with_silent(),

	["n|<F3>"] = map_cu("Black"):with_noremap():with_silent(),

	--NeoRunner_Horizontalo
	["n|<F6>"] = map_cu("NeoRunner"):with_noremap():with_silent(),

	-- Plugin nvim-tree
	["n|<Leader>e"] = map_cr("NvimTreeToggle"):with_noremap():with_silent(),
	["n|<Leader>FF"] = map_cr("NvimTreeFindFile"):with_noremap():with_silent(),

	["n|<Leader>ss"] = map_cu("SaveSession"):with_noremap(),
	["n|<Leader>sl"] = map_cu("RestoreSession"):with_noremap(),
	["n|<Leader>sd"] = map_cu("DeleteSession"):with_noremap(),

	-- Plugin MarkdownPreview
	["n|<Leader>om"] = map_cu("MarkdownPreview"):with_noremap():with_silent(),
	-- Plugin DadbodUI
	["n|<Leader>od"] = map_cr("DBUIToggle"):with_noremap():with_silent(),

	-- Far.vim
	["n|<Leader>fz"] = map_cr("Farf"):with_noremap():with_silent(),
	["v|<Leader>fz"] = map_cr("Farr"):with_noremap():with_silent(),
	["n|<Leader>fzd"] = map_cr("Fardo"):with_noremap():with_silent(),
	["n|<Leader>fzu"] = map_cr("Farundo"):with_noremap():with_silent(),

	-- Plugin Telescope
	-- Plugin Telescope
	["n|<Leader>bb"] = map_cu("Telescope buffers"):with_noremap():with_silent(),
	["n|<Leader>fa"] = map_cu("DashboardFindWord"):with_noremap():with_silent(),
	["n|<Leader>fb"] = map_cu("Telescope file_browser"):with_noremap():with_silent(),
	["n|<Leader>fff"] = map_cu("DashboardFindFile"):with_noremap():with_silent(),
	["n|<Leader>fg"] = map_cu("Telescope git_files"):with_noremap():with_silent(),
	["n|<Leader>fw"] = map_cu("Telescope grep_string"):with_noremap():with_silent(),
	["n|<Leader>fh"] = map_cu("DashboardFindHistory"):with_noremap():with_silent(),
	["n|<Leader>fl"] = map_cu("Telescope loclist"):with_noremap():with_silent(),
	["n|<Leader>fc"] = map_cu("Telescope git_commits"):with_noremap():with_silent(),
	["n|<Leader>ft"] = map_cu("Telescope help_tags"):with_noremap():with_silent(),
	["n|<Leader>fd"] = map_cu("Telescope dotfiles path=" .. os.getenv("HOME") .. "/.config/nvim")
		:with_noremap()
		:with_silent(),
	["n|<Leader>qf"] = map_cu("Telescope lsp_workspace_diagnostics"):with_noremap():with_silent(),
	["n|<Leader>fs"] = map_cr("<cmd> lua require'telescope'.extensions.ultisnips.ultisnips{}<CR>")
		:with_noremap()
		:with_silent(),

	-- Plugin acceleratedjk
	["n|j"] = map_cmd('v:lua.enhance_jk_move("j")'):with_silent():with_expr(),
	["n|k"] = map_cmd('v:lua.enhance_jk_move("k")'):with_silent():with_expr(),
	-- Plugin QuickRun
	-- ["n|<Leader>r"]     = map_cr("<cmd> lua require'internal.quickrun'.run_command()"):with_noremap():with_silent(),
	-- Plugin Vista or SymbolsOutline
	["n|<Leader>v"] = map_cu("SymbolsOutline"):with_noremap():with_silent(),

	["n|<Leader><TAB>"] = map_cr('<CMD>lua require("FTerm").toggle()<CR>'):with_noremap():with_silent(),

	["t|<Leader><TAB>"] = map_cr('<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>'):with_noremap():with_silent(),

	-- Plugin vim_niceblock
	["x|I"] = map_cmd("v:lua.enhance_nice_block('I')"):with_expr(),
	["x|gI"] = map_cmd("v:lua.enhance_nice_block('gI')"):with_expr(),
	["x|A"] = map_cmd("v:lua.enhance_nice_block('A')"):with_expr(),

	-- Plugin for debugigng
	["n|<F4>"] = map_cu("Telescope dap commands"):with_noremap():with_silent(),
	["n|<Leader>dd"] = map_cu("lua require('dap').continue()"):with_noremap():with_silent(),
	["n|<Leader>vv"] = map_cu("Telescope treesitter"):with_noremap():with_silent(),

	--Nice finder
	["n|<Leader><Leader><Leader>"] = map_cr("<Cmd>lua require('telescope').extensions.frecency.frecency()<CR>")
		:with_noremap()
		:with_silent(),

	-- git Blame
	["n|<Leader><Leader>tgb"] = map_cu("ToggleBlameLine"):with_noremap():with_silent(),

	-- Nice command to list all breakpoints. .
	["n|<Leader>lb"] = map_cr("Telescope dap list_breakpoints"):with_noremap():with_silent(),

	["n|<Leader>do"] = map_cr("<cmd> lua require'dap'.step_over()<CR>"):with_noremap():with_silent(),
	["n|<Leader>di"] = map_cr("<cmd> lua require'dap'.step_into()<CR>"):with_noremap():with_silent(),
	["n|<Leader>dO"] = map_cr("<cmd> lua require'dap'.step_out()<CR>"):with_noremap():with_silent(),
	["n|<Leader>b"] = map_cr("<cmd> lua require'dap'.toggle_breakpoint()<CR>"):with_noremap():with_silent(),
	["n|<Leader>dr"] = map_cr("<cmd> lua require'dap'.repl.open()<CR>"):with_noremap():with_silent(),
	["n|<Leader>drr"] = map_cr('<cmd> lua require"dap".repl.toggle({width = 50}, "belowright vsplit")<cr>')
		:with_noremap()
		:with_silent(),
	["n|<Leader>dl"] = map_cr("<cmd> lua require'dap'.repl.run_last()<CR>"):with_noremap():with_silent(),
	["n|<Leader>xr"] = map_cr("<Cmd>lua require('dapui').eval()<CR>"):with_noremap():with_silent(),
	["n|C"] = map_cr('<cmd>lua require"dap".run_to_cursor()<CR>'):with_noremap():with_silent(),

	["n|<LeftMouse>"] = map_cmd("<LeftMouse><cmd>lua vim.lsp.buf.hover()<CR>"):with_noremap():with_silent(),
	["n|<RightMouse>"] = map_cmd("<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>"):with_noremap():with_silent(),

	["n|<C-ScrollWheelUp>"] = map_cmd("<C-i>"):with_noremap():with_silent(),
	["n|<C-ScrollWheelDown>"] = map_cmd("<C-o>"):with_noremap():with_silent(),

	-- Nice animation
	["n|<Up>"] = map_cmd("<cmd> call animate#window_delta_height(10)<CR>"):with_noremap():with_silent(),
	["n|<Down>"] = map_cmd("<cmd> call animate#window_delta_height(-10)<CR>"):with_noremap():with_silent(),
	["n|<Left>"] = map_cmd("<cmd> call animate#window_delta_width(10)<CR>"):with_noremap():with_silent(),
	["n|<Right>"] = map_cmd("<cmd> call animate#window_delta_width(-10)<CR>"):with_noremap():with_silent(),

	["v|<Leader>fr"] = map_cmd("<Plug>SnipRun"):with_silent(),
	["n|<Leader>fr"] = map_cmd("<Plug>SnipRunOperator"):with_silent(),
	["n|<Leader>ff"] = map_cmd("<Plug>SnipRun"):with_silent(),

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
	["n|<Leader>xw"] = map_cr("<cmd>Trouble lsp_workspace_diagnostics<CR>"):with_noremap():with_silent(),
	["n|<Leader>xd"] = map_cr("<cmd>Trouble lsp_document_diagnostics<CR>"):with_noremap():with_silent(),
	["n|<Leader>xl"] = map_cr("<cmd>Trouble loclist<CR>"):with_noremap():with_silent(),
	["n|<Leader>xf"] = map_cr("<cmd>Trouble quickfix<CR>"):with_noremap():with_silent(),
	["n|<Leader>xR"] = map_cr("<cmd>Trouble lsp_references<CR>"):with_noremap():with_silent(),

	-- Nice highlighting for latex when writing notes
	["n|<Leader><F9>"] = map_cu('lua require("nabla").place_inline()<CR>'):with_noremap():with_silent(),
	-- $ ... $ : inline form
	-- $$ ... $$ : wrapped form
	["v|<F3>"] = map_cmd(":<c-u>HSHighlight 3<CR>"):with_noremap():with_silent(),
	--Remove highlight
	["v|<F4>"] = map_cmd(":<c-u>HSRmHighlight<CR>"):with_noremap():with_silent(),

	-- Next other buffers with this one .
	["n|<Leader>bth"] = map_cr("BDelete hidden"):with_silent():with_nowait():with_noremap(),
	["n|<Leader>btu"] = map_cr("BDelete! nameless"):with_silent():with_nowait():with_noremap(),
	["n|<Leader>btc"] = map_cr("BDelete! this"):with_silent():with_nowait():with_noremap(),

	["n|<Leader>bw"] = map_cr("BWipeout! all"):with_silent():with_nowait():with_noremap(),
	["n|<Leader>bc"] = map_cr("BWipeout!"):with_silent():with_nowait():with_noremap(),

	--["n|<Leader>bc"]  = map_cr("Bdelete"):with_noremap():with_silent(),
	--["n|<Leader>bw"]  = map_cr("Bwipeout"):with_noremap():with_silent(),

	["n|<Leader>bo"] = map_cr("<cmd>lua require('internal.utils').only()<CR>")
		:with_silent()
		:with_nowait()
		:with_noremap(),
	["n|<Leader>bv"] = map_cr("BufferLinePick"):with_noremap():with_silent(),
	["n|<Leader>b["] = map_cr("BufferLineMoveNext"):with_noremap():with_silent(),
	["n|<Leader>b]"] = map_cr("BufferLineMovePrev"):with_noremap():with_silent(),
	["n|<Leader>bnn"] = map_cr("BufferLineCycleNext"):with_noremap():with_silent(),
	["n|<Leader>bmm"] = map_cr("BufferLineCyclePrev"):with_noremap():with_silent(),
	["n|bg"] = map_cr("BufferLinePick"):with_noremap():with_silent(),

	["n|<Leader>ot"] = map_cr("OneTerm"):with_noremap():with_silent(),
}

bind.nvim_load_mapping(plug_map)

-- mx              Set mark x
-- m,              Set the next available alphabetical (lowercase) mark
-- m;              Toggle the next available mark at the current line
-- dmx             Delete mark x
-- dm-             Delete all marks on the current line
-- dm<space>       Delete all marks in the current buffer
-- m]              Move to next mark
-- m[              Move to previous mark
-- m:              Preview mark. This will prompt you for a specific mark to
--                 preview; press <cr> to preview the next mark.

-- m[0-9]          Add a bookmark from bookmark group[0-9].
-- dm[0-9]         Delete all bookmarks from bookmark group[0-9].
-- m}              Move to the next bookmark having the same type as the bookmark under
--                 the cursor. Works across buffers.
-- m{              Move to the previous bookmark having the same type as the bookmark under
--                 the cursor. Works across buffers.
-- dm=             Delete the bookmark under the cursor.
