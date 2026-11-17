-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local api = vim.api
local set = vim.keymap.set
local del = vim.keymap.del
local wk = require("which-key")
local Snacks = require("snacks")

-- unset
del({ "n", "i", "v" }, "<A-k>")
del({ "n", "i", "v" }, "<A-j>")

-- UI -------------------------------------------------
set("n", "<leader>nh", ":nohl<CR>", { noremap = true, silent = true, desc = "清除搜索高亮" })

-- JK to exit insert mode
api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = false, desc = "退出插入模式" })

-- delete without yanking
set({ "n", "v" }, "<leader>d", '"_d', { noremap = true, silent = true, desc = "删除但不复制" })

-- jump to beginning/end of line
set("n", "gh", "^", { noremap = true, silent = true, desc = "跳到行首" })
set("n", "gl", "$", { noremap = true, silent = true, desc = "跳到行尾" })

-- alt-backspace
set({ "i", "c" }, "<A-BD>", "<C-w>", { noremap = true, desc = "删除一个单词（Alt+退格）" })
set("n", "<A-BS>", "db", { noremap = true, desc = "删除一个单词（Alt+退格）" })

set("n", "U", "<C-r>", { noremap = true, silent = true, desc = "用 U 重做" })
-- set("n", "<C-a>", "ggVG", { noremap = true, silent = true, desc = "全选" })

set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "退出终端模式" })

-- duplicate lines up/down
set({ "n", "v" }, "<A-S-d>", "Vy`<p`>", { noremap = true, silent = true, desc = "向下复制一行" })

set({ "n", "v" }, "<A-S-d>", "Vy`<p`>", { noremap = true, silent = true, desc = "向下复制一行" })
-- set({ "n", "v" }, "<A-S-k>", "Vy`<p`>", { noremap = true, silent = true, desc = "向下复制一行" })

-- indent line
set("v", ">", ">gv", { noremap = true, silent = true, desc = "右缩进并保持选中" })
set("v", "<", "<gv", { noremap = true, silent = true, desc = "左缩进并保持选中" })

-- move line down
set({ "n", "v" }, "<A-down>", ":m .+1<CR>==", { noremap = true, silent = true, desc = "下移一行" })
set({ "n", "v" }, "<A-S-j>", ":m .+1<CR>==", { noremap = true, silent = true, desc = "下移一行" })

-- move line up
set({ "n", "v" }, "<A-up>", ":m .-2<CR>==", { noremap = true, silent = true, desc = "上移一行" })
set({ "n", "v" }, "<A-S-k>", ":m .-2<CR>==", { noremap = true, silent = true, desc = "上移一行" })

-- toggle terminal
set({ "n", "t" }, "<C-`>", function()
  Snacks.terminal(nil, { border = "none" })
end, { noremap = true, silent = true, desc = "切换终端" })

---- move around splits
set("n", "<leader>wh", "<C-w>h", { noremap = true, silent = true, desc = "切换到左侧窗口" })
set("n", "<leader>wj", "<C-w>j", { noremap = true, silent = true, desc = "切换到下方窗口" })
set("n", "<leader>wk", "<C-w>k", { noremap = true, silent = true, desc = "切换到上方窗口" })
set("n", "<leader>wl", "<C-w>l", { noremap = true, silent = true, desc = "切换到右侧窗口" })
set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "切换到左侧窗口" })
set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "切换到下方窗口" })
set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "切换到上方窗口" })
set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "切换到右侧窗口" })

-- set("n", "<ENTER>", "za", { noremap = true, silent = true, desc = "代码折叠" })
-- indenting
set("n", "<C-]>", ">>", { noremap = true, silent = true, desc = "右缩进" })
set("n", "<C-[>", "<<", { noremap = true, silent = true, desc = "左缩进" })
set("v", "<C-]>", ">gv", { noremap = true, silent = true, desc = "右缩进并保持选中" })
set("v", "<C-[>", "<gv", { noremap = true, silent = true, desc = "左缩进并保持选中" })
-- shift+.
set("n", ">", ">>", { noremap = true, silent = true, desc = "右缩进" })
set("v", ">", ">gv", { noremap = true, silent = true, desc = "右缩进并保持选中" })
-- shift+,
set("n", "<", "<<", { noremap = true, silent = true, desc = "左缩进" })
set("v", "<", "<gv", { noremap = true, silent = true, desc = "左缩进并保持选中" })
-- jump to character like vspacecode
set({ "n", "x", "o" }, "<leader>jj", function()
  require("flash").jump()
end, { noremap = true, silent = true, desc = "跳转到字符" })
-- save like vspacecode
set("n", "<leader>fs", ":w<CR>", { noremap = true, silent = true, desc = "保存文件" })
set("n", "<leader>fS", ":noautocmd w<CR>", { noremap = true, silent = true, desc = "保存（不格式化）" })
set("n", "<leader>sf", ":%s#", { desc = "查找/替换缓冲区" })

-- Spelling ----------------------------------------
wk.add({ { "<leader>S", group = "拼写检查", icon = { icon = "󰓆", color = "green" } } })
set("n", "<leader>Ss", function()
  vim.opt_local.spell = not vim.opt_local.spell:get()
  vim.notify(vim.opt_local.spell:get() and "Spell check ON" or "Spell check OFF")
end, { desc = "切换拼写检查" })
set("n", "<leader>Sa", "zg", { remap = true, desc = "将单词加入词典" })
set("n", "<leader>Sw", "zw", { remap = true, desc = "标记单词为错误" })
set("n", "<leader>Su", "zug", { remap = true, desc = "撤销加入词典" })
set("n", "<leader>S=", "z=", { remap = true, desc = "拼写建议" })
set("n", "<leader>Sn", "]s", { remap = true, desc = "下一个拼写错误" })
set("n", "<leader>Sp", "[s", { remap = true, desc = "上一个拼写错误" })
set("n", "<leader>Sf", function()
  vim.cmd("edit " .. vim.fn.stdpath("config") .. "/spell/en.utf-8.add")
end, { desc = "编辑拼写文件" })

