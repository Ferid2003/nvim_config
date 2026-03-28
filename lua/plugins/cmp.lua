return {
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            -- feed luasnip suggestions to cmp
            "saadparwaiz1/cmp_luasnip",
            -- provide vscode like snippets to cmp
            "rafamadriz/friendly-snippets",
        },
    },
    -- cmp-nvim-lsp provides language specific completion suggestions to nvim-cmp
    {
        "hrsh7th/cmp-nvim-lsp",
    },
    -- nvim-cmp provides auto completion and auto completion dropdown ui
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            -- buffer based completion options
            "hrsh7th/cmp-buffer",
            -- path based completion options
            "hrsh7th/cmp-path",
        },
        config = function()
            -- Gain access to the functions of the cmp plugin
            local cmp = require("cmp")
            -- Gain access to the function of the luasnip plugin
            local luasnip = require("luasnip")

            -- Custom Spring boot properties completion soruce
            local spring_source = {}

            spring_source.new = function ()
                return setmetatable({}, {__index = spring_source })
            end

            spring_source.is_available = function()
                return vim.bo.filetype == "jproperties"
            end

            spring_source.get_trigger_characters = function()
                return { "." }
            end

            spring_source.complete = function(self, request, callback)
                local items = {
                    { label = "spring.datasource.url", documentation = "JDBC URL of the database" },
                    { label = "spring.datasource.username", documentation = "Login username of the database" },
                    { label = "spring.datasource.password", documentation = "Login password of the database" },
                    { label = "spring.datasource.driver-class-name", documentation = "Fully qualified name of the JDBC driver" },
                    { label = "spring.jpa.hibernate.ddl-auto", documentation = "DDL mode: none, validate, update, create, create-drop" },
                    { label = "spring.jpa.show-sql", documentation = "Whether to enable logging of SQL statements" },
                    { label = "spring.jpa.properties.hibernate.dialect", documentation = "Hibernate dialect" },
                    { label = "spring.jpa.properties.hibernate.format_sql", documentation = "Whether to format SQL output" },
                    { label = "server.port", documentation = "Server HTTP port" },
                    { label = "server.servlet.context-path", documentation = "Context path of the application" },
                    { label = "spring.application.name", documentation = "Application name" },
                    { label = "spring.profiles.active", documentation = "Active profiles" },
                    { label = "spring.security.user.name", documentation = "Default user name" },
                    { label = "spring.security.user.password", documentation = "Default user password" },
                    { label = "logging.level.root", documentation = "Root log level: TRACE, DEBUG, INFO, WARN, ERROR" },
                    { label = "logging.level.org.springframework", documentation = "Spring framework log level" },
                    { label = "logging.file.name", documentation = "Log file name" },
                    { label = "spring.cache.type", documentation = "Cache type to use" },
                    { label = "spring.data.redis.host", documentation = "Redis server host" },
                    { label = "spring.data.redis.port", documentation = "Redis server port" },
                    { label = "spring.mail.host", documentation = "SMTP server host" },
                    { label = "spring.mail.port", documentation = "SMTP server port" },
                    { label = "spring.mail.username", documentation = "Login user of the SMTP server" },
                    { label = "spring.mail.password", documentation = "Login password of the SMTP server" },
                }
                callback({ items = items, isIncomplete = false })
            end

            require("cmp").register_source("spring_properties", spring_source)

            -- Lazily load the vscode like snippets
            require("luasnip.loaders.from_vscode").lazy_load()

            -- All the cmp setup function to configure our completion experience
            cmp.setup({
                -- 1. GHOST TEXT: Shows a preview of the suggestion in gray text
                experimental = {
                    ghost_text = true,
                },
                -- 2. AUTO-SELECT: Ensure the first item is automatically highlighted
                preselect = cmp.PreselectMode.Item,
                -- How should completion options be displayed to us?
                completion = {
                    -- menu: display options in a menu
                    -- menuone: automatically select the first option of the menu
                    -- preview: automatically display the completion candiate as you navigate the menu
                    -- noselect: prevent neovim from automatically selecting a completion option while navigating the menu
                    completeopt = "menu,menuone,preview",
                },
                -- setup snippet support based on the active lsp and the current text of the file
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                -- setup how we interact with completion menus and options
                mapping = cmp.mapping.preset.insert({
                    -- previous suggestion
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    -- next suggestion
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    -- show completion suggestions
                    ["<C-Space>"] = cmp.mapping.complete(),
                    -- close completion window
                    ["<C-e>"] = cmp.mapping.abort(),
                    -- confirm completion, only when you explicitly selected an option
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),

                    -- 3. TAB SELECTION: Selects first option or jumps through snippets
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.confirm({ select = true }) -- Select the first/active item
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                -- Where and how should cmp rank and find completions
                -- Order matters, cmp will provide lsp suggestions above all else
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "spring_properties" },
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
        end,
    },
}
