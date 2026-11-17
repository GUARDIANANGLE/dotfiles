-- Store URL for template substitution (module-level for access in substitutions)
local reading_url = ""
local book_title = ""

-- Fetch Open Graph title from URL (macOS compatible)
local function fetch_og_title(url)
  -- Try og:title first using sed (macOS compatible)
  local handle = io.popen(
    string.format(
      [[curl -sL --max-time 10 "%s" 2>/dev/null | tr '\n' ' ' | sed -n 's/.*<meta[^>]*property="og:title"[^>]*content="\([^"]*\)".*/\1/p' | head -1]],
      url
    )
  )
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result and vim.trim(result) ~= "" then
      return vim.trim(result)
    end
  end

  -- Try alternate og:title format (content before property)
  handle = io.popen(
    string.format(
      [[curl -sL --max-time 10 "%s" 2>/dev/null | tr '\n' ' ' | sed -n 's/.*<meta[^>]*content="\([^"]*\)"[^>]*property="og:title".*/\1/p' | head -1]],
      url
    )
  )
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result and vim.trim(result) ~= "" then
      return vim.trim(result)
    end
  end

  -- Fallback to <title> tag
  handle = io.popen(
    string.format(
      [[curl -sL --max-time 10 "%s" 2>/dev/null | tr '\n' ' ' | sed -n 's/.*<title>\([^<]*\)<\/title>.*/\1/p' | head -1]],
      url
    )
  )
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result and vim.trim(result) ~= "" then
      return vim.trim(result)
    end
  end

  return nil
end

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  event = "VeryLazy",
  config = function()
    local vault_path = vim.fn.expand("~") .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/FieldNotes✱"

    require("obsidian").setup({
      legacy_commands = false,
      -- Use title as filename instead of zettel ID
      note_id_func = function(title)
        if title ~= nil and title ~= "" then
          -- Sanitize title for filename
          return title:gsub('[/\\:*?"<>|]', "-"):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", ""):gsub("%-+", "-")
        end
        -- Fallback to timestamp if no title
        return tostring(os.time())
      end,
      workspaces = {
        {
          name = "FieldNotes✱",
          path = vault_path,
        },
      },
      daily_notes = {
        folder = "HUB/TheLog",
        date_format = "%Y-%m-%d",
        alias_format = "%B %-d, %Y",
        template = "New-DailyLog.md",
      },
      templates = {
        folder = "HUB/Attachments/Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {
          yesterday = function()
            return os.date("%Y-%m-%d", os.time() - 86400)
          end,
          tomorrow = function()
            return os.date("%Y-%m-%d", os.time() + 86400)
          end,
          date_long = function()
            return os.date("%A, %B %d, %Y")
          end,
          url = function()
            return reading_url
          end,
          title = function()
            return book_title
          end,
        },
        -- Per-template customizations for directory placement
        -- Keys are matched against the template filename WITHOUT its extension
        customizations = {
          ["New-Reading"] = {
            notes_subdir = "HUB/ReadingList",
          },
          ["New-Book"] = {
            notes_subdir = "HUB/ReadingList",
          },
          ["New-Devotional"] = {
            notes_subdir = "HUB/Devotionals",
          },
        },
      },
    })

    -- Create custom command for URL-based reading notes
    vim.api.nvim_create_user_command("ObsidianNewReading", function()
      vim.ui.input({ prompt = "输入网址: " }, function(url)
        if not url or url == "" then
          vim.notify("未输入网址", vim.log.levels.WARN)
          return
        end

        -- Store URL for template substitution
        reading_url = url

        vim.notify("正在抓取网页标题...", vim.log.levels.INFO)

        -- Fetch OG title
        local title = fetch_og_title(url)
        if not title then
          vim.notify("无法抓取标题，改用域名", vim.log.levels.WARN)
          -- Extract domain as fallback title
          title = url:match("https?://([^/]+)") or url:match("://([^/]+)") or "阅读笔记"
        end

        vim.notify("正在创建笔记: " .. title, vim.log.levels.INFO)

        -- Use Obsidian command API for stability across plugin updates
        vim.schedule(function()
          vim.cmd("Obsidian new_from_template '" .. title:gsub("'", "\\'") .. "' 'New-Reading'")
        end)
      end)
    end, { desc = "从网址创建阅读笔记" })

    -- Create custom command for book notes
    vim.api.nvim_create_user_command("ObsidianNewBook", function()
      vim.ui.input({ prompt = "输入书名: " }, function(title)
        if not title or title == "" then
          vim.notify("未输入书名", vim.log.levels.WARN)
          return
        end

        -- Store title for template substitution
        book_title = title

        vim.notify("正在创建读书笔记: " .. title, vim.log.levels.INFO)

        -- Use Obsidian command API for stability across plugin updates
        vim.schedule(function()
          vim.cmd("Obsidian new_from_template '" .. title:gsub("'", "\\'") .. "' 'New-Book'")
        end)
      end)
    end, { desc = "创建读书笔记" })

    -- Which-Key group and keybindings
    local wk = require("which-key")
    wk.add({
      { "<leader>fo", group = "Obsidian", icon = { icon = "󰠮", color = "purple" } },
      { "<leader>fot", ":Obsidian tags ", desc = "按标签搜索", icon = { icon = "", color = "orange" } },
      { "<leader>fob", ":Obsidian backlinks<CR>", desc = "查看反向链接", icon = { icon = "⬅", color = "cyan" } },
      {
        "<leader>fo0",
        ":Obsidian open<CR>",
        desc = "在 Obsidian 应用中打开",
        icon = { icon = "󱓞", color = "purple" },
      },
      { "<leader>fos", ":Obsidian search<CR>", desc = "搜索笔记", icon = { icon = "", color = "cyan" } },
      { "<leader>foq", ":Obsidian quick_switch<CR>", desc = "快速切换", icon = { icon = "⚡", color = "purple" } },
      { "<leader>fol", ":Obsidian link<CR>", desc = "插入链接", icon = { icon = "", color = "blue" } },
      { "<leader>foL", ":Obsidian link_new ", desc = "新建并链接笔记", icon = { icon = "", color = "green" } },
      {
        "<leader>foc",
        ":Obsidian toggle_checkbox<CR>",
        desc = "切换复选框",
        icon = { icon = "", color = "green" },
      },
      {
        "<leader>foNr",
        ":ObsidianNewReading<CR>",
        desc = "收藏文章（稍后读）",
        icon = { icon = "", color = "orange" },
      },
      { "<leader>foNb", ":ObsidianNewBook<CR>", desc = "新建读书笔记", icon = { icon = "󱉟", color = "orange" } },
      { "<leader>foNn", ":Obsidian new ", desc = "新建笔记", icon = { icon = "", color = "blue" } },
      { "<leader>foNt", ":Obsidian today<CR>", desc = "今天的日记", icon = { icon = "󰃶", color = "red" } },
      {
        "<leader>foNm",
        ":Obsidian tomorrow<CR>",
        desc = "明天的日记",
        icon = { icon = "▶", color = "grey" },
      },
      {
        "<leader>foNy",
        ":Obsidian yesterday<CR>",
        desc = "昨天的日记",
        icon = { icon = "◀", color = "grey" },
      },
    })
  end,
}
