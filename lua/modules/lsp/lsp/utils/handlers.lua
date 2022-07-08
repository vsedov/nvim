-- Set Default Prefix.
-- Note: You can set a prefix per lsp server in the lv-globals.lua file
local M = {}
local api = vim.api
local fn = vim.fn

local config = require("modules.lsp.lsp.utils.config")
-- TODO: Change this to fit config - call config from config.lua
function M.setup()
    vim.diagnostic.config(config.diagnostics)
    vim.diagnostic.open_float = config.open_float
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, config.float)
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, config.float)
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        config.virtual_text,
    })
    vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        local lvl = ({ "ERROR", "WARN", "INFO", "DEBUG" })[result.type]
        vim.notify(result.message, lvl, {
            title = "LSP | " .. client.name,
            timeout = 10000,
            keep = function()
                return lvl == "ERROR" or lvl == "WARN"
            end,
        })
    end
    local ns = api.nvim_create_namespace("severe-diagnostics")

    --- Restricts nvim's diagnostic signs to only the single most severe one per line
    --- @see `:help vim.diagnostic`
    local function max_diagnostic(callback)
        return function(_, bufnr, _, opts)
            -- Get all diagnostics from the whole buffer rather than just the
            -- diagnostics passed to the handler
            local diagnostics = vim.diagnostic.get(bufnr)
            -- Find the "worst" diagnostic per line
            local max_severity_per_line = {}
            for _, d in pairs(diagnostics) do
                local m = max_severity_per_line[d.lnum]
                if not m or d.severity < m.severity then
                    max_severity_per_line[d.lnum] = d
                end
            end
            -- Pass the filtered diagnostics (with our custom namespace) to
            -- the original handler
            callback(ns, bufnr, vim.tbl_values(max_severity_per_line), opts)
        end
    end

    local signs_handler = vim.diagnostic.handlers.signs
    vim.diagnostic.handlers.signs = vim.tbl_extend("force", signs_handler, {
        show = max_diagnostic(signs_handler.show),
        hide = function(_, bufnr)
            signs_handler.hide(ns, bufnr)
        end,
    })

    local virt_text_handler = vim.diagnostic.handlers.virtual_text
    vim.diagnostic.handlers.virtual_text = vim.tbl_extend("force", virt_text_handler, {
        show = max_diagnostic(virt_text_handler.show),
        hide = function(_, bufnr)
            virt_text_handler.hide(ns, bufnr)
        end,
    })
end

function M.show_line_diagnostics()
    return vim.diagnostic.open_float(config.diagnostics.float)
end

return M
