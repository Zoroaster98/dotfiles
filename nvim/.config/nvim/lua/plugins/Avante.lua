return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim", -- Ensure mcphub is available
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = { adapter = "ollama" },
          inline = { adapter = "ollama" },
        },
        adapters = {
          ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
              schema = {
                model = {
                  default = "qwen3:14b",
                },
              },
            })
          end,
        },
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              show_result_in_chat = true,
              -- FIX: Disable variable creation defensively until MCP servers are added
              make_vars = false,
              make_slash_commands = true,
            },
          },
        },
      })
    end,
  },

  {
    "ravitemer/mcphub.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    build = "npm install -g mcp-hub@latest",
    lazy = false, -- Ensure this loads early to avoid the 'nil' pairs error
    config = function()
      require("mcphub").setup({
        -- FIX: Explicitly pass an empty servers table to prevent the 'pairs(nil)' crash
        servers = {},

        -- You can add your actual MCP servers here later, for example:
        -- servers = {
        --   sqlite = {
        --     command = "uvx",
        --     args = { "mcp-server-sqlite", "--db-path", "~/test.db" },
        --   }
        -- }
      })
    end,
  },

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
      provider = "ollama",
      auto_suggestions_provider = "ollama",
      providers = {
        ollama = {
          endpoint = "http://127.0.0.1:11434",
          model = "qwen3:14b",
          is_env_set = function()
            return true
          end,
          timeout = 30000,
          extra_request_body = {
            options = {
              num_ctx = 8192,
              temperature = 0,
            },
          },
        },
      },
      file_selector = {
        provider = "snacks",
        provider_opts = {},
      },
      behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = true,
      },
    },
    build = "make",
    dependencies = {
      "ravitemer/mcphub.nvim", -- Critical dependency
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-mini/mini.pick",
      "nvim-telescope/telescope.nvim",
      "hrsh7th/nvim-cmp",
      "ibhagwan/fzf-lua",
      "nvim-tree/nvim-web-devicons",
      "Kaiser-Yang/blink-cmp-avante",
      {
        "saghen/blink.cmp",
        lazy = true,
        opts = {
          sources = {
            default = { "avante" },
            providers = {
              avante = {
                module = "blink-cmp-avante",
                name = "Avante",
                opts = { comp_source = "avante_mentions" },
              },
            },
          },
        },
      },
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = { insert_mode = true },
            use_absolute_path = true,
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
    },
    config = function(_, opts)
      -- Use a safe wrapper for the system prompt to prevent initialization errors
      opts.system_prompt = function()
        local status, hub = pcall(require, "mcphub")
        if status then
          local instance = hub.get_hub_instance()
          return instance and instance:get_active_servers_prompt() or ""
        end
        return ""
      end

      -- Ensure MCP tool is registered safely
      opts.custom_tools = function()
        local status, mcp_avante = pcall(require, "mcphub.extensions.avante")
        if status then
          return { mcp_avante.mcp_tool() }
        end
        return {}
      end

      require("avante").setup(opts)
    end,
  },
}
