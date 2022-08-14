-- default sources
local sources =
    {
        { name = "nvim_lsp_signature_help", priority = 10 },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
    }, {
        {
            name = "buffer",
            options = {
                get_bufnrs = function()
                    local bufs = {}
                    for _, win in ipairs(api.nvim_list_wins()) do
                        bufs[api.nvim_win_get_buf(win)] = true
                    end
                    return vim.tbl_keys(bufs)
                end,
            },
        },
        { name = "spell" },
        { name = "nvim_lua" },
    }
local filetype = {
    sql = function()
        table.insert(sources, { name = "vim-dadbod-completion" })
    end,
    norg = function()
        table.insert(sources, { name = "latex_symbols" })
    end,
    markdown = function()
        table.insert(sources, { name = "look" })
        table.insert(sources, { name = "latex_symbols" })
    end,
}

if filetype[vim.bo.ft] then
    filetype[vim.bo.ft]()
end

for _, source in pairs(require("modules.completion.cmp.options")) do
    if source.enable then
        table.insert(sources, source.options)
    end
end

return sources
