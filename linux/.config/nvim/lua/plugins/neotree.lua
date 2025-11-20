return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
    "antosha417/nvim-lsp-file-operations",
	},
	config = function()
    require("lsp-file-operations").setup()

		vim.keymap.set("n", "<space><Tab>", ":Neotree filesystem toggle float<CR>", {})
		vim.keymap.set("n", "<leader>bf", ":Neotree buffers toggle float<CR>", {})
    vim.keymap.set("n", "<leader>gs", ":Neotree git_status toggle float<CR>")

    require("neo-tree").setup({
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        window = {
          position = "float",
          popup = {
            size = {
              height = "70%",
              width = "70%",
            },
            position = "50%",
          },
        },
      },
    })
	end,
}
