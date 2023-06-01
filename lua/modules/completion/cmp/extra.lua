local cmp = require("cmp")
local tabnine_options = lambda.config.ai.tabnine.cmp

-- require'cmp'.setup.cmdline(':', {sources = {{name = 'cmdline'}}})
if vim.o.ft == "clap_input" or vim.o.ft == "guihua" or vim.o.ft == "guihua_rust" then
    cmp.setup.buffer({ completion = { enable = false } })
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "TelescopePrompt", "clap_input" },
    callback = function()
        cmp.setup.buffer({ enabled = false })
    end,
    once = false,
})

if tabnine_options.use_tabnine and tabnine_options.tabnine_prefetch and lambda.ai.tabnine.use_tabnine_cmp then
    local prefetch = vim.api.nvim_create_augroup("prefetch", { clear = true })
    vim.api.nvim_create_autocmd("BufRead", {
        group = prefetch,
        pattern = lambda.config.main_file_types,
        callback = function()
            require("cmp_tabnine"):prefetch(vim.fn.expand("%:p"))
        end,
    })
end
