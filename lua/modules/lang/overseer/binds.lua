vim.keymap.set("n", "<leader>oo", "<cmd>OverseerToggle<CR>", {desc = "OverseerToggle"})
vim.keymap.set("n", "<leader>or", "<cmd>OverseerRun<CR>",{desc = "OverseerRun"})
vim.keymap.set("n", "<leader>ol", "<cmd>OverseerLoadBundle<CR>",{desc = "OverseerLoadBundle"})
vim.keymap.set("n", "<leader>ob", "<cmd>OverseerBuild<CR>",{desc = "OverseerBuild"})
vim.keymap.set("n", "<leader>od", "<cmd>OverseerQuickAction<CR>",{desc = "OverseerQuickAction"})
vim.keymap.set("n", "<leader>os", "<cmd>OverseerTaskAction<CR>",{desc = "OverseerTaskAction"})
vim.keymap.set("n", "<Leader>oR", function()
    local overseer = require("overseer")
    overseer.run_template({name = "Runner"}, function(task)
        if task then
            overseer.run_action(task, 'open float')
            -- overseer.run_action(task, 'open hsplit')
        end
    end)
end)