---@diagnostic disable: undefined-doc-name, undefined-field
local codecompanion = require("codecompanion")
local adapters = require("codecompanion.adapters")

local spinner = {
  completed = "󰗡 Completed",
  error = " Error",
  cancelled = "󰜺 Cancelled",
}

---Format the adapter name and model for display with the spinner
---@param adapter CodeCompanion.Adapter
---@return string
local function format_adapter(adapter)
  local parts = {}
  table.insert(parts, adapter.formatted_name)
  if adapter.model and adapter.model ~= "" then
    table.insert(parts, "(" .. adapter.model .. ")")
  end
  return table.concat(parts, " ")
end

---Setup the spinner for CodeCompanion
---@return nil
local function codecompanion_spinner()
  local ok, progress = pcall(require, "fidget.progress")
  if not ok then
    return
  end

  spinner.handles = {}

  local group = vim.api.nvim_create_augroup("dotfiles.codecompanion.spinner", {})

  vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionRequestStarted",
    group = group,
    callback = function(args)
      local handle = progress.handle.create({
        title = "",
        message = "  Sending...",
        lsp_client = {
          name = format_adapter(args.data.adapter),
        },
      })
      spinner.handles[args.data.id] = handle
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionRequestFinished",
    group = group,
    callback = function(args)
      local handle = spinner.handles[args.data.id]
      spinner.handles[args.data.id] = nil
      if handle then
        if args.data.status == "success" then
          handle.message = spinner.completed
        elseif args.data.status == "error" then
          handle.message = spinner.error
        else
          handle.message = spinner.cancelled
        end
        handle:finish()
      end
    end,
  })
end

local M = {}

function M.setup()
  local base_url = os.getenv("AI_GATEWAY_BASE_URL")
  local auth_token = os.getenv("AI_AUTH_TOKEN")

  local opts = {
    adapters = {
      http = {
        opts = {
          allow_insecure = true,
          proxy = "http://127.0.0.1:10800",
          show_presets = false,
        },

        anthropic = function()
          return adapters.extend("anthropic", {
            url = base_url,
            env = {
              api_key = auth_token,
            },
            schema = {
              default = "claude-opus-4-7",
            },
            opts = {
              compaction = false,
            },
          })
        end,

        openai_responses = function()
          return adapters.extend("openai_responses", {
            url = base_url .. "/openai/v1/responses",
            env = {
              api_key = auth_token,
            },
            schema = {
              model = {
                default = "gpt-5.5",
                choices = {
                  ["gpt-5.5"] = {
                    formatted_name = "GPT-5.5",
                    opts = {
                      can_manage_context = true,
                      has_function_calling = true,
                      has_vision = true,
                      can_reason = true,
                    },
                  },
                },
              },
              ["reasoning.effort"] = {
                default = "high",
              },
            },
            opts = {
              compaction = false,
            },
          })
        end,
      },
    },
    interactions = {
      chat = {
        -- adapter = {
        --   name = "claude_code",
        --   model = "claude-sonnet-4-6",
        -- },
        adapter = "anthropic",
        opts = {
          completion_provider = "blink",
        },
      },
      inline = {
        adapter = "openai_responses",
      },
      background = {
        adapter = "openai_responses",
      },
      cli = {
        agent = "claude_code",
        agents = {
          claude_code = {
            cmd = "claude",
            description = "Claude Code CLI",
          },
          codex = {
            cmd = "codex",
            description = "OpenAI Codex CLI",
          },
        },
      },
    },
    display = {
      action_palette = {
        provider = "telescope",
      },
      diff = {
        enabled = true,
        word_highlights = {
          additions = true,
          deletions = true,
        },
      },
    },
    -- extensions = {
    --   mcphub = {
    --     callback = "mcphub.extensions.codecompanion",
    --     opts = {
    --       -- MCP Tools
    --       make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
    --       show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
    --       add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
    --       show_result_in_chat = true, -- Show tool results directly in chat buffer
    --       -- MCP Resources
    --       make_vars = true, -- Convert MCP resources to #variables for prompts
    --       -- MCP Prompts
    --       make_slash_commands = true, -- Add MCP prompts as /slash commands
    --     },
    --   },
    -- },
  }

  codecompanion_spinner()
  codecompanion.setup(opts)
end

return M
