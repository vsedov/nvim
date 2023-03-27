local enhance_attach = require("modules.lsp.lsp.config").enhance_attach
local lspconfig = require("lspconfig")
local sumneko_root_path = "/home/viv/.local/share/nvim/mason/packages/lua-language-server/"
local sumneko_binary = "/home/viv/.local/share/nvim/mason/packages/lua-language-server/lua-language-server"

local runtime_path = {}

table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require("neodev").setup({
    enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
    runtime = true, -- runtime path
    types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
    plugins = false, -- installed opt or start plugins in packpath
})

local sumneko_lua_server = enhance_attach({
    cmd = { sumneko_binary },
    settings = {
        Lua = {
            diagnostics = {
                globals = {
                    "lambda",
                    "vim",
                    "dump",
                    "hs",
                    "lvim",
                    "describe",
                    "it",
                    "before_each",
                    "after_each",
                    "pending",
                    "teardown",
                    "packer_plugins",
                },
            },
            completion = { keywordSnippet = "Replace", callSnippet = "Replace" },
            format = { enable = false },
            hint = { enable = true, arrayIndex = "Disable", setType = true },
            workspace = {
                checkThirdParty = false,
            },
        },
    },
})

lspconfig.lua_ls.setup(sumneko_lua_server)
