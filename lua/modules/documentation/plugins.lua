local conf = require("modules.documentation.config")
local docs = require("core.pack").package

docs({ "danymat/neogen", module = { "neogen" }, requires = { "LuaSnip" }, config = conf.neogen })

docs({
    "ranelpadon/python-copy-reference.vim",
    opt = true,
    ft = "python",
    cmd = {
        "PythonCopyReferenceDotted",
        "PythonCopyReferencePytest",
    },
})

docs({
    "prichrd/refgo.nvim",
    cmd = { "RefCopy", "RefGo" },
})

docs({
    "max397574/dyn_help.nvim",
    opt = true,
    keys = "<leader>hw",
    config = conf.dyn_help,
})
docs({
    "amrbashir/nvim-docs-view",
    opt = true,
    cmd = { "DocsViewToggle" },
    config = conf.nvim_doc_help,
})
docs({
    "KabbAmine/zeavim.vim",
    cmd = {
        "Zeavim",
        "ZeavimV",
        "Zeavim!",
        "Docset",
    },
})
docs({
    "romainl/vim-devdocs",
    cmd = { "DD" },
    opt = true,
})