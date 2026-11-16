return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false, -- the main branch does not support lazy-loading
  build = ":TSUpdate",
  config = function()
    -- Async; already-installed parsers are skipped
    require("nvim-treesitter").install({
      "javascript", "typescript", "tsx", "json", "html", "css",
      "python", "lua", "vim", "vimdoc", "query",
      "bash", "yaml", "toml", "xml", "markdown", "markdown_inline",
      "regex", "diff", "gitcommit", "sql",
    })

    -- Highlighting: start treesitter for any buffer that has a parser
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(ev)
        pcall(vim.treesitter.start, ev.buf) -- silently skips filetypes with no parser
      end,
    })

    -- Optional: treesitter-based folding (starts unfolded)
    -- vim.opt.foldmethod = "expr"
    -- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    -- vim.opt.foldlevelstart = 99

  end,
}
