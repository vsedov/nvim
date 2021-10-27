local config = {}

local function load_env_file()
	local env_file = os.getenv("HOME") .. "/.env"
	local env_contents = {}
	if vim.fn.filereadable(env_file) ~= 1 then
		print(".env file does not exist")
		return
	end
	local contents = vim.fn.readfile(env_file)
	for _, item in pairs(contents) do
		local line_content = vim.fn.split(item, "=")
		env_contents[line_content[1]] = line_content[2]
	end
	return env_contents
end

local function load_dbs()
	local env_contents = load_env_file()
	local dbs = {}
	for key, value in pairs(env_contents) do
		if vim.fn.stridx(key, "DB_CONNECTION_") >= 0 then
			local db_name = vim.fn.split(key, "_")[3]:lower()
			dbs[db_name] = value
		end
	end
	return dbs
end

function config.neogit()
	local neogit = require("neogit")
	neogit.setup({})
end

function config.highlight()
	require("highlight_current_n").setup({
		highlight_group = "IncSearch", -- highlight group name to use for highlight
	})

	vim.api.nvim_set_keymap("n", "n", "<Plug>(highlight-current-n-n)", { silent = true })
	vim.api.nvim_set_keymap("n", "N", "<Plug>(highlight-current-n-N)", { silent = true })
end

function config.vim_dadbod_ui()
	if packer_plugins["vim-dadbod"] and not packer_plugins["vim-dadbod"].loaded then
		vim.cmd([[packadd vim-dadbod]])
	end
	vim.g.db_ui_show_help = 0
	vim.g.db_ui_win_position = "left"
	vim.g.db_ui_use_nerd_fonts = 1
	vim.g.db_ui_winwidth = 35
	vim.g.db_ui_save_location = os.getenv("HOME") .. "/.cache/vim/db_ui_queries"
	vim.g.dbs = load_dbs()
end

function config.sybolsoutline()
	vim.g.symbols_outline = {
		highlight_hovered_item = false,
		show_guides = true,
		auto_preview = true,
		position = "right",
		show_numbers = false,
		show_relative_numbers = false,
		show_symbol_details = true,
		keymaps = {
			close = "<Esc>",
			goto_location = "<Cr>",
			focus_location = "o",
			hover_symbol = "<C-space>",
			rename_symbol = "r",
			code_actions = "a",
		},
		lsp_blacklist = {},
	}
end

function config.vim_vista()
	vim.g["vista#renderer#enable_icon"] = 1
	vim.g.vista_disable_statusline = 1
	vim.g.vista_default_executive = "nvim_lsp"
	vim.g.vista_echo_cursor_strategy = "floating_win"
	vim.g.vista_vimwiki_executive = "markdown"
	vim.g.vista_executive_for = {
		vimwiki = "markdown",
		pandoc = "markdown",
		markdown = "toc",
		typescript = "nvim_lsp",
		python = "nvim_lsp",
		c = "nvim_lsp",
	}
end

function config.SymbolsOutline()
	vim.g.symbols_outline = {
		highlight_hovered_item = true,
		show_guides = true,
		auto_preview = true,
		position = "right",
		show_numbers = false,
		show_relative_numbers = false,
		show_symbol_details = true,
		keymaps = {
			close = "<Esc>",
			goto_location = "<Cr>",
			focus_location = "o",
			hover_symbol = "<C-space>",
			rename_symbol = "r",
			code_actions = "a",
		},
		lsp_blacklist = {},
	}
end

function config.clap()
	vim.g.clap_preview_size = 10
	vim.g.airline_powerline_fonts = 1
	vim.g.clap_layout = { width = "80%", row = "8%", col = "10%", height = "34%" } -- height = "40%", row = "17%", relative = "editor",
	-- vim.g.clap_popup_border = "rounded"
	vim.g.clap_selected_sign = { text = "", texthl = "ClapSelectedSign", linehl = "ClapSelected" }
	vim.g.clap_current_selection_sign = {
		text = "",
		texthl = "ClapCurrentSelectionSign",
		linehl = "ClapCurrentSelection",
	}
	-- vim.g.clap_always_open_preview = true
	vim.g.clap_preview_direction = "UD"
	-- if vim.g.colors_name == 'zephyr' then
	vim.g.clap_theme = "material_design_dark"
	vim.api.nvim_command(
		"autocmd FileType clap_input lua require'cmp'.setup.buffer { completion = {autocomplete = false} }"
	)
	-- end
	-- vim.api.nvim_command("autocmd FileType clap_input call compe#setup({ 'enabled': v:false }, 0)")
end

function config.clap_after()
	if not packer_plugins["nvim-cmp"].loaded then
		require("packer").loader("nvim-cmp")
	end
