return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      return {
        ensure_installed = { "lua_ls", "vtsls" },
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
            })
          end,
          ["lua_ls"] = function()
            require("lspconfig").lua_ls.setup({
              capabilities = capabilities,
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { "vim" },
                  },
                },
              },
            })
          end,
        },
      }
    end,
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "prettierd",
        "eslint_d",
        "stylua",
      },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
    },
  },
}

