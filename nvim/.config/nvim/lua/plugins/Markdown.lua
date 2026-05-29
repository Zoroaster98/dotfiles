return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
    keys = {
      {
        "<leader>mp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
  },
  -- https://github.com/hedyhli/outline.nvim
  -- A sidebar with a tree-like outline of symbols from your code, powered by LSP
  --
  -- There are also some related plugins like `aerial.nvim` found below
  -- https://github.com/hedyhli/outline.nvim?tab=readme-ov-file#related-plugins
  --
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { -- Example mapping to toggle outline
      { "<leader>ol", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {
      symbol_folding = {
        -- Unfold entire symbol tree by default with false, otherwise enter a
        -- number starting from 1
        autofold_depth = false,
        -- autofold_depth = 1,
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-mini/mini.icons",
    },
    -- We load this plugin on very specific file events to ensure
    -- it is available when Snacks picker attempts to preview markdown.
    ft = { "markdown", "norg", "rmd", "org" },
    opts = {
      file_types = { "markdown", "norg", "rmd", "org" },
      -- Configure the code block rendering to look clean in previews
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      -- Headings configuration creates the visual hierarchy
      heading = {
        sign = true,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        signs = { "󰫎 " },
        backgrounds = {
          "RenderMarkdownH1Bg",
          "RenderMarkdownH2Bg",
          "RenderMarkdownH3Bg",
          "RenderMarkdownH4Bg",
          "RenderMarkdownH5Bg",
          "RenderMarkdownH6Bg",
        },
        foregrounds = {
          "RenderMarkdownH1",
          "RenderMarkdownH2",
          "RenderMarkdownH3",
          "RenderMarkdownH4",
          "RenderMarkdownH5",
          "RenderMarkdownH6",
        },
      },
      -- Bullet points replacement
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
      },
      checkbox = {
        enabled = true,
        position = "inline",
        unchecked = {
          icon = "󰄱 ",
          highlight = "RenderMarkdownUnchecked",
        },
        checked = {
          icon = "󰱒 ",
          highlight = "RenderMarkdownChecked",
        },
        custom = {
          todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
        },
      },
      -- Ensure it doesn't conflict with existing latex rendering
      latex = {
        enabled = false,
        converter = "latex2text",
        highlight = "RenderMarkdownMath",
        top_pad = 0,
        bottom_pad = 0,
      },
      quote = {
        enabled = true,
        icon = "▋",
        repeat_linebreak = true,
        highlight = "RenderMarkdownQuote",
      },
      -- Pipe table rendering
      pipe_table = {
        preset = "heavy",
        style = "full",
        cell = "padded",
        alignment_indicator = "━",
        head = "RenderMarkdownTableHead",
        row = "RenderMarkdownTableRow",
        filler = "RenderMarkdownTableFill",
      },
      -- Callouts/Admonitions setup
      callout = {
        note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
        tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
        important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownWarn" },
        warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
        caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
      },
      link = {
        enabled = true,
        image = "󰥶 ",
        email = "󰀆 ",
        hyperlink = "󰌹 ",
        highlight = "RenderMarkdownLink",
        wiki = { icon = "󱗆 ", highlight = "RenderMarkdownWiki" },
        custom = {
          web = { pattern = "^http[s]?://", icon = "󰖟 ", highlight = "RenderMarkdownLink" },
        },
      },
      sign = {
        enabled = true,
        highlight = "RenderMarkdownSign",
      },
    },
  },
}