-- toggle inlay hints
wk.add({ { "<leader>i", group = "内联提示", icon = { icon = "ℹ", color = "orange" } } })
set("n", "<leader>ih", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  vim.notify(vim.lsp.inlay_hint.is_enabled() and "Inlay Hints Enabled" or "Inlay Hints Disabled")
end, { desc = "切换内联提示" })

-- Move LazyVim changelog from <leader>L to <leader>l
set("n", "<leader>lc", function()
  LazyVim.news.changelog()
end, { desc = "LazyVim 更新日志" })
del("n", "<leader>L")

-- borderless lazygit
set("n", "<leader>gg", function()
  Snacks.lazygit({ cwd = vim.fn.getcwd(), esc_esc = false, ctrl_hjkl = false, border = "none" })
end, { noremap = true, silent = true, desc = "Lazygit（根目录）" })

-- GitButler TUI
set("n", "<leader>gb", function()
  Snacks.terminal({ "but", "tui" }, { cwd = vim.fn.getcwd(), win = { border = "rounded" } })
end, { noremap = true, silent = true, desc = "GitButler 终端界面" })

-- GitHub Dash
set("n", "<leader>gh", function()
  Snacks.terminal({ "gh", "dash" }, { cwd = vim.fn.getcwd(), win = { border = "rounded" } })
end, { noremap = true, silent = true, desc = "GitHub 仪表盘" })

--------------------------------------------------------------------------------------------
---- MacOS CMD keymaps ---------------------------------------------------------------------
---- CSI u keyboard protocol must be supported by your terminal ----------------------------
--------------------------------------------------------------------------------------------
set("n", "<D-c>", '"+yiw', { noremap = true, silent = true, desc = "复制单词" })
set("v", "<D-c>", '"+y', { noremap = true, silent = true, desc = "复制选中内容" })
set("n", "<D-v>", '"+p', { noremap = true, silent = true, desc = "粘贴" })
set("v", "<D-v>", '"+p', { noremap = true, silent = true, desc = "粘贴" })
set("i", "<D-v>", "<C-r>+", { noremap = true, silent = true, desc = "插入模式下粘贴" })
set("n", "<D-x>", '"+diw', { noremap = true, silent = true, desc = "剪切单词" })
set("v", "<D-x>", '"+d', { noremap = true, silent = true, desc = "剪切选中内容" })
set("n", "<D-s>", ":w<CR>", { noremap = true, silent = true, desc = "保存文件" })
set("n", "<D-z>", "u", { noremap = true, silent = true, desc = "撤销" })
set("i", "<D-z>", "<C-o>u", { noremap = true, silent = true, desc = "插入模式下撤销" })
set("n", "<D-S-z>", "<C-r>", { noremap = true, silent = true, desc = "重做" })
set("i", "<D-S-z>", "<C-o><C-r>", { noremap = true, silent = true, desc = "插入模式下重做" })
set("n", "<D-a>", "ggVG", { noremap = true, silent = true, desc = "全选" })

--------------------------------------------------------------------------------------------
---- Which-Key 分组与顶层条目汉化 ---------------------------------------------------------
---- 覆盖 LazyVim 默认注入的英文分组名和描述（wk.add 对已注册键位仅更新描述，零风险） ----
--------------------------------------------------------------------------------------------
wk.add({
  -- 顶层分组名
  { "<leader>c", group = "代码", icon = { icon = "󰘦", color = "green" } },
  { "<leader>d", group = "调试", icon = { icon = "󰃘", color = "red" } },
  { "<leader>f", group = "文件/查找", icon = { icon = "󰈞", color = "cyan" } },
  { "<leader>g", group = "Git", icon = { icon = "󰊢", color = "orange" } },
  { "<leader>q", group = "退出/会话", icon = { icon = "󰈆", color = "red" } },
  { "<leader>s", group = "搜索", icon = { icon = "󰍉", color = "cyan" } },
  { "<leader>u", group = "界面", icon = { icon = "󰔨", color = "blue" } },
  { "<leader>x", group = "诊断/快速修复", icon = { icon = "󱖫", color = "red" } },
  { "<leader>b", group = "缓冲区" },
  { "<leader>w", group = "窗口" },
  { "<leader><tab>", group = "标签页" },

  -- 顶层条目描述
  { "<leader>e", desc = "文件资源管理器（根目录）" },
  { "<leader>E", desc = "文件资源管理器（当前目录）" },
  { "<leader>K", desc = "关键字查找" },
  { "<leader>p", desc = "打开粘贴历史" },
  { "<leader>?", desc = "缓冲区按键（which-key）" },
  { "<leader>:", desc = "命令历史" },
  { "<leader>,", desc = "缓冲区列表" },
  { "<leader>-", desc = "向下分屏" },
  { "<leader>|", desc = "向右分屏" },
  { "<leader>.", desc = "切换临时缓冲区" },
  { "<leader>/", desc = "全文搜索（根目录）" },
  { "<leader>`", desc = "切换到其他缓冲区" },
  { "<leader><Space>", desc = "查找文件（根目录）" },
  { "<leader>l", desc = "插件管理器" },
})
