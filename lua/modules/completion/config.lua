local config = {}

function config.nvim_lsp()
	require("modules.completion.lspconfig")
end

function config.cmp()
	local cmp = require("cmp")
	local fn = vim.fn
	local utils = require("modules.completion.misc")

	vim.g.copilot_no_tab_map = true
	vim.g.copilot_assume_mapped = true
	vim.g.copilot_tab_fallback = ""

	local sources = {
		{ name = "luasnip" },
		{ name = "nvim_lsp" },
		{ name = "cmp_tabnine" },
		{ name = "treesitter", keyword_length = 2 },
		{ name = "look", keyword_length = 4 },
		{ name = "cmp_git" },
		{ name = "buffer" },
		{ name = "ultisnips" },
		{ name = "nvim_lua" },
		{ name = "path" },
		{ name = "spell" },
		{ name = "tmux" },
		{ name = "calc" },
		{ name = "neorg" },
	}

	if vim.o.ft == "sql" then
		table.insert(sources, { name = "vim-dadbod-completion" })
	end
	if vim.o.ft == "markdown" then
		table.insert(sources, { name = "spell" })
		table.insert(sources, { name = "look" })
	end

	cmp.setup({
		completion = {
			autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
			completeopt = "menu,menuone,noselect",
		},

		formatting = {
			format = function(entry, vim_item)
				local lspkind_icons = {
					Text = "",
					Method = "",
					Function = "",
					Constructor = "",
					Field = "ﰠ",
					Variable = "",
					Class = "ﴯ",
					Interface = "",
					Module = "",
					Property = "ﰠ",
					Unit = "塞",
					Value = "",
					Enum = "",
					Keyword = "",
					Snippet = "",
					Color = "",
					File = "",
					Reference = "",
					Folder = "",
					EnumMember = "",
					Constant = "",
					Struct = "פּ",
					Event = "",
					Operator = "",
					TypeParameter = "",
				}

				-- load lspkind icons
				vim_item.kind = string.format("%s %s", lspkind_icons[vim_item.kind], vim_item.kind)

				vim_item.menu = ({
					cmp_tabnine = "[TN]",
					nvim_lsp = "[LSP]",
					nvim_lua = "[Lua]",
					buffer = "[BUF]",
					path = "[PATH]",
					tmux = "[TMUX]",
					luasnip = "[SNIP]",
					ultisnips = "[UltiSnips]",
					spell = "[SPELL]",
					-- rg = "[RG]",
				})[entry.source.name]

				return vim_item
			end,
		},
		sorting = {
			comparators = {
				cmp.config.compare.offset,
				cmp.config.compare.exact,
				cmp.config.compare.score,
				require("cmp-under-comparator").under,
				cmp.config.compare.kind,
				cmp.config.compare.sort_text,
				cmp.config.compare.length,
				cmp.config.compare.order,
			},
		},
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		preselect = cmp.PreselectMode.None,
		experimental = {
			ghost_text = true,
			native_menu = false,
		},
		mapping = {
			["<C-e>"] = cmp.mapping.close(),
			["<C-p>"] = cmp.mapping.select_prev_item(),
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<C-d>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = function()
				if cmp.visible() then
					cmp.close()
				else
					cmp.complete()
				end
			end,
			["<CR>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = false,
			}),
			["<Tab>"] = cmp.mapping(function()
				if cmp.visible() then
					cmp.select_next_item()
				elseif utils.invalid_prev_col() then
					fn.feedkeys(utils.t("<Tab>"), "n")
				elseif require("luasnip").expand_or_jumpable() then
					fn.feedkeys(utils.t("<Plug>luasnip-expand-or-jump"), "")
				else
					fn.feedkeys(utils.t("<Tab>"), "n")
				end
			end, {
				"i",
				"s",
			}),

			["<C-L>"] = cmp.mapping(function(fallback)
				local copilot_keys = vim.fn["copilot#Accept"]()
				if copilot_keys ~= "" then
					vim.api.nvim_feedkeys(copilot_keys, "i", true)
				else
					fallback()
				end
			end, {
				"i",
				"s",
			}),

			["<S-Tab>"] = cmp.mapping(function()
				if cmp.visible() then
					cmp.select_prev_item()
				elseif require("luasnip").jumpable(-1) then
					fn.feedkeys(utils.t("<Plug>luasnip-jump-prev"), "")
				else
					fn.feedkeys(utils.t("<C-d>"), "n")
				end
			end, {
				"i",
				"s",
			}),
		},

		-- You should specify your *installed* sources.
		sources = sources,
	})
	if vim.o.ft == "clap_input" or vim.o.ft == "guihua" or vim.o.ft == "guihua_rust" then
		require("cmp").setup.buffer({ completion = { enable = false } })
	end
	vim.cmd("autocmd FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }")

	vim.cmd("autocmd FileType clap_input lua require('cmp').setup.buffer { enabled = false }")

	require("cmp_git").setup({
		-- defaults
		filetypes = { "gitcommit" },
		github = {
			issues = {
				filter = "all", -- assigned, created, mentioned, subscribed, all, repos
				limit = 100,
				state = "open", -- open, closed, all
			},
			mentions = {
				limit = 100,
			},
		},
		gitlab = {
			issues = {
				limit = 100,
				state = "opened", -- opened, closed, all
			},
			mentions = {
				limit = 100,
			},
			merge_requests = {
				limit = 100,
				state = "opened", -- opened, closed, locked, merged
			},
		},
	})
