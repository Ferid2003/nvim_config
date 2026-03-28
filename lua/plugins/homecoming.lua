local my_art = {
      [[                                                                                                                                    ]],
      [[                                                                                                                              _.oo. ]],
      [[                                                                                                      _.u[[/;:,.         .odMMMMMM' ]],
      [[                                                                                                   .o888UU[[[/;:-.  .o@P^    MMM^   ]],
      [[  ██████   █████                   █████   █████  ███                                             oN88888UU[[[/;::-.        dP^     ]],
      [[ ░░██████ ░░███                   ░░███   ░░███  ░░░                                             dNMMNN888UU[[[/;:--.   .o@P^       ]],
      [[  ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████                            ,MMMMMMN888UU[[/;::-. o@^           ]],
      [[  ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███                           NNMMMNN888UU[[[/~.o@P^              ]],
      [[  ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███                           888888888UU[[[/o@^-..               ]],
      [[  ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███                          oI8888UU[[[/o@P^:--..                ]],
      [[  █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████                      .@^  YUU[[[/o@^;::---..                 ]],
      [[ ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░                     oMP     ^/o@P^;:::---..                   ]],
      [[                                                                                       .dMMM    .o@^ ^;::---...                     ]],
      [[                                                                                      dMMMMMMM@^`       `^^^^                       ]],
      [[                                                                                     YMMMUP^                                        ]],
      [[                                                                                      ^^                                            ]],
      [[                                                                                                                                    ]],
}
return {
    {
        "leo-alvarenga/homecoming.nvim",
        branch = "nightly", -- Optional: specify the nightly branch if you want to use the latest features
        dependencies = { "mahyarmirrashed/famous-quotes.nvim" },
        opts = {
            --section_anchor = "header_half",
            section_anchor = "self",
            section_gap = 2,
            section_hl_group = "Delimiter",
            sections = {
                {
                    title = "",
                    items = {
                        {
                            action = "Telescope find_files",
                            label = "Find files",
                            section = "> Files",
                        },
                        {
                            action = "Telescope live_grep",
                            label = "Live grep",
                            section = "> Files",
                        },
                    },
                },
                {
                    title = "",
                    items = {
                        { action = "qa", label = "Quit Neovim" },
                    },
                },
            },
            header = function()
                local lines = vim.deepcopy(my_art)
                table.insert(lines, "")
                return lines
            end,
            footer = function()
                local status, quotes = pcall(require, "famous-quotes")
                if not status then
                    return "Welcome back!" -- Fallback header
                end

                local quote_data = quotes.get_quote()
                if quote_data and quote_data[1] then
                    return quote_data[1].author .. ": " .. quote_data[1].quote
                end

                return "Stay focused." -- Fallback if get_quote() fails
            end,
        },
    },
}
