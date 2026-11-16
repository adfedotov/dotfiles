return {
  "saghen/blink.cmp",
  version = "1.*", -- prebuilt fuzzy-matcher binaries
  event = "InsertEnter",
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = {
    keymap = { preset = "enter" }, -- <CR> accept, <C-space> open, <C-n>/<C-p> navigate
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 300 },
    },
    signature = { enabled = true },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
  },
}
