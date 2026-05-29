return {
  "lervag/vimtex",
  lazy = false, -- Or ft = { 'tex', 'latex' } to load on filetype
  config = function()
    -- This enables the Zathura viewer
    vim.g.vimtex_view_method = "zathura"

    -- This makes the compilation process happen without interrupting you
    vim.g.vimtex_compiler_latexmk = {
      continuous = 1,
      executable = "latexmk",
      options = {
        "-pdf",
        "-shell-escape",
        "-verbose",
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
      },
    }
    vim.g.vimtex_compiler_latexmk_engines = {
      _ = "-xelatex",
    }
  end,
}
