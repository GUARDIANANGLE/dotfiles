-- =============================================================================
-- i18n-zh.lua —— 界面汉化（热插拔）
-- -----------------------------------------------------------------------------
-- 把所有「键位描述（desc/group）」的中文覆盖集中到这个文件，用 which-key 的
-- wk.add 覆盖 LazyVim / 各插件的英文默认描述。
--
-- 启用 / 禁用（二选一）：
--   启用   → 保留本文件（LazyVim 会自动 import "plugins" 目录加载它）
--   禁用   → 删除本文件，或改名为 i18n-zh.lua.disabled
--
-- 注意：obsidian 的输入提示（vim.ui.input / vim.notify）和 dashboard 菜单
--       是功能内嵌文案，无法用 wk.add 覆盖，仍保留在各自插件文件里。
-- =============================================================================

local function apply_zh()
  local wk = require("which-key")

  -- ------------------------------------------------------------------
  -- 1) LazyVim 默认顶层分组名（按空格弹出的 +xxx）
  -- ------------------------------------------------------------------
  wk.add({
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
    { "<leader>S", group = "拼写检查", icon = { icon = "󰓆", color = "green" } },
    { "<leader>i", group = "内联提示", icon = { icon = "ℹ", color = "orange" } },
    { "<leader>m", group = "多光标", icon = { icon = "󰇀", color = "cyan" } },
  })

  -- ------------------------------------------------------------------
  -- 2) LazyVim 默认顶层条目描述
  -- ------------------------------------------------------------------
  wk.add({
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

  -- ------------------------------------------------------------------
  -- 3) 自定义 keymaps（config/keymaps.lua）里的键位描述
  -- ------------------------------------------------------------------
  wk.add({
    { "<leader>nh", desc = "清除搜索高亮" },
    { "<leader>d", desc = "删除但不复制" },
    { "gh", desc = "跳到行首" },
    { "gl", desc = "跳到行尾" },
    { "<leader>fs", desc = "保存文件" },
    { "<leader>fS", desc = "保存（不格式化）" },
    { "<leader>sf", desc = "查找/替换缓冲区" },
    { "<leader>jj", desc = "跳转到字符" },
    { "<leader>gg", desc = "Lazygit（根目录）" },
    { "<leader>gb", desc = "GitButler 终端界面" },
    { "<leader>gh", desc = "GitHub 仪表盘" },
    { "<leader>lc", desc = "LazyVim 更新日志" },
    { "<leader>Ss", desc = "切换拼写检查" },
    { "<leader>Sa", desc = "将单词加入词典" },
    { "<leader>Sw", desc = "标记单词为错误" },
    { "<leader>Su", desc = "撤销加入词典" },
    { "<leader>S=", desc = "拼写建议" },
    { "<leader>Sn", desc = "下一个拼写错误" },
    { "<leader>Sp", desc = "上一个拼写错误" },
    { "<leader>Sf", desc = "编辑拼写文件" },
    { "<leader>ih", desc = "切换内联提示" },
  })

  -- ------------------------------------------------------------------
  -- 4) 各插件的键位描述
  -- ------------------------------------------------------------------
  wk.add({
    { "<leader>p", desc = "打开粘贴历史" }, -- yanky
    { "y", desc = "复制文本" },
    { "p", desc = "粘贴到光标后" },
    { "P", desc = "粘贴到光标前" },
    { "gp", desc = "粘贴到光标后并保持位置" },
    { "gP", desc = "粘贴到光标前并保持位置" },
    { "<c-p>", desc = "上一个历史记录" },
    { "<c-n>", desc = "下一个历史记录" },
    { "]p", desc = "缩进粘贴到光标后（整行）" },
    { "[p", desc = "缩进粘贴到光标前（整行）" },
    { "]P", desc = "缩进粘贴到光标后（整行）" },
    { "[P", desc = "缩进粘贴到光标前（整行）" },
    { ">p", desc = "粘贴并右缩进" },
    { "<p", desc = "粘贴并左缩进" },
    { ">P", desc = "粘贴到前并右缩进" },
    { "<P", desc = "粘贴到前并左缩进" },
    { "=p", desc = "过滤后粘贴到光标后" },
    { "=P", desc = "过滤后粘贴到光标前" },
  })

  wk.add({
    { "<leader>ma", desc = "匹配全部（添加光标）" }, -- multicursor
    { "<C-A-l>", desc = "匹配全部（添加光标）" },
    { "<leader>n ", desc = "通知历史" }, -- noice
    { "<leader>ce", desc = "Emmet 包裹" }, -- emmet
  })

  -- ------------------------------------------------------------------
  -- 5) obsidian 的 which-key 菜单描述（<leader>fo 分组）
  -- ------------------------------------------------------------------
  wk.add({
    { "<leader>fot", desc = "按标签搜索" },
    { "<leader>fob", desc = "查看反向链接" },
    { "<leader>fo0", desc = "在 Obsidian 应用中打开" },
    { "<leader>fos", desc = "搜索笔记" },
    { "<leader>foq", desc = "快速切换" },
    { "<leader>fol", desc = "插入链接" },
    { "<leader>foL", desc = "新建并链接笔记" },
    { "<leader>foc", desc = "切换复选框" },
    { "<leader>foNr", desc = "收藏文章（稍后读）" },
    { "<leader>foNb", desc = "新建读书笔记" },
    { "<leader>foNn", desc = "新建笔记" },
    { "<leader>foNt", desc = "今天的日记" },
    { "<leader>foNm", desc = "明天的日记" },
    { "<leader>foNy", desc = "昨天的日记" },
  })
end

-- 返回 lazy.nvim spec：依赖 which-key 加载完成后执行汉化覆盖
return {
  {
    "folke/which-key.nvim",
    lazy = false,
    config = apply_zh,
  },
}
