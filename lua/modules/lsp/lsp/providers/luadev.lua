local enhance_attach = require("modules.lsp.lsp.utils").enhance_attach
local lspconfig = require("lspconfig")
local sumneko_root_path = vim.fn.expand("$HOME") .. "/GitHub/lua-language-server"
local sumneko_binary = vim.fn.expand("$HOME") .. "/GitHub/lua-language-server/bin/lua-language-server"
local runtime_path = {}
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
-- Log:info(sumneko_binary, "-E", sumneko_root_path .. "/main.lua")
local sumneko_lua_server = enhance_attach({
    cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
    settings = {
        Lua = {
            diagnostics = {
                globals = {
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
            hint = {
                enable = true,
            },
            workspace = {
                -- remove all of this, as it slows things down
                library = {
                    [table.concat({ vim.fn.stdpath("data"), "lua" }, "/")] = true,
                    -- vim.api.nvim_get_runtime_file("", false),
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                },
                maxPreload = 1000,
                preloadFileSize = 10000,
            },
        },
    },
})
local lua_dev_plugins = {
    "nvim-notify",
    "plenary.nvim",
}

local runtime_path_completion = true
if not runtime_path_completion then
    sumneko_lua_server.settings.Lua.runtime = {
        version = "LuaJIT",
        path = runtime_path,
    }
end
local luadev = require("lua-dev").setup({
    library = {
        vimruntime = true,
        types = true,
        plugins = lua_dev_plugins, -- toggle this to get completion for require of all plugins
    },
    runtime_path = runtime_path_completion,
    lspconfig = sumneko_lua_server,
})

lspconfig.sumneko_lua.setup(luadev)
