local function open_project(path)
  vim.cmd("cd " .. vim.fn.fnameescape(vim.fn.expand(path)))
  local ok, persistence = pcall(require, "persistence")
  if ok and vim.fn.filereadable(persistence.current()) == 1 then
    persistence.load()
  else
    vim.cmd("enew")
  end
end

return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        keys = {
          {
            icon = "󱈅 ",
            key = "o",
            desc = "恢复会话",
            action = function()
              require("persistence").select()
            end,
          },
          {
            icon = "⊙ ",
            key = "d",
            desc = "打开配置仓库",
            action = function()
              open_project("~/.dotfiles")
            end,
          },
          {
            icon = "\u{E6AE} ",
            key = "v",
            desc = "打开 Nvim 配置",
            action = function()
              open_project("~/.dotfiles/neovim/.config/nvim")
            end,
          },
          {
            icon = "\u{F082E} ",
            key = "n",
            desc = "打开 FieldNotes 笔记库",
            action = function()
              open_project("~/Library/Mobile Documents/iCloud~md~obsidian/Documents/FieldNotes✱")
            end,
          },
          { icon = "󰩈 ", key = "q", desc = "退出", action = ":qa" },
        },
        header = [[
        ███╗   ██╗███████╗ ██████╗    ███████╗██████╗
        ████╗  ██║██╔════╝██╔═══██╗   ██╔════╝██╔══██╗
        ██╔██╗ ██║█████╗  ██║   ██║   █████╗  ██║  ██║
        ██║╚██╗██║██╔══╝  ██║   ██║   ██╔══╝  ██║  ██║
        ██║ ╚████║███████╗╚██████╔╝██╗███████╗██████╔╝
        ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝╚══════╝╚═════╝ ]],
      },
    },
  },
}
