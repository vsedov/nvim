return {
    cmd = { "jedi-language-server" },
    filetypes = { "python" },
    init_options = {
        jediSettings = {

            autoImportModules = { "pydantic", "pytest", "discord.py", "numpy" },
        },
    },
}
