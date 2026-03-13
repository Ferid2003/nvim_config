return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        -- ts-autotag utilizes treesitter to understand the code structure to automatically close tsx tags
        "windwp/nvim-ts-autotag"
    },
    -- when the plugin builds run the TSUpdate command to ensure all our servers are installed and updated
    branch = "master",
    build = ':TSUpdate',
    config = function()
        -- gain access to the treesitter config functions
        local ts_config = require("nvim-treesitter.configs")

        -- call the treesitter setup function with properties to configure our experience
        ts_config.setup({
            -- make sure we have vim, vimdoc, lua, java, javascript, typescript, html, css, json, tsx, markdown, markdown, inline markdown and gitignore highlighting servers
            ensure_installed = {"vim", "vimdoc", "lua", "java", "javascript", "typescript", "html", "css", "json", "tsx", "markdown", "markdown_inline", "gitignore", "xml"},
            -- make sure highlighting it anabled
            highlight = {enable = true},
            -- enable tsx auto closing tag creation
            -- autotag = {
            --     enable = true
            -- }
        })
        -- 2. New Autotag Setup (Standalone)
        require('nvim-ts-autotag').setup({
            opts = {
                enable_close = true,           -- Auto close tags
                enable_rename = true,          -- Auto rename paired tags
                enable_close_on_slash = true,  -- Auto close on trailing </
            },
        })
    end
}
