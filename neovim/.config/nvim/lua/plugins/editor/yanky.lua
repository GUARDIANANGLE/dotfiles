return {
  "gbprod/yanky.nvim",
  dependencies = {
    { "kkharji/sqlite.lua" },
  },
  opts = {
    ring = { storage = "sqlite" },
  },
  keys = {
    { "<leader>p", "<cmd>YankyRingHistory<cr>", mode = { "n", "x" }, desc = "打开粘贴历史" },
    { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "复制文本" },
    { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "粘贴到光标后" },
    { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "粘贴到光标前" },
    {
      "gp",
      "<Plug>(YankyGPutAfter)",
      mode = { "n", "x" },
      desc = "粘贴到光标后并保持位置",
    },
    {
      "gP",
      "<Plug>(YankyGPutBefore)",
      mode = { "n", "x" },
      desc = "粘贴到光标前并保持位置",
    },
    { "<c-p>", "<Plug>(YankyPreviousEntry)", desc = "上一个历史记录" },
    { "<c-n>", "<Plug>(YankyNextEntry)", desc = "下一个历史记录" },
    { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "缩进粘贴到光标后（整行）" },
    { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "缩进粘贴到光标前（整行）" },
    { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "缩进粘贴到光标后（整行）" },
    { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "缩进粘贴到光标前（整行）" },
    { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "粘贴并右缩进" },
    { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "粘贴并左缩进" },
    { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "粘贴到前并右缩进" },
    { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "粘贴到前并左缩进" },
    { "=p", "<Plug>(YankyPutAfterFilter)", desc = "过滤后粘贴到光标后" },
    { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "过滤后粘贴到光标前" },
  },
}
