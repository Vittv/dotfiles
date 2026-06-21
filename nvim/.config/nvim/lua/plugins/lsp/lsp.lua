return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "folke/lazydev.nvim", opts = {} },
  },
  config = function()
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })
    vim.lsp.config("ts_ls", {
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "mdx" },
    })

    vim.lsp.enable("ts_ls")
    vim.lsp.config("emmet_ls", {
      filetypes = { "astro", "css", "eruby", "html", "htmlangular", "htmldjango",
        "javascriptreact", "less", "pug", "sass", "scss", "svelte", "templ",
        "typescriptreact", "vue", "mdx" },
    })

    vim.lsp.enable("emmet_ls")
  end,
}
