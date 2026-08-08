return {
  "obsidian-nvim/obsidian.nvim",
  lazy = true,
  ft = "markdown",
  config = function()
    require("obsidian").setup({
      legacy_commands = false,

      workspaces = {
        { name = "zettelkasten", path = vim.env.OBSIDIAN_VAULT or "~/Documents/zettelkasten" },
        { name = "tasks", path = "~/Documents/Tasks" },
      },

      picker = { name = "snacks.picker" },

      search = {
        sort_by = "modified",
        sort_reversed = true,
      },

      -- render-markdown.nvim is the renderer; keep obsidian's own UI off to avoid double rendering
      ui = { enable = false },

      -- notes have no frontmatter; don't let obsidian add any during the test
      frontmatter = { enabled = false },

      templates = {
        folder = "Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M:%S",
        substitutions = {
          cryptoID = function()
            return tostring(math.random(1000000000, 9999999999))
          end,
        },
      },

      note = { template = "default" },

      attachments = {
        folder = "assets/pictures",
      },

      footer = {
        enabled = true,
        format = "󰌹 {{backlinks}} backlinks  󰄾 {{words}} words  󰈚 {{chars}} chars",
        hl_group = "@property",
        separator = string.rep("—", vim.api.nvim_win_get_width(0)),
      },

      -- mdbox used to be our own spin of a markdown/obsidian configuration
      -- a lot of its functionalities are replaced by obsidian's core logic
      -- and some of it was transfered to markdown.lua, where it belongs

      -- daily_notes is enabled by default and auto-creates its folder (Daily/)
      -- in every workspace on init; mdbox has no daily notes, so disable it
      daily_notes = {
        enabled = false,
      },

      -- mdbox toggles [ ] <-> [x]; obsidian's default cycle is [ ] -> [~] -> [!] -> [>] -> [x]
      checkbox = {
        order = { " ", "x" },
      },

      note_id_func = require("obsidian.builtin").title_id,
      open_notes_in = "current",
    })

    -- mdbox keymap equivalents, buffer-local to obsidian notes
    vim.api.nvim_create_autocmd("User", {
      pattern = "ObsidianNoteEnter",
      callback = function(ev)
        vim.keymap.set("n", "<leader>t", "<cmd>Obsidian tags<cr>", { buffer = true, desc = "Search tags" })
        vim.keymap.set("n", "<leader>ot", "<cmd>Obsidian template<cr>", { buffer = true, desc = "Insert template" })
        vim.keymap.set("n", "<leader>nn", function()
          -- pass "- [ ]" as a single arg (fargs); a <cmd> mapping would split it into 3
          vim.api.nvim_cmd({ cmd = "Obsidian", args = { "search", "- [ ]" } }, {})
        end, { buffer = true, desc = "Project todos" })
        vim.keymap.set("n", "<leader>bl", "<cmd>Obsidian backlinks<cr>", { buffer = true, desc = "Backlinks" })
      end,
    })
  end,
}
