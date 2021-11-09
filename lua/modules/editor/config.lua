local config = {}

function config.delimimate()
	vim.g.delimitMate_expand_cr = 0
	vim.g.delimitMate_expand_space = 1
	vim.g.delimitMate_smart_quotes = 1
	vim.g.delimitMate_expand_inside_quotes = 0
	vim.api.nvim_command('au FileType markdown let b:delimitMate_nesting_quotes = ["`"]')
end

function config.autopairs()
	local has_autopairs, autopairs = pcall(require, "nvim-autopairs")
	if not has_autopairs then
		print("autopairs not loaded")
		vim.cmd([[packadd nvim-autopairs]])
		has_autopairs, autopairs = pcall(require, "nvim-autopairs")
		if not has_autopairs then
			print("autopairs not installed")
			return
		end
	end
	local npairs = require("nvim-autopairs")
	local Rule = require("nvim-autopairs.rule")
	npairs.setup({
		disable_filetype = { "TelescopePrompt", "guihua", "clap_input" },
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

function config.nvim_colorizer()
	require("colorizer").setup({
		css = { rgb_fn = true },
		scss = { rgb_fn = true },
		sass = { rgb_fn = true },
		stylus = { rgb_fn = true },
		vim = { names = true },
		tmux = { names = false },
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		html = {
			mode = "foreground",
		},
	})
end

function config.vim_cursorwod()
	vim.api.nvim_command("augroup user_plugin_cursorword")
	vim.api.nvim_command("autocmd!")
	vim.api.nvim_command("autocmd FileType NvimTree,lspsagafinder,dashboard,vista let b:cursorword = 0")
	vim.api.nvim_command("autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif")
	vim.api.nvim_command("autocmd InsertEnter * let b:cursorword = 0")
	vim.api.nvim_command("autocmd InsertLeave * let b:cursorword = 1")
	vim.api.nvim_command("augroup END")
end

--Working yay
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

function config.diffview()
	require("modules.editor.diffview")
	vim.g.gitblame_enabled = 0
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
		"sign_column",
		-- 'background',
		"backgroundfull",
		-- 'foreground',
		-- 'foregroundfull'
	}
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
      let g:VM_maps['Find Under'] = '<C-m>'
      let g:VM_maps['Find Subword Under'] = '<C-m>'
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
