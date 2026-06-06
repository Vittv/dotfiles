return {
  "saghen/blink.cmp",
  event = "InsertEnter",
  version = "1.*",
  dependencies = {
    { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
    "rafamadriz/friendly-snippets",
    "onsails/lspkind.nvim",
  },
  config = function(_, opts)
    require("luasnip.loaders.from_vscode").lazy_load()
    require("blink.cmp").setup(opts)
  end,
  opts = {
    snippets = {
      preset = "luasnip",
    },
    sources = {
      default = { "lsp", "snippets", "buffer", "path" },
    },
    keymap = {
      preset = "none",
      ["<C-k>"]     = { "select_prev", "fallback" },
      ["<C-j>"]     = { "select_next", "fallback" },
      ["<C-b>"]     = { "scroll_documentation_up", "fallback" },
      ["<C-f>"]     = { "scroll_documentation_down", "fallback" },
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"]     = { "hide", "fallback" },
      ["<Tab>"]     = { "accept", "fallback" },
    },
    completion = {
      documentation = {
        auto_show = true,
        window = { border = "rounded" },
      },
      menu = {
        border = "rounded",
        draw = {
          treesitter = { "lsp" },
          components = {
            kind_icon = {
              text = function(ctx)
                local lspkind = require("lspkind")
                return lspkind.symbolic(ctx.kind, { mode = "symbol" }) .. " "
              end,
            },
          },
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
            { "kind" },
          },
        },
      },
    },
  },
}
