-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
local g = vim.g
local o = vim.o

-- Ensure GUI-launched Neovim (from Dock/Finder) sees the same PATH as an
-- interactive shell, so Mason can find npm/go/bun etc. to install LSPs.
do
  local extra = {
    "/opt/homebrew/bin",
    "/opt/homebrew/sbin",
    os.getenv("HOME") .. "/.bun/bin",
    os.getenv("HOME") .. "/.cargo/bin",
    os.getenv("HOME") .. "/Library/pnpm/bin",
    os.getenv("HOME") .. "/.local/bin",
    os.getenv("HOME") .. "/go/bin",
  }
  local current = os.getenv("PATH") or ""
  local function prepend(p)
    if vim.uv.fs_stat(p) and not current:match(vim.pesc(p) .. ":") then
      current = p .. ":" .. current
    end
  end
  for _, p in ipairs(extra) do
    prepend(p)
  end
  -- fnm-managed node: discover the active version dir (e.g. v26.13.1/installation/bin)
  local fnm_root = os.getenv("HOME") .. "/.local/share/fnm/node-versions"
  local ok, handle = pcall(vim.uv.fs_scandir, fnm_root)
  if ok and handle then
    local entries = {}
    while true do
      local name, _ = vim.uv.fs_scandir_next(handle)
      if not name then
        break
      end
      entries[#entries + 1] = name
    end
    for _, name in ipairs(entries) do
      prepend(fnm_root .. "/" .. name .. "/installation/bin")
    end
  end
  vim.env.PATH = current
end

o.timeoutlen = 250

g.loaded_python3_provider = 0

opt.cursorline = true
opt.scrolloff = 8

opt.linespace = 2
opt.textwidth = 100
opt.colorcolumn = "100"
opt.wrap = true

opt.swapfile = false
opt.backup = false

opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.local/state/nvim/undo"

opt.spell = false
opt.spelllang = "en_us"

g.lazygit_config = false
