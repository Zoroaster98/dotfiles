return {
  "tpope/vim-eunuch",
  -- We lazy-load this plugin only when the specific commands or keybinds are summoned.
  cmd = { "Move", "Rename", "Delete", "Mkdir" },
  keys = {
    {
      "<leader>om",
      function()
        -- 1. Identify the current subject
        local current_file = vim.fn.expand("%:p")

        -- 2. Construct the command string
        -- :Move acts as the vehicle for translocation.
        -- fnameescape protects against spaces in the path.
        local cmd = ":Move " .. vim.fn.fnameescape(current_file)

        -- 3. Feed the keys to the command line
        -- We do not add <CR> (Enter) at the end, so you may edit the path.
        vim.api.nvim_feedkeys(cmd, "n", false)
      end,
      desc = "Translocate active buffer (Eunuch)",
    },
  },
}
