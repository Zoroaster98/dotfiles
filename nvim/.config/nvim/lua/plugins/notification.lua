return {
  -- 1. Nvim-Notify: Visuals & Notification Keys
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      render = "default",
      stages = "fade_in_slide_out",
      background_colour = "#000000",
      timeout = 50,
      max_height = function()
        return math.floor(vim.o.lines * 0.25)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.25)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify
    end,
    keys = {
      {
        "<leader>n",
        function()
          local telescope = require("telescope")
          pcall(telescope.load_extension, "notify")
          telescope.extensions.notify.notify()
        end,
        desc = "Notification History",
      },
      -- HISTORY / PICKER (Telescope)
      {
        "<leader>snh",
        function()
          local telescope = require("telescope")
          pcall(telescope.load_extension, "notify")
          telescope.extensions.notify.notify()
        end,
        desc = "[S]earch [N]otification [H]istory",
      },
      {
        "<leader>snp", -- [P]icker (Alias for History)
        function()
          local telescope = require("telescope")
          pcall(telescope.load_extension, "notify")
          telescope.extensions.notify.notify()
        end,
        desc = "[S]earch [N]otification [P]icker",
      },
      -- DISMISS
      {
        "<leader>snd",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "[S]earch [N]otification [D]ismiss",
      },
    },
  },

  -- 2. Fidget: LSP Progress
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      notification = {
        window = { winblend = 0 },
      },
    },
  },

  -- 3. Noice: Cmdline, Message History, Last Message
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      notify = { enabled = false }, -- Let nvim-notify handle notifications
      lsp = {
        progress = { enabled = false }, -- Let fidget handle progress
        hover = { enabled = true },
        signature = { enabled = true },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
      messages = {
        enabled = true,
        view = "notify", -- Send standard messages to nvim-notify
        view_error = "notify",
        view_warn = "notify",
        view_history = "messages",
      },
    },
    keys = {
      -- LAST MESSAGE
      {
        "<leader>snl",
        function()
          require("noice").cmd("last")
        end,
        desc = "[S]earch [N]otification [L]ast Message",
      },
      -- ALL MESSAGES (Split View)
      {
        "<leader>sna",
        function()
          require("noice").cmd("all")
        end,
        desc = "[S]earch [N]otification [A]ll History",
      },
    },
  },
}
