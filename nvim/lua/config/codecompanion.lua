local code = require("codecompanion")
local adapters = require("codecompanion.adapters")
local wk = require("which-key")

local M = {}

function M.setup()
  vim.cmd([[cab cc CodeCompanion]])

  code.setup({
    adapters = {
      ollama = function()
        return adapters.extend("ollama", {
          schema = {
            model = {
              default = "llama3.1:latest",
            },
          },
        })
      end,
    },
    strategies = {
      chat = {
        adapter = "ollama",
        roles = {
          llm = "󱚦  CodeCompanion", -- The markdown header content for the LLM's responses
          user = "😀 Wiser", -- The markdown header for your questions
        },
      },
      inline = { adapter = "ollama" },
      agent = { adapter = "ollama" },
    },
  })

  wk.add({
    noremap = true,
    silent = true,

    { "<leader>c", group = "AI" },

    {
      "<leader>co",
      "<cmd>CodeCompanionActions<cr>",
      desc = "Open the CodeCompanion action picker",
    },
    {
      "<leader>ct",
      "<cmd>CodeCompanionChat Toggle<cr>",
      desc = "Toggle CodeCompanion chat buffer",
    },
    {
      "<leader>ca",
      "<cmd>CodeCompanionAdd<CR>",
      desc = "Add selected text to CodeCompanion",
    },
  })
end

return M