end

function config.vim_vsnip()
	vim.g.vsnip_snippet_dir = os.getenv("HOME") .. "/.config/nvim/snippets"
end

function config.goto_preview()
	require("goto-preview").setup({})
end

function config.luasnip()
	print("luasnip")
	local ls = require("luasnip")
	-- require("luasnip.loaders.from_vscode").lazy_load()
	require("luasnip/loaders/from_vscode").load()

	vim.api.nvim_set_keymap("i", "<C-E>", "<Plug>luasnip-next-choice", {})
	vim.api.nvim_set_keymap("s", "<C-E>", "<Plug>luasnip-next-choice", {})
end

function config.tabnine()
	local tabnine = require("cmp_tabnine.config")
	tabnine:setup({

		max_line = 1000,
		max_num_results = 20,
		sort = true,
		run_on_every_keystroke = true,
	})
end

function config.bqf()
	require("bqf").setup({
		auto_enable = true,
		preview = {
			auto_preview = false,
			win_height = 12,
			win_vheight = 12,
			delay_syntax = 80,
			border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
		},
		func_map = {
			vsplit = "",
			ptogglemode = "z,",
			stoggleup = "",
		},
	})
end

function config.jdtls()
	require("modules.completion.jdtls")
end

function config.telescope()
	if not packer_plugins["plenary.nvim"].loaded then
		vim.cmd([[packadd plenary.nvim]])
		vim.cmd([[packadd popup.nvim]])
		vim.cmd([[packadd telescope-fzy-native.nvim]])
	end
	require("utils.telescope").setup()

	-- require("telescope.main")
end

function config.vim_sonictemplate()
	vim.g.sonictemplate_postfix_key = "<C-,>"
	vim.g.sonictemplate_vim_template_dir = os.getenv("HOME") .. "/.config/nvim/template"
end

-- function config.smart_input()
--   require('smartinput').setup {
--     ['go'] = { ';',':=',';' }
--   }
-- end

function config.emmet()
	vim.g.user_emmet_complete_tag = 0
	vim.g.user_emmet_install_global = 0
	vim.g.user_emmet_install_command = 0
	vim.g.user_emmet_mode = "i"
end

function config.neorunner()
	vim.g.runner_c_compiler = "gcc"
	vim.g.runner_cpp_compiler = "g++"
	vim.g.runner_c_options = "-Wall"
	vim.g.runner_cpp_options = "-std=c++11 -Wall"
end
function config.nvim_notify()
	require("notify").setup({
		-- Animation style (see below for details)
		stages = "fade_in_slide_out",

		-- Default timeout for notifications
		timeout = 5000,

		-- For stages that change opacity this is treated as the highlight behind the window
		-- Set this to either a highlight group or an RGB hex value e.g. "#000000"
		background_colour = "#000000",

		-- Icons for the different levels
		icons = {
			ERROR = "",
			WARN = "",
			INFO = "",
			DEBUG = "",
			TRACE = "✎",
		},
	})
