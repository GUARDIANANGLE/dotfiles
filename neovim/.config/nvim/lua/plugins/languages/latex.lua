return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "latex" } },
  },
  {
    -- LaTeX editing, compilation, and preview
    "lervag/vimtex",
    ft = "tex",
    lazy = true,
    init = function()
      -- Use xelatex (required for CJK/Chinese via ctex) with latexmk
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        options = {
          "-xelatex",
          "-shell-escape",
          "-synctex=1",
          "-interaction=nonstopmode",
          "-file-line-error",
        },
      }
      -- View PDF with the system default viewer (Skim/Preview on macOS)
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_quickfix_mode = 0
      -- Disable auto-compile on save; use \ll to compile manually
      vim.g.vimtex_compiler_silent = 0
    end,
  },
  {
    -- LaTeX language server: diagnostics, completion, goto definition
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        texlab = {
          settings = {
            texlab = {
              build = {
                executable = "latexmk",
                args = { "-xelatex", "-shell-escape", "-synctex=1", "-interaction=nonstopmode", "-file-line-error", "%f" },
                onSave = false,
              },
              forwardSearch = {
                executable = "latexmk",
                args = { "-xelatex", "-synctex=1", "-interaction=nonstopmode", "-file-line-error", "%f" },
              },
            },
          },
        },
        -- Disable LTeX (English spelling/grammar checker) for .tex files:
        -- it floods Chinese LaTeX docs with false positives like
        -- "Possible spelling mistake" / "does not start with an uppercase letter".
        ltex = {
          settings = {
            ltex = {
              enabled = { "markdown", "text", "gitcommit" }, -- keep for prose, drop tex/bib/latex
              diagnosticSeverity = "information",
            },
          },
        },
      },
    },
  },
  {
    -- Real-time inline math preview for $...$ formulas (virtual text)
    "jbyuki/nabla.nvim",
    ft = "tex",
    keys = {
      { "<leader>mp", function() require("nabla").popup() end, desc = "预览光标处公式 (popup)" },
      { "<leader>mt", function() require("nabla").toggle_virt() end, desc = "切换公式内联预览" },
    },
  },
  {
    -- Inline render for markdown math formulas (already a LazyVim default)
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      latex = {
        enabled = true,
        converter = "latex2text",
      },
    },
  },
}
