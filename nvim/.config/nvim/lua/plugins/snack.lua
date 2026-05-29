return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- 1. BIG FILE: Auto-detect and disable heavy features for large files
    bigfile = { enabled = true },

    -- 2. image: render images in terminal (requires kitty, wezterm, iterm2, ghostty, etc.)
    image = {
      enabled = true,
      force = true,
      formats = {
        "png",
        "jpg",
        "jpeg",
        "gif",
        "bmp",
        "webp",
        "tiff",
        "heic",
        "avif",
        "mp4",
        "mov",
        "avi",
        "mkv",
        "webm",
        "pdf",
        "icns",
      },
      doc = {
        inline = true, -- render images in markdown files inline
        float = false, -- render in float if inline is disabled or not supported
        max_width = 80,
        max_height = 40,
        -- conceal math syntax when rendering the image
        conceal = function(lang, type)
          return type == "math"
        end,
      },
      img_dirs = { "img", "images", "assets", "static", "public", "media", "attachments" },
      -- enable math expression rendering (requires system tools like latex or typst)
      math = {
        enabled = true,
        typst = {
          tpl = [[
        #set page(width: auto, height: auto, margin: (x: 2pt, y: 2pt))
        #show math.equation.where(block: false): set text(top-edge: "bounds", bottom-edge: "bounds")
        #set text(size: 12pt, fill: rgb("${color}"))
        ${header}
        ${content}]],
        },
      },
      -- conversion config for things like mermaid diagrams
      convert = {
        notify = false,
        mermaid = function()
          local theme = vim.o.background == "light" and "neutral" or "dark"
          return { "-i", "{src}", "-o", "{file}", "-b", "transparent", "-t", theme, "-s", "{scale}" }
        end,
      },
    },

    -- 3. NOTIFIER: Replaces nvim-notify with a cleaner UI
    notifier = {
      enabled = true,
      style = "compact", -- "compact", "fancy", or "minimal"
    },

    -- 4. PICKER: The Powerhouse (Telescope/Fzf replacement)
    picker = {
      enabled = true,
      actions = {
        -- 1. Define the custom action
        open_with_zathura = function(picker, item)
          -- Ensure we have a valid item
          if not item then
            local items = picker:selected()
            if #items > 0 then
              item = items[1]
            else
              item = picker:current()
            end
          end

          -- Check if it is a PDF
          if item and item.file and item.file:match("%.pdf$") then
            -- Open Zathura detached (so it doesn't freeze Neovim)
            vim.fn.jobstart({ "zathura", item.file }, { detach = true })
            -- Optional: close the explorer after opening
            -- picker:close()
          else
            -- Fallback: Use default 'jump' behavior (edit file / enter dir)
            Snacks.picker.actions.jump(picker)
          end
        end,
      },
      ui_select = true, -- Replace vim.ui.select (code actions, etc)
      layout = {
        preset = "ivy", -- "ivy", "vertical", "select", "vscode"
        cycle = true,
      },
      matcher = { frecency = true }, -- Sort by frequency + recency
      win = {
        input = {
          keys = {
            -- === SEARCH BOX <-> RESULTS NAVIGATION ===
            -- Tab / Shift+Tab to navigate results without leaving input
            ["<Tab>"] = { "list_down", mode = { "i", "n" } },
            ["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
            -- Standard Ctrl+j/k navigation
            ["<C-j>"] = { "list_down", mode = { "i", "n" } },
            ["<C-k>"] = { "list_up", mode = { "i", "n" } },

            -- === SEARCH BOX <-> PREVIEW NAVIGATION ===
            -- Alt+j / Alt+k to scroll the PREVIEW window while typing
            ["<a-j>"] = { "preview_scroll_down", mode = { "i", "n" } },
            ["<a-k>"] = { "preview_scroll_up", mode = { "i", "n" } },
            -- NEW: Alt+p to FOCUS the preview window (allows copying text)
            ["<a-p>"] = { "focus_preview", mode = { "i", "n" } },
            -- NEW: Alt+i to FOCUS the search input (jump back)
            ["<a-i>"] = { "focus_input", mode = { "i", "n" } },

            -- === MODES ===
            -- Esc enters Normal mode (navigate with j/k).
            -- Press Esc AGAIN in Normal mode to close.
            ["<Esc>"] = { "close", mode = { "n" } },
            ["<a-c>"] = { "toggle_cwd", mode = { "n", "i" } }, -- Alt+c to toggle cwd
          },
        },
        -- NEW: Keymaps for the List window
        list = {
          keys = {
            ["<a-i>"] = { "focus_input", mode = { "n", "i" } },
          },
        },
        -- NEW: Keymaps for the Preview window
        preview = {
          keys = {
            ["<a-i>"] = { "focus_input", mode = { "n", "i" } },
            ["<Esc>"] = { "focus_input", mode = { "n" } }, -- Esc goes back to search
          },
        },
      },
      sources = {
        explorer = {
          hidden = true, -- Show hidden files in explorer by default
          ignored = true,
          win = {
            list = {
              keys = {
                -- 2. Bind <CR> to your custom action in the Explorer window
                ["<a-q>"] = "open_with_zathura",
              },
            },
          },
        },
        grep = {
          -- "rg" arguments. We ensure -I is present to ignore binary files.
          -- Note: You may need to copy your existing arguments if you have custom ones.
          -- These are standard defaults + "-I"
          cmd = "rg",
          args = {
            --"--color=always",
            --"--no-heading",
            --"--with-filename",
            --"--line-number",
            --"--column",
            "--smart-case",
            --"!.git/", -- Ignore .git folder
            --"-I", -- <--- ADD THIS: Treat binary files as non-matches
          },
        },
      },
    },

    -- 5. EXPLORER: Tree view
    explorer = {
      enabled = true,
      replace_netrw = true,
    },

    -- 6. DASHBOARD: Advanced Startup Screen
    dashboard = {
      enabled = true,
      preset = {
        header = [[
  ▄▄▄▄███▄▄▄▄    ▄██████▄  ███▄▄▄▄      ▄████████    ▄████████  ▄████████    ▄█    █▄    
▄██▀▀▀███▀▀▀██▄ ███    ███ ███▀▀▀██▄   ███    ███    ███    ███ ███    ███    ███    ███   
███    ███    ███ ███    ███ ███   ███   ███    ███    ███    ███ ███    █▀     ███    ███   
███    ███    ███ ███    ███ ███   ███   ███    ███  ▄███▄▄▄▄██▀ ███           ▄███▄▄▄▄███▄▄ 
███    ███    ███ ███    ███ ███   ███ ▀███████████ ▀▀███▀▀▀▀▀   ███          ▀▀███▀▀▀▀███▀  
███    ███    ███ ███    ███ ███   ███   ███    ███ ▀███████████ ███    █▄     ███    ███   
███    ███    ███ ███    ███ ███   ███   ███    ███    ███    ███ ███    ███    ███    ███   
 ▀█    ███    █▀   ▀██████▀   ▀█    █▀    ███    █▀     ███    ███ ████████▀     ███    █▀    
                                                        ███    ███                           
        ]],
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        {
          pane = 2,
          icon = " ",
          title = "Git Status",
          section = "terminal",
          -- Only show git status if we are actually in a git repo
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = "git status --short --branch --renames",
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = "startup" },
      },
    },

    -- 7. INDENT: Animated guides
    indent = {
      enabled = true,
      animate = { enabled = true, style = "out" },
      scope = {
        enabled = true, -- Highlight current scope
        char = "│",
        underline = false, -- Don't underline the scope start
      },
    },

    -- 8. INPUT: Better input dialogs (renaming files, etc)
    input = {
      enabled = true,
      icon = " ",
    },

    -- 9. LAZYGIT: Seamless integration
    lazygit = {
      enabled = true,
      -- Automatically configure lazygit to match nvim theme
      configure = true,
      config = {
        os = { editPreset = "nvim-remote" },
        gui = {
          -- Set to an empty string to have no borders
          nerdFontsVersion = "3",
        },
      },
      theme = {
        [241] = { fg = "Special" },
        activeBorderColor = { fg = "MatchParen", bold = true },
        cherryPickedCommitBgColor = { fg = "Identifier" },
        cherryPickedCommitFgColor = { fg = "Function" },
        defaultFgColor = { fg = "Normal" },
        inactiveBorderColor = { fg = "FloatBorder" },
        optionsTextColor = { fg = "Function" },
        searchingActiveBorderColor = { fg = "MatchParen", bold = true },
        selectedLineBgColor = { bg = "Visual" }, -- Set to `default` to have no background color
        unstagedChangesColor = { fg = "DiagnosticError" },
      },
    },

    -- 10. TERMINAL: Floating terminals
    terminal = {
      enabled = true,
      win = { style = "terminal" },
    },

    -- 11. SCROLL: Smooth scrolling (DISABLED due to navigation issues)
    scroll = {
      enabled = false,
    },

    -- 12. STATUSCOLUMN: Gutter info
    statuscolumn = {
      enabled = false,
      left = { "mark", "sign" },
      right = { "git" },
      folds = {
        open = true, -- Show open fold icons (cleaner)
        git_hl = true,
      },
    },

    -- 13. WORDS: Auto-highlight word under cursor
    words = { enabled = true },

    -- 14. ZEN MODE: Focus
    zen = {
      enabled = true,
      toggles = {
        dim = true,
        git_signs = false,
        mini_diff_signs = false,
      },
    },

    -- 15. DEBUG: Helpers
    debug = { enabled = true },
  },

  keys = {
    -- === Picker / Search ===
    {
      "<leader>,",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    -- UPDATED: This now performs a GREP search in the Explorer's root
    {
      "<leader>/",
      function()
        local explorer = Snacks.picker.get({ source = "explorer" })[1]
        Snacks.picker.grep({ cwd = explorer and explorer:cwd() or vim.fn.getcwd() })
      end,
      desc = "Grep (Explorer Root)",
    },
    {
      "<leader>:",
      function()
        Snacks.picker.command_history()
      end,
      desc = "Command History",
    },
    {
      "<leader><space>",
      function()
        Snacks.picker.smart()
      end,
      desc = "Smart Find Files",
    },

    -- NEW: Grep in current buffer lines
    {
      "<leader>s/",
      function()
        Snacks.picker.lines()
      end,
      desc = "Search Buffer",
    },

    -- NEW: Search History moved here
    {
      "<leader>sa",
      function()
        Snacks.picker.search_history()
      end,
      desc = "Search History",
    },

    -- NEW: Custom Grep Directory Input (Moved from init)
    {
      "<leader>sA",
      function()
        local dir = vim.fn.input("Grep in dir: ", "", "dir")
        if dir ~= "" then
          Snacks.picker.grep({ cwd = dir })
        end
      end,
      desc = "Grep (Custom Dir)",
    },

    -- Custom Grep Mappings (Root and Home)
    {
      "<leader>sg",
      function()
        local explorer = Snacks.picker.get({ source = "explorer" })[1]
        Snacks.picker.grep({ cwd = explorer and explorer:cwd() or vim.fn.getcwd() })
      end,
      desc = "Grep (Explorer Root)",
    },
    {
      "<leader>sG",
      function()
        Snacks.picker.grep({ cwd = vim.fn.expand("~") })
      end,
      desc = "Grep (Home)",
    },

    -- Specific Directory Searches
    {
      "<leader>fc",
      function()
        Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "Find Config File",
    },

    -- UPDATED: Space ff now gets the CWD from the active Snacks Explorer (if open)
    {
      "<leader>ff",
      function()
        -- Look for an active explorer picker
        local explorer = Snacks.picker.get({ source = "explorer" })[1]
        -- Use the explorer's cwd if found, otherwise default to global cwd
        Snacks.picker.files({ cwd = explorer and explorer:cwd() or vim.fn.getcwd() })
      end,
      desc = "Find Files (Explorer Root)",
    },

    -- NEW: Space fF searches the Home Directory (System)
    {
      "<leader>fF",
      function()
        Snacks.picker.files({ cwd = vim.fn.expand("~") })
      end,
      desc = "Find Files (Home)",
    },
    {
      "<leader>fp",
      function()
        Snacks.picker.projects()
      end,
      desc = "Projects",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent()
      end,
      desc = "Recent",
    },

    -- Kyrus-Pan-Amor Specific Searches
    {
      "<leader>oS",
      function()
        Snacks.picker.grep({ cwd = "/home/red_monarch/Documents/Synchornize/Kyrus-Pan-Amor" })
      end,
      desc = "Grep (Kyrus-Pan-Amor)",
    },
    {
      "<leader>oF",
      function()
        Snacks.picker.files({ cwd = "/home/red_monarch/Documents/Synchornize/Kyrus-Pan-Amor" })
      end,
      desc = "Find Files (Kyrus-Pan-Amor)",
    },

    -- === Explorer ===
    {
      "<leader>se",
      function()
        Snacks.explorer({ cwd = vim.fn.expand("%:p:h") })
      end,
      desc = "File Explorer",
    },
    { "<leader>e", false },
    { "<leader>E", false },

    -- === Git ===
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>gb",
      function()
        Snacks.git.blame_line()
      end,
      desc = "Git Blame Line",
    },
    {
      "<leader>gB",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Open in Browser",
    },
    {
      "<leader>gl",
      function()
        Snacks.picker.git_log()
      end,
      desc = "Git Log",
    },
    {
      "<leader>gs",
      function()
        Snacks.picker.git_status()
      end,
      desc = "Git Status",
    },

    -- === LSP / Coding ===
    {
      "gd",
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = "Goto Definition",
    },
    {
      "gr",
      function()
        Snacks.picker.lsp_references()
      end,
      desc = "References",
    },
    {
      "gI",
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = "Goto Implementation",
    },
    {
      "gy",
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = "Goto Type Definition",
    },
    {
      "<leader>ss",
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = "LSP Symbols",
    },

    -- === Utilities ===
    {
      "<leader>z",
      function()
        Snacks.zen()
      end,
      desc = "Zen Mode",
    },
    {
      "<leader>.",
      function()
        Snacks.terminal()
      end,
      desc = "Toggle Terminal",
    },
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete Buffer",
    },
    {
      "<leader>cR",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename File",
    },

    -- === Notifications ===
    {
      "<leader>n",
      function()
        Snacks.picker.notifications()
      end,
      desc = "Notification History",
    },
    {
      "<leader>un",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Dismiss All Notifications",
    },
  },

  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (optional)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd
      end,
    })
  end,
}