end
function config.sniprun()
	require("sniprun").setup({
		selected_interpreters = {}, --# use those instead of the default for the current filetype
		repl_enable = {}, --# enable REPL-like behavior for the given interpreters
		repl_disable = {}, --# disable REPL-like behavior for the given interpreters

		interpreter_options = {}, --# intepreter-specific options, consult docs / :SnipInfo <name>

		--# you can combo different display modes as desired
		display = {
			"VirtualTextErr", --# display error results as virtual text
			"NvimNotify", --# display with the nvim-notify plugin
		},

		--# You can use the same keys to customize whether a sniprun producing
		--# no output should display nothing or '(no output)'
		show_no_output = {
			"Classic",
			"TempFloatingWindow", --# implies LongTempFloatingWindow, which has no effect on its own
		},

		--# miscellaneous compatibility/adjustement settings
		inline_messages = 0, --# inline_message (0/1) is a one-line way to display messages
		--# to workaround sniprun not being able to display anything

		borders = "single", --# display borders around floating windows
		--# possible values are 'none', 'single', 'double', or 'shadow'
	})
end

function config.magma() end

function config.doge()
	vim.g.doge_doc_standard_python = "numpy"
	vim.g.doge_mapping_comment_jump_forward = "<C-n>"
	vim.g.doge_mapping_comment_jump_backward = "C-p>"
end

function config.vimtex()
	vim.g.tex_conceal = "abdgm"

	vim.g.vimtex_fold_enabled = true
	vim.g.vimtex_indent_enabled = true
	vim.g.vimtex_complete_recursive_bib = false
	vim.g.vimtex_view_method = "zathura"
	vim.g.vimtex_complete_close_braces = true
	vim.g.vimtex_quickfix_mode = 2
	vim.g.vimtex_quickfix_open_on_warning = false

	vim.g.vimtex_view_general_options = "-reuse-instance @pdf"

	vim.g.vimtex_delim_changemath_autoformat = true
end

