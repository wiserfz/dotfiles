local avante = require("avante")
-- local mcp = require("mcphub")

local M = {}

function M.setup()
  local base_url = os.getenv("AI_GATEWAY_BASE_URL")
  local ai_auth_token = os.getenv("AI_AUTH_TOKEN")
  local claude_code_oauth_token = os.getenv("CLAUDE_CODE_TOKEN")

  ---@module 'avante'
  ---@type avante.Config
  local opts = {
    windows = {
      position = "right",
      width = 33,
      input = {
        prefix = "󱜸",
        height = 10, -- Height of the input window in vertical layout
      },
      ask = {
        focus_on_apply = "theirs",
      },
    },
    highlights = {
      diff = {
        current = "GitSignsDelete",
        incoming = "GitSignsAdd",
      },
    },
    spinner = {
      -- Spinner characters for the 'generating' state
      -- stylua: ignore
      generating = { "·", "·", "✢", "✢", "✳", "✳", "✲", "✲", "✻", "✻", "✽", "✽", "✽" },
      thinking = { "🤯", "🤔" }, -- Spinner characters for the 'thinking' state
    },
    repo_map = {
      ignore_patterns = {
        "%.git",
        "%.worktree",
        "__pycache__",
        "NvimTree_1",
        ".cache",
        "node_modules",
        "_build",
        "target",
      }, -- ignore files matching these
    },
    selector = {
      exclude_auto_select = { "NvimTree" },
      provider = "telescope",
    },
    file_selector = {
      provider = "telescope",
      -- Options override for custom providers
      provider_opts = {
        get_filepaths = function(params)
          local cwd = params.cwd ---@type string
          local selected_filepaths = params.selected_filepaths ---@type string[]
          local cmd = string.format(
            "fd --base-directory '%s' --hidden --exclude .git/",
            vim.fn.fnameescape(cwd)
          )
          local output = vim.fn.system(cmd)
          local filepaths = vim.split(output, "\n", { trimempty = true })
          return vim
            .iter(filepaths)
            :filter(function(filepath)
              return not vim.tbl_contains(selected_filepaths, filepath)
            end)
            :totable()
        end,
      },
    },
    instructions_file = "avante.md",
    provider = "claude-code",
    providers = {
      ---@type AvanteSupportedProvider
      openai = {
        endpoint = base_url .. "/openai/v1",
        model = "gpt-5.5",
        proxy = "http://127.0.0.1:10800",
        timeout = 60000,
        support_previous_response_id = true,
        use_response_api = true,
        extra_request_body = {
          reasoning = {
            effort = "high", -- Converted from reasoning_effort
          },
          max_output_tokens = 102400,
          background = true,
        },
      },
    },
    acp_providers = {
      ["claude-code"] = {
        command = "npx",
        args = { "@agentclientprotocol/claude-agent-acp" },
        env = {
          -- NOTE: for anthropic office endpoint
          CLAUDE_CODE_OAUTH_TOKEN = claude_code_oauth_token,
          -- NOTE: for AI gateway
          -- ANTHROPIC_AUTH_TOKEN = ai_auth_token,
          -- ANTHROPIC_CUSTOM_HEADERS = "api-key: " .. ai_auth_token,
          -- ANTHROPIC_BASE_URL = base_url,
        },
      },
      ["codex"] = {
        command = "codex-acp",
        env = {
          HTTP_PROXY = "http://127.0.0.1:10800",
          AI_AUTH_TOKEN = ai_auth_token,
        },
      },
    },
    behaviour = {
      auto_suggestions = false,
      allow_access_to_git_ignored_files = true,
      acp_follow_agent_locations = false,
    },
    hints = { enabled = true },
    -- disabled_tools = {
    --   "bash",
    --   "create_dir",
    --   "create_file",
    --   "create",
    --   "delete_dir",
    --   "delete_file",
    --   "edit_file",
    --   "insert",
    --   "list_files",
    --   "read_file",
    --   "rename_dir",
    --   "rename_file",
    --   "replace_in_file",
    --   "search_files",
    --   "str_replace",
    --   "undo_edit",
    --   "view",
    --   "write_to_file",
    --   "ls",
    -- },
    -- system_prompt as function ensures LLM always has latest MCP server state
    -- This is evaluated for every message, even in existing chats
    -- system_prompt = function()
    --   local hub = mcp.get_hub_instance()
    --   return hub and hub:get_active_servers_prompt() or ""
    -- end,
    -- -- Using function prevents requiring mcphub before it's loaded
    -- custom_tools = function()
    --   return {
    --     require("mcphub.extensions.avante").mcp_tool(),
    --   }
    -- end,
  }

  avante.setup(opts)
end

return M
