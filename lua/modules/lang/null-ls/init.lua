return {
    config = function()
        local null_ls = require("null-ls")
        local lspconfig = require("lspconfig")

        local diagnostics = null_ls.builtins.diagnostics
        local actions = null_ls.builtins.code_actions
        -- local hover = null_ls.builtins.hover
        local sources = {
            null_ls.builtins.formatting.rustfmt,
            null_ls.builtins.formatting.yapf,
            null_ls.builtins.formatting.isort,
            null_ls.builtins.diagnostics.yamllint,
            null_ls.builtins.code_actions.proselint,
            null_ls.builtins.code_actions.refactoring,
            -- hover.dictionary,
            diagnostics.misspell.with({
                filetypes = { "markdown", "text", "txt" },
                args = { "$FILENAME" },
            }),
            diagnostics.write_good.with({
                filetypes = { "markdown", "tex", "" },
                extra_filetypes = { "txt", "text" },
                args = { "--text=$TEXT", "--parse" },
                command = "write-good",
            }),
            diagnostics.proselint.with({
                filetypes = { "markdown", "tex" },
                extra_filetypes = { "txt", "text" },
                command = "proselint",
                args = { "--json" },
            }),
            actions.proselint.with({ filetypes = { "markdown", "tex" }, command = "proselint", args = { "--json" } }),
        }

        local function exist(bin)
            return vim.fn.exepath(bin) ~= ""
        end

        if use_gitsigns() then
            table.insert(sources, null_ls.builtins.code_actions.gitsigns)
        end

        if exist("rustfmt") then
            table.insert(sources, null_ls.builtins.formatting.rustfmt)
        end

        -- latex script
        if exist("latexindent") then
            table.insert(sources, null_ls.builtins.formatting.latexindent)
        end

        -- shell script
        if exist("shellcheck") then
            table.insert(sources, null_ls.builtins.diagnostics.shellcheck)
        end

        -- shell script
        if exist("shfmt") then
            table.insert(sources, null_ls.builtins.formatting.shfmt)
        end

        -- golang
        if exist("golangci-lint") then
            table.insert(sources, null_ls.builtins.diagnostics.golangci_lint)
        end

        -- docker
        if exist("hadolint") then
            table.insert(sources, null_ls.builtins.diagnostics.hadolint)
        end

        if exist("eslint_d") then
            table.insert(sources, null_ls.builtins.diagnostics.eslint_d)
        end
        -- js, ts
        if exist("prettierd") then
            table.insert(sources, null_ls.builtins.formatting.prettierd)
        end
        -- lua
        if exist("selene") then
            table.insert(sources, null_ls.builtins.diagnostics.selene)
        end

        if exist("stylua") then
            table.insert(
                sources,
                null_ls.builtins.formatting.stylua.with({
                    extra_args = { "--config-path", vim.fn.expand("~/.config/stylua.toml") },
                })
            )
        end

        -- luaccheck feels a bit heavy i do not know why
        -- if exist("luacheck") then
        --     table.insert(sources, null_ls.builtins.diagnostics.luacheck)
        -- end

        -- python
        if exist("flake8") then
            table.insert(sources, null_ls.builtins.diagnostics.flake8)
        end

        if exist("vulture") then
            table.insert(sources, null_ls.builtins.diagnostics.vulture)
        end

        if exist("clang-format") then
            table.insert(
                sources,
                null_ls.builtins.formatting.clang_format.with({
                    extra_args = { "-style=file" },
                })
            )
        end

        if exist("cppcheck") then
            table.insert(sources, null_ls.builtins.diagnostics.cppcheck)
        end

        -- table.insert(
        --     sources,
        --     null_ls.builtins.formatting.trim_newlines.with({ disabled_filetypes = { "norg", "python" } })
        -- )
        -- table.insert(
        --     sources,
        --     null_ls.builtins.formatting.trim_whitespace.with({ disabled_filetypes = { "norg", "python" } })
        -- )

        -- Messes with maven >.<

        -- table.insert(
        --   sources,
        --   require("null-ls.helpers").make_builtin({
        --     method = require("null-ls.methods").internal.DIAGNOSTICS,
        --     filetypes = { "java" },
        --     generator_opts = {
        --       command = "java",
        --       args = { "$FILENAME" },
        --       to_stdin = false,
        --       format = "raw",
        --       from_stderr = true,
        --       on_output = require("null-ls.helpers").diagnostics.from_errorformat([[%f:%l: %trror: %m]], "java"),
        --     },
        --     factory = require("null-ls.helpers").generator_factory,
        --   })
        -- )

        local cfg = {
            sources = sources,
            debounce = 500,
            default_timeout = 3000,
            fallback_severity = vim.diagnostic.severity.WARN,
            root_dir = lspconfig.util.root_pattern(
                ".venv", -- for python
                "Pipfile",
                "_darcs",
                ".hg",
                ".bzr",
                ".svn",
                "node_modules",
                "xmake.lua",
                "pom.xml",
                "CMakeLists.txt",
                ".null-ls-root",
                "Makefile",
                "package.json",
                "tsconfig.json",
                ".git"
            ),
            diagnostics_format = "#{s}: #{m} (#{c})",
            -- on_attach = require("modules.completion.lsp.utils").get_common_opts,
            on_attach = function(client, bufnr)
                -- I dont want any formating on python files.
                if client.resolved_capabilities.document_formatting then
                    vim.diagnostic.config({
                        virtual_text = false,
                    })
                    vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting(nil, 800)")
                    -- Convert this using vim.api.nvim_create_autocmd()
                    -- vim.api.nvim_create_autocmd("BufWritePre", {
                    --     pattern = "*",
                    --     command = "lua vim.lsp.buf.formatting()",
                    -- })
                end
            end,
        }

        null_ls.setup(cfg)
    end,
}
