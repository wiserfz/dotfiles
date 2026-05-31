local sidekick = require("sidekick")
local cli = require("sidekick.cli")
local wk = require("which-key")

local M = {}

function M.setup()
  ---@module "sidekick"
  ---@type sidekick.Config
  local opts = {
    -- add any options here
    cli = {
      mux = {
        backend = "tmux",
        enabled = true,
      },
    },
    nes = { enabled = false },
  }

  sidekick.setup(opts)

  wk.add({
    { "<leader>a", group = "AI Sidekick" },

    {
      "<leader>aa",
      function()
        cli.toggle()
      end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>as",
      function()
        cli.select()
      end,
      desc = "Sidekick Select CLI",
    },
    {
      "<leader>at",
      function()
        cli.send({ msg = "{this}" })
      end,
      mode = { "x", "n" },
      desc = "Sidekick Send This",
    },
    {
      "<leader>av",
      function()
        cli.send({ msg = "{selection}" })
      end,
      mode = { "x" },
      desc = "Sidekick Send Visual Selection",
    },
    {
      "<leader>ap",
      function()
        cli.prompt()
      end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    {
      "<c-.>",
      function()
        cli.focus()
      end,
      mode = { "n", "x", "i", "t" },
      desc = "Sidekick Switch Focus",
    },
    {
      "<leader>ad",
      function()
        cli.close()
      end,
      desc = "Detach a CLI Session",
    },
  })
end

return M