--py - put brackets .
function config.todo_comments()
	if not packer_plugins["plenary.nvim"].loaded then
		vim.cmd([[packadd plenary.nvim]])
	end

	require("todo-comments").setup({
		signs = true, -- show icons in the signs column
		-- keywords recognized as todo comments
		keywords = {
			FIX = {
				icon = " ", -- icon used for the sign, and in search results
				color = "error", -- can be a hex color, or a named color (see below)
				alt = { "FIXME", "BUG", "FIXIT", "FIX", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
				-- signs = false, -- configure signs for some keywords individually
			},
			TODO = { icon = " ", color = "info" },
			HACK = { icon = " ", color = "warning" },
			WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
			PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
			NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
		},
		-- highlighting of the line containing the todo comment
		-- * before: highlights before the keyword (typically comment characters)
		-- * keyword: highlights of the keyword
		-- * after: highlights after the keyword (todo text)
		highlight = {
			before = "", -- "fg" or "bg" or empty
			keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
			after = "fg", -- "fg" or "bg" or empty
			pattern = [[.*<(KEYWORDS)\s*:]], -- pattern used for highlightng (vim regex)
			comments_only = true, -- this applies the pattern only inside comments using `commentstring` option
		},
		-- list of named colors where we try to extract the guifg from the
		-- list of hilight groups or use the hex color if hl not found as a fallback
		colors = {
			error = { "LspDiagnosticsDefaultError", "ErrorMsg", "#DC2626" },
			warning = { "LspDiagnosticsDefaultWarning", "WarningMsg", "#FBBF24" },
			info = { "LspDiagnosticsDefaultInformation", "#2563EB" },
			hint = { "LspDiagnosticsDefaultHint", "#10B981" },
			default = { "Identifier", "#7C3AED" },
		},
		search = {
			command = "rg",
			args = {
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
			},
			-- regex that will be used to match keywords.
			-- don't replace the (KEYWORDS) placeholder
			pattern = [[\b(KEYWORDS):]], -- ripgrep regex
			-- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
		},
	})
end

function config.trouble()
	require("trouble").setup({
		position = "bottom", -- position of the list can be: bottom, top, left, right
		height = 4, -- height of the trouble list when position is top or bottom
		width = 90, -- width of the list when position is left or right
		icons = true, -- use devicons for filenames
		mode = "lsp_document_diagnostics", -- "lsp_workspace_diagnostics", "lsp_document_diagnostics", "quickfix", "lsp_references", "loclist"
		fold_open = "", -- icon used for open folds
		fold_closed = "", -- icon used for closed folds
		action_keys = {
			-- key mappings for actions in the trouble list
			close = "q", -- close the list
			cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
			refresh = "r", -- manually refresh
			jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
			jump_close = { "o" }, -- jump to the diagnostic and close the list
			toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
			toggle_preview = "P", -- toggle auto_preview
			hover = "K", -- opens a small poup with the full multiline message
			preview = "p", -- preview the diagnostic location
			close_folds = { "zM", "zm" }, -- close all folds
			open_folds = { "zR", "zr" }, -- open all folds
			toggle_fold = { "zA", "za" }, -- toggle fold of current file
			previous = "k", -- preview item
			next = "j", -- next item
		},
		indent_lines = true, -- add an indent guide below the fold icons
		auto_open = false, -- automatically open the list when you have diagnostics
		auto_close = false, -- automatically close the list when you have no diagnostics
		auto_preview = true, -- automatyically preview the location of the diagnostic. <esc> to close preview and go back to last window
		auto_fold = true, -- automatically fold a file trouble list at creation
		signs = {
			-- icons / text used for a diagnostic
			error = "",
			warning = "",
			hint = "",
			information = "",
			other = "﫠",
		},
		use_lsp_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
	})
end

function config.ale()
	vim.g.ale_completion_enabled = 0
	vim.g.ale_python_mypy_options = ""
	vim.g.ale_list_window_size = 4
	vim.g.ale_sign_column_always = 0
	vim.g.ale_open_list = 0

	vim.g.ale_set_loclist = 0

	vim.g.ale_set_quickfix = 1
	vim.g.ale_keep_list_window_open = 1
	vim.g.ale_list_vertical = 0

	vim.g.ale_disable_lsp = 1

	vim.g.ale_lint_on_save = 1

	vim.g.ale_sign_error = ""
	vim.g.ale_sign_warning = ""
	vim.g.ale_lint_on_text_changed = 1

	vim.g.ale_echo_msg_format = "[%linter%] %s [%severity%]"

	vim.g.ale_lint_on_insert_leave = 0
	vim.g.ale_lint_on_enter = 0

	vim.g.ale_set_balloons = 1
	vim.g.ale_hover_cursor = 1
	vim.g.ale_hover_to_preview = 1
	vim.g.ale_float_preview = 1
	vim.g.ale_virtualtext_cursor = 1

	vim.g.ale_fix_on_save = 1
	vim.g.ale_fix_on_insert_leave = 0
	vim.g.ale_fix_on_text_changed = "never"
end

function config.AbbrevMan()
	require("abbrev-man").setup({
		load_natural_dictionaries_at_startup = true,
		load_programming_dictionaries_at_startup = true,
		natural_dictionaries = {
			-- Common mistakes i make .
			["nt_en"] = {
				["adn"] = "and",
				["THe"] = "The",
				["my_email"] = "viv.sedov@hotmail.com",
				["maek"] = "make",
				["meake"] = "make",
			},
		},
		programming_dictionaries = {
			["pr_py"] = {
				["printt"] = "print",
				["teh"] = "the",
			},
		},
	})
end

function config.autopairs()
	-- require("nvim-autopairs").setup({ fast_wrap = {} })
	-- require("nvim-autopairs.completion.cmp").setup({
	-- 	map_cr = true,
	-- 	map_complete = true,
	-- })
	--

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

	require("nvim-autopairs.completion.cmp").setup({
		map_cr = true, --  map <CR> on insert mode
		map_complete = true, -- it will auto insert `(` after select function or method item
		auto_select = true,
	})
end

return config
