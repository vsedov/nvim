local Hydra = require("hydra")
local when = lambda.lib.when

local default_choice = {
    repo = "vsedov",
    pr = "all",
    issue = "all",
    label = "Bug",
    gist = "all",
}

local choice_edge_case = {
    all = "",
}

local function caller(options, ch)
    vim.ui.select(options, {
        prompt = "Select a choice",
        format_item = function(item)
            return "Octo " .. ch .. " " .. item
        end,
    }, function(choice)
        when(
            vim.tbl_contains({
                "issue",
                "gist",
                "pr",
                "repo",
                "search",
                "label",
            }, ch),
            function()
                when(
                    vim.tbl_contains({
                        "search",
                        "list",
                        "edit",
                        "create",
                        "resolve",
                        "unresolve",
                        "add",
                        "remove",
                        "create",
                    }, choice),
                    function()
                        vim.ui.input({
                            prompt = "Enter a option for " .. ch .. " > ",
                            default = default_choice[ch],
                        }, function(choice_2)
                            if vim.tbl_contains(options, choice_2) then
                                choice_2 = choice_edge_case[choice_2]
                            end
                            vim.cmd("Octo " .. ch .. " " .. choice .. " " .. choice_2)
                        end)
                    end,
                    function()
                        vim.cmd("Octo " .. ch .. " " .. choice)
                    end
                )
            end,
            function()
                vim.notify("No Optional Params listed")
                if choice ~= nil and ch ~= nil then
                    command = "Octo " .. ch .. " " .. choice
                    vim.cmd(command)
                end
            end
        )
    end)
end

local octo_hint = [[
^    Octo
^▔▔▔▔▔▔▔▔▔▔▔^
^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^
^ _g_: Gists
^ _i_: Issues
^ _p_: PR
^ _r_: Repos
^ _s_: Search
^ _C_: Card
^ _c_: Comment
^ _l_: label
^ _t_: thread
^ _R_: Review
^ _-_: React
^ _q_: Quit

^▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔^
^ _1_: GL [Cur]
^ _2_: GL [Yank]
^ _3_: Git [Url]+
^ _4_: Git [CurL]
]]
Hydra({
    name = "Octo",
    mode = { "n", "v" },
    body = "<leader>o",
    hint = octo_hint,
    config = {
        hint = {
            position = "middle-right",
            border = lambda.style.border.type_0,
        },
        timeout = false,
        invoke_on_body = true,
    },
    heads = {
        {
            "g",
            function()
                caller({ "list" }, "gist")
            end,
            { exit = true },
        },
        {
            "i",
            function()
                options = {
                    "close",
                    "create",
                    "edit",
                    "list",
                    "search",
                    "reload",
                    "browser",
                    "url",
                }
                caller(options, "issue")
            end,

            { exit = true },
        },
        {
            "p",
            function()
                options = {
                    "create",
                    "list",
                    "search",
                    "edit",
                    "reopen",
                    "checkout",
                    "commits",
                    "changes",
                    "diff",
                    "ready",
                    "merge",
                    "checks",
                    "reload",
                    "url",
                }
                caller(options, "pr")
            end,

            { exit = true },
        },
        {
            "r",
            function()
                options = {
                    "list",
                    "fork",
                    "browser",
                    "url",
                    "view",
                }
                caller(options, "repo")
            end,

            { exit = true },
        },
        {
            "s",
            function()
                vim.ui.input({
                    prompt = "Enter a option for search > ",
                    default = "assignee:vsedov is:pr",
                }, function(choice_2)
                    vim.cmd("Octo search " .. choice_2)
                end)
            end,
            { exit = true },
        },

        {
            "C",
            function()
                options = {
                    "add",
                    "remove",
                    "move",
                }
                caller(options, "card")
            end,
            { exit = true },
        },

        {
            "l",
            function()
                options = {
                    "add",
                    "remove",
                    "create",
                }
                caller(options, "label")
            end,

            { exit = true },
        },

        {
            "t",
            function()
                caller({ "resolve", "unresolve" }, "thread")
            end,

            { exit = true },
        },
        {
            "R",
            function()
                options = {
                    "start",
                    "submit",
                    "resume",
                    "discard",
                    "comments",
                    "commit",
                    "close",
                }
                caller(options, "review")
            end,
            { exit = true },
        },
        {
            "c",
            function()
                options = {
                    "add",
                    "delete",
                }
                caller(options, "comment")
            end,
            { exit = true },
        },
        {
            "-",
            function()
                options = {
                    "thumbs_up",
                    "thumbs_down",
                    "eyes",
                    "laugh",
                    "confused",
                    "rocket",
                    "heart",
                    "hooray",
                    "party",
                    "tada",
                }
                vim.notify("Active")
                caller(options, "reaction")
            end,
            { exit = true },
        },
        {
            "1",
            function()
                require("gitlinker").get_buf_range_url(
                    "n",
                    { action_callback = require("gitlinker.actions").open_in_browser }
                )
            end,
            { exit = true, desc = "Current file" },
        },
        {
            "2",
            function()
                require("gitlinker").get_repo_url()
            end,
            { exit = true, desc = "Copy url" },
        },
        {
            "3",
            function()
                require("gitlinker").get_repo_url({ action_callback = require("gitlinker.actions").open_in_browser })
            end,
            { exit = true, desc = "Open Repo " },
        },
        {
            "4",
            function()
                local mode = string.lower(vim.fn.mode())
                require("gitlinker").get_buf_range_url(mode)
            end,
            { exit = true, desc = "current_line range" },
        },
        { "q", nil, { exit = true } },
        ["<ESC>"] = { nil, { desc = "Exit", exit = true } },
    },
})
