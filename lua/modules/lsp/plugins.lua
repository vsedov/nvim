local conf = require("modules.lsp.config")
local lsp = require("core.pack").package
local prettier = { "prettierd", "prettier" }
local slow_format_filetypes = {}


lsp({
    "neovim/nvim-lspconfig",
    lazy = true,
})

lsp({
    "jose-elias-alvarez/null-ls.nvim",
    cond = lambda.config.lsp.lint_formatting.use_null_ls, -- need to find a replacement for this asap
    lazy = true,
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "poljar/typos.nvim", cond = lambda.config.lsp.use_typos, config = true },

        "jayp0521/mason-null-ls.nvim",
    },
    config = function()
        require("modules.lsp.lsp.null-ls").setup()
        require("mason-null-ls").setup({
            automatic_installation = true,
        })
        require("modules.lsp.lsp.config").setup()
    end,
})

lsp({
    "dense-analysis/ale",
    cond = lambda.config.lsp.lint_formatting.use_ale,
    event = { "BufReadPre", "BufNewFile" },
    config = require("modules.lsp.lint_format").ale,
})
lsp({
    "mfussenegger/nvim-lint",
    opts = {
        linters_by_ft = {
            javascript = { "eslint_d" },
            ["javascript.jsx"] = { "eslint_d" },
            javascriptreact = { "eslint_d" },
            lua = { "luacheck" },
            python = lambda.config.lsp.python.lint,
            rst = { "rstlint" },
            sh = { "shellcheck" },
            typescript = { "eslint_d" },
            ["typescript.tsx"] = { "eslint_d" },
            typescriptreact = { "eslint_d" },
            vim = { "vint" },
            yaml = { "yamllint" },
        },
        linters = {},
    },

    config = require("modules.lsp.lint_format").nvim_lint,
})

lsp({
    "stevearc/conform.nvim",
    cond = lambda.config.lsp.lint_formatting.use_conform,
    cmd = { "ConformInfo" },
    keys = {
        {
            ";;f",
            function()
                require("conform").format({
                    async = true,
                    lsp_fallback = require("modules.lsp.lint_format").get_lsp_fallback(0),
                })
            end,
            mode = "",
            desc = "Format buffer",
        },
    },
    opts ={
        formatters_by_ft = {
            python = lambda.config.lsp.python.format,
            lua = { "stylua" },
            go = { "goimports", "gofmt" },
            sh = { "shfmt" },
            zig = { "zigfmt" },
            ["_"] = { "trim_whitespace", "trim_newlines" },
        },

        format_on_save = function(bufnr)
            if slow_format_filetypes[vim.bo[bufnr].filetype] then
                return
            end
            local function on_format(err)
                if err and err:match("timed out$") then
                    slow_format_filetypes[vim.bo[bufnr].filetype] = true
                end
            end

            return { timeout_ms =500, lsp_fallback = require("modules.lsp.lint_format").get_lsp_fallback(bufnr) }, on_format
        end,
        format_after_save = function(bufnr)
            if not slow_format_filetypes[vim.bo[bufnr].filetype] then
                return
            end
            return { lsp_fallback =  require("modules.lsp.lint_format").get_lsp_fallback(bufnr) }
        end,
    },
    config = require("modules.lsp.lint_format").conform,
})

lsp({
    "williamboman/mason.nvim",
    -- event = "VeryLazy",
    dependencies = {
        "neovim/nvim-lspconfig",
        "williamboman/mason-lspconfig.nvim",
    },
    config = conf.mason_setup,
})

lsp({ "ii14/lsp-command", lazy = true, cmd = { "Lsp" } })

lsp({
    "p00f/clangd_extensions.nvim",
    lazy = true,
    ft = { "c", "cpp" },
    dependencies = "nvim-lspconfig",
    config = conf.clangd,
})

-- NOTE: (vsedov) (20:56:48 - 27/07/23): Does not work if you have multiple language clients
lsp({ "lewis6991/hover.nvim", lazy = true, config = conf.hover })

lsp({
    "glepnir/lspsaga.nvim",
    cond = not lambda.config.lsp.use_navigator,
    event = "VeryLazy",
    cmd = { "Lspsaga" },
    lazy = true,
    config = conf.saga,
    dependencies = "neovim/nvim-lspconfig",
})
lsp({
    "sourcegraph/sg.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    build = "cargo build --workspace",
    config = function()
        -- nnoremap <space>ss <cmd>lua require('sg.extensions.telescope').fuzzy_search_results()<CR>
        vim.keymap.set(
            "n",
            "<leader>ss",
            "<cmd>lua require('sg.extensions.telescope').fuzzy_search_results()<cr>",
            { desc = "Cody Fuzzy results" }
        )
        -- Toggle cody chat
        vim.keymap.set("n", "<space>cc", function()
            require("sg.cody.commands").toggle()
        end, { desc = "Cody Commands" })

        vim.keymap.set("n", "<space>cn", function()
            local name = vim.fn.input("chat name: ")
            require("sg.cody.commands").chat(name)
        end, { desc = "Cody Commands" })
        vim.keymap.set("v", "<space>a", ":CodyContext<CR>", { desc = "Cody Context" })
        vim.keymap.set("v", "<space>w", ":CodyExplain<CR>", { desc = "Cody Explain" })

        vim.keymap.set("n", "<space>ss", function()
            require("sg.extensions.telescope").fuzzy_search_results()
        end, { desc = "Sg Extension tele" })
    end,
})