end

function config.session()
	local opts = {
		log_level = "info",
		auto_session_enable_last_session = false,
		auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
		auto_session_enabled = true,
		auto_save_enabled = nil,
		auto_restore_enabled = nil,
		auto_session_suppress_dirs = nil,
	}
	require("auto-session").setup(opts)
end

function config.wilder()
	vim.cmd([[
call wilder#setup({'modes': [':', '/', '?']})
call wilder#set_option('use_python_remote_plugin', 0)
call wilder#set_option('pipeline', [wilder#branch(wilder#cmdline_pipeline({'use_python': 0,'fuzzy': 1, 'fuzzy_filter': wilder#lua_fzy_filter()}),wilder#vim_search_pipeline(), [wilder#check({_, x -> empty(x)}), wilder#history(), wilder#result({'draw': [{_, x -> ' ' . x}]})])])
call wilder#set_option('renderer', wilder#renderer_mux({':': wilder#popupmenu_renderer({'highlighter': wilder#lua_fzy_highlighter(), 'left': [wilder#popupmenu_devicons()], 'right': [' ', wilder#popupmenu_scrollbar()]}), '/': wilder#wildmenu_renderer({'highlighter': wilder#lua_fzy_highlighter()})}))
]])
end

function config.outline()
	-- init.lua
	vim.g.symbols_outline = {
		highlight_hovered_item = false,
		show_guides = true,
		auto_preview = true,
		position = "right",
		width = 25,
		show_numbers = false,
		show_relative_numbers = false,
		show_symbol_details = true,
		keymaps = {
			close = "<Esc>",
			goto_location = "<Cr>",
			focus_location = "o",
			hover_symbol = "<C-space>",
			rename_symbol = "r",
			code_actions = "a",
		},
		lsp_blacklist = {},
		symbols = {
			File = { icon = "", hl = "TSURI" },
			Module = { icon = "", hl = "TSNamespace" },
			Namespace = { icon = "", hl = "TSNamespace" },
			Package = { icon = "", hl = "TSNamespace" },
			Class = { icon = "𝓒", hl = "TSType" },
			Method = { icon = "ƒ", hl = "TSMethod" },
			Property = { icon = "", hl = "TSMethod" },
			Field = { icon = "", hl = "TSField" },
			Constructor = { icon = "", hl = "TSConstructor" },
			Enum = { icon = "ℰ", hl = "TSType" },
			Interface = { icon = "ﰮ", hl = "TSType" },
			Function = { icon = "", hl = "TSFunction" },
			Variable = { icon = "", hl = "TSConstant" },
			Constant = { icon = "", hl = "TSConstant" },
			String = { icon = "𝓐", hl = "TSString" },
			Number = { icon = "#", hl = "TSNumber" },
			Boolean = { icon = "⊨", hl = "TSBoolean" },
			Array = { icon = "", hl = "TSConstant" },
			Object = { icon = "⦿", hl = "TSType" },
			Key = { icon = "🔐", hl = "TSType" },
			Null = { icon = "NULL", hl = "TSType" },
			EnumMember = { icon = "", hl = "TSField" },
			Struct = { icon = "𝓢", hl = "TSType" },
			Event = { icon = "🗲", hl = "TSType" },
			Operator = { icon = "+", hl = "TSOperator" },
			TypeParameter = { icon = "𝙏", hl = "TSParameter" },
		},
	}
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
		toggler = {
			---line-comment keymap
			line = "gcc",
			---block-comment keymap
			block = "gbc",
		},

		opleader = {
			line = "gc",
			block = "gb",
		},

		pre_hook = nil,
		post_hook = nil,
	})

	local ft = require("Comment.ft")

	-- 1. Using set function

	-- set both line and block commentstring
	ft.set("python", { "#%s", '"""%s"""' })
end

function config.numb()
	require("numb").setup({
		show_numbers = true, -- Enable 'number' for the window while peeking
		show_cursorline = true, -- Enable 'cursorline' for the window while peeking

		number_only = true, -- Peek only when the command is only a number instead of when it starts with a number
	})
end

function config.paperplanes()
	require("paperplanes").setup({
		register = "+",
		provider = "dpaste.org",
	})
end

function config.clipboard()
	require("neoclip").setup({
		history = 1000,
		enable_persistant_history = true,
		db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
		filter = nil,
		preview = true,
		default_register = "+",
		content_spec_column = true,
		on_paste = {
			set_reg = true,
		},
		keys = {
			i = {
				select = "<cr>",
				paste = "<c-p>",
				paste_behind = "<c-k>",
				custom = {},
			},
			n = {
				select = "<cr>",
				paste = "p",
				paste_behind = "P",
			},
		},
	})
end

return config
