local ui = {}
local conf = require("modules.ui.config")
local winwidth = function()
	return vim.api.nvim_call_function("winwidth", { 0 })
end

ui["kyazdani42/nvim-web-devicons"] = {}
ui["lambdalisue/glyph-palette.vim"] = {}

ui["folke/tokyonight.nvim"] = {
	config = function() end,
}

ui["Pocco81/Catppuccino.nvim"] = {
	config = function()
		require("catppuccino").setup({
			colorscheme = "dark_catppuccino",
			transparency = true,
			-- term_colors = true,
			styles = {
				comments = "italic",
				functions = "italic",
				keywords = "italic",
				strings = "NONE",
				variables = "NONE",
			},
			integrations = {
				treesitter = true,
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = "italic",
						hints = "italic",
						warnings = "italic",
						information = "italic",
					},
					underlines = {
						errors = "underline",
						hints = "underline",
						warnings = "underline",
						information = "underline",
					},
				},
				lsp_trouble = true,
				lsp_saga = true,
				gitgutter = true,
				gitsigns = true,
				telescope = true,
				nvimtree = {
					enabled = true,
					show_root = true,
				},
				which_key = true,
				indent_blankline = {
					enabled = true,
					colored_indent_levels = true,
				},
				dashboard = true,
				neogit = true,
				vim_sneak = true,
				fern = true,
				barbar = false,
				bufferline = true,
				markdown = true,
				lightspeed = true,
				ts_rainbow = true,
				hop = true,
			},
		})
		vim.cmd([[colorscheme catppuccino]])
	end,
}

ui["https://github.com/numToStr/Sakura.nvim"] = {
	config = function()
		-- vim.cmd([[colorscheme sakura]])
	end,
}

ui["glepnir/dashboard-nvim"] = {
	config = conf.dashboard,
}

ui["NTBBloodbath/galaxyline.nvim"] = {
	branch = "main",
	config = conf.galaxyline,
	requires = "kyazdani42/nvim-web-devicons",
}

-- ui["windwp/windline.nvim"] = {
--   event = "UIEnter",
--   config = conf.windline,
--   -- requires = {'kyazdani42/nvim-web-devicons'},
--   opt = true
-- }

ui["lambdalisue/glyph-palette.vim"] = {}

ui["lukas-reineke/indent-blankline.nvim"] = {
	config = conf.indent_blakline,
}

ui["NFrid/due.nvim"] = {
	config = function()
		require("due_nvim").setup({})
	end,
}

ui["akinsho/bufferline.nvim"] = {
	config = conf.nvim_bufferline,
	event = "UIEnter",
	requires = { "kyazdani42/nvim-web-devicons" },
	opt = true,
}

ui["kazhala/close-buffers.nvim"] = {
	config = conf.buffers_close,
}

-- legit stoped working
ui["kyazdani42/nvim-tree.lua"] = {
	requires = { "kyazdani42/nvim-web-devicons" },
	config = conf.nvim_tree,
}

ui["lewis6991/gitsigns.nvim"] = {
	event = { "BufRead", "BufNewFile" },
	config = conf.gitsigns,
	requires = { "nvim-lua/plenary.nvim", opt = true },
}

-- For now this kinda breaks the treesitter ocnfig
ui["beauwilliams/focus.nvim"] = {
	opt = true,
	cmd = { "FocusSplitNicely", "FocusSplitCycle", "FocusMaximise", "FocusToggle", "FocusEqualise" },
	config = function()
		require("focus").setup({
			tmux = false,
			hybridnumber = true,
			signcolumn = "number",
			bufnew = false,
			cursorline = false,
			signcolumn = false,
		})
		vim.api.nvim_set_keymap("n", "<leader>hh", ":FocusMaximise<CR>", { silent = true })

		vim.api.nvim_set_keymap("n", "<Leader>kk", ":lua require('focus').split_nicely()<CR>", { silent = true })

		local focusmap = function(direction)
			vim.api.nvim_set_keymap(
				"n",
				"<Leader>" .. direction,
				":lua require'focus'.split_command('" .. direction .. "')<CR>",
				{ silent = true }
			)
		end
		-- Use `<Leader>h` to split the screen to the left, same as command FocusSplitLeft etc
		focusmap("h")
		focusmap("j")
		focusmap("k")
		focusmap("l")

		vim.cmd("hi link UnfocusedWindow CursorLine")
		vim.cmd("hi link FocusedWindow VisualNOS")
	end,
}

-- ui["dstein64/nvim-scrollview"] = { config = conf.scrollview }

ui["Pocco81/TrueZen.nvim"] = {
	config = conf.truezen,
}

ui["folke/zen-mode.nvim"] = {

	config = function()
		require("zen-mode").setup({
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		})
	end,
}

ui["wfxr/minimap.vim"] = {
	run = ":!cargo install --locked code-minimap --force",
	setup = conf.minimap,
}

ui["folke/twilight.nvim"] = {}

return ui