lsp({
    "ray-x/lsp_signature.nvim",
    lazy = true,
    cond = lambda.config.lsp.lsp_sig.use_lsp_signature and not lambda.config.folke.noice.lsp.use_noice_signature,
    event = "VeryLazy",
    config = conf.lsp_sig,
})

lsp({
    "aznhe21/actions-preview.nvim",
    lazy = true,
    keys = {
        {
            "\\;",
            function()
                require("actions-preview").code_actions()
            end,
            desc = "lsp: code actions",
            mode = { "n", "v" },
        },
    },
    config = function()
        require("actions-preview").setup({
            -- options for vim.diff(): https://neovim.io/doc/user/lua.html#vim.diff()
            diff = {
                ctxlen = 3,
            },
            backend = { "telescope", "nui" },
            -- options for telescope.nvim: https://github.com/nvim-telescope/telescope.nvim#themes
            telescope = require("telescope.themes").get_dropdown(),
        })
    end,
})

lsp({
    "joechrisellis/lsp-format-modifications.nvim",
    lazy = true,
})

lsp({
    "smjonas/inc-rename.nvim",
    lazy = true,
    opts = { hl_group = "Visual", preview_empty_name = true },
    keys = {
        {
            "<leader>gr",
            function()
                return string.format(":IncRename %s", vim.fn.expand("<cword>"))
            end,
            expr = true,
            silent = false,
            desc = "lsp: incremental rename",
        },
    },
})

lsp({
    "cseickel/diagnostic-window.nvim",
    cmd = "DiagWindowShow",
    dependencies = { "MunifTanjim/nui.nvim" },
})
lsp({
    "liuchengxu/vista.vim",
    cmd = { "Vista" },
    config = conf.vista,
})

lsp({
    "dnlhc/glance.nvim",
    lazy = true,
    cmd = "Glance",
    config = conf.glance,
})

lsp({
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    cond = lambda.config.lsp.diagnostics.use_lsp_lines,
    lazy = true,
    event = "LspAttach",
    config = function()
        lambda.highlight.plugin("Lines", {
            { DiagnosticVirtualTextWarn = { bg = "NONE" } },
            { DiagnosticVirtualTextError = { bg = "NONE" } },
            { DiagnosticVirtualTextInfo = { bg = "NONE" } },
            { DiagnosticVirtualTextHint = { bg = "NONE" } },
        })

        require("lsp_lines").setup()

        vim.keymap.set("", "<Leader>L", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
    end,
})
-- rhs  upside diagnostics
lsp({
    "dgagn/diagflow.nvim",
    cond = lambda.config.lsp.diagnostics.use_rcd,
    event = "VeryLazy",
    opts = {
        placement = "inline",
        inline_padding_left = 3,
        toggle_event = { "InsertEnter" },
        update_event = { "DiagnosticChanged" },
    },
})

lsp({
    "VidocqH/lsp-lens.nvim",
    lazy = true,
    cmd = { "LspLensOn", "LspLensOff", "LspLensToggle" },
    event = "LspAttach",
    opts = {
        enable = false, -- enable through lsp
        include_declaration = true, -- Reference include declaration
        sections = {
            -- Enable / Disable specific request
            definition = true,
            references = true,
            implementation = true,
        },
        ignore_filetype = {
            "prisma",
            "lua", -- It already has its own inlay ints
        },
    },
})

lsp({
    "KostkaBrukowa/definition-or-references.nvim",
    lazy = true,
    config = conf.definition_or_reference,
})

lsp({
    "neovim/nvimdev.nvim",
    ft = "lua",
    init = conf.nvimdev,
})

lsp({
    "yorickpeterse/nvim-dd",
    event = { "LspAttach" },
    config = true,
})
lsp({ "onsails/lspkind.nvim", lazy = true })
lsp({
    "askfiy/lsp_extra_dim",
    cond = lambda.config.lsp.use_lsp_dim,
    event = { "LspAttach" },
    opts = {
        disable_diagnostic_style = "all",
    },
})
lsp({
    "ivanjermakov/troublesum.nvim",
    event = { "LspAttach" },
    config = true,
})
