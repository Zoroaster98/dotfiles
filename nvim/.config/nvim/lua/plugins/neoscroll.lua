return {
  "karb94/neoscroll.nvim",
  opts = {
    mappings = {
      "<C-u>",
      "<C-d>",
      "<C-b>",
      "<C-f>",
      "<C-y>",
      "<C-e>",
      "zt",
      "zz",
      "zb",
    },
    hide_cursor = true, -- Keep this true; hiding the cursor reduces visual noise while reading
    stop_eof = true,
    respect_scrolloff = false,
    cursor_scrolls_alone = true,

    -- 1. SMOOTHER TIMING: '1.0' is standard. '1.2' to '1.5' feels more "luxurious" and readable.
    duration_multiplier = 1.0,

    -- 2. NATURAL MOVEMENT: 'sine' or 'quadratic' feels much more organic than 'linear'.
    -- 'linear' = robot constant speed. 'sine' = starts slow, speeds up, slows down.
    easing = "linear",

    pre_hook = nil,
    post_hook = nil,
    performance_mode = false,
    ignored_events = {
      "WinScrolled",
      "CursorMoved",
    },
  },
}
