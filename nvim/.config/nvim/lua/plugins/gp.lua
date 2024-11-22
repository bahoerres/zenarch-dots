return {
  "robitx/gp.nvim",
  config = function()
    -- https://github.com/Robitx/gp.nvim/blob/main/lua/gp/config.lua
    local default_config = require("gp/config")

    local chatgpt4o = vim.tbl_filter(function(agent)
      return agent.name == "ChatGPT4o"
    end, default_config.agents)[1] or nil
    if not chatgpt4o then
      print("ChatGPT4o agent not found")
      return
    end

    local codegpt4o = vim.tbl_filter(function(agent)
      return agent.name == "CodeGPT4o"
    end, default_config.agents)[1] or nil
    if not codegpt4o then
      print("CodeGPT4o agent not found")
      return
    end

    local oai_key = vim.fn.system('pass show openai/api'):gsub('\n', '')
    local ant_key = vim.fn.system('pass show anthropic/api'):gsub('\n', '')

    if oai_key == '' or ant_key == '' then
      print("Failed to read API keys from pass")
      return
    end
    local config = {
      providers = {
        openai = {
          endpoint = "https://api.openai.com/v1/chat/completions",
          secret = oai_key,
        },
        anthropic = {
          endpoint = "https://api.anthropic.com/v1/messages",
          secret = ant_key,
        },
      },
      agents = {
        -- Disable unwanted models
        {
          name = "ChatClaude-3-Haiku",
          disable = true,
        },
        {
          name = "CodeClaude-3-Haiku",
          disable = true,
        },
      },
      chat_topic_gen_model = "gpt-4o-mini",
      chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g><CR>" },
      -- chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>d" },
      -- chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>s" },
      -- chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>c" },
      chat_confirm_delete = false,
    }

    require("gp").setup(config)

    local function opts(desc)
      return {
        noremap = true,
        silent = true,
        nowait = true,
        desc = "GP " .. desc,
      }
    end

    -- Chat commands
    vim.keymap.set({ "n", "i" }, "<C-g>c", "<cmd>GpChatNew<cr>", opts("New Chat"))
    vim.keymap.set({ "n", "i" }, "<C-g>t", "<cmd>GpChatToggle<cr>", opts("Toggle Chat"))
    vim.keymap.set({ "n", "i" }, "<C-g><C-g>", "<cmd>GpChatToggle<cr>", opts("Toggle Chat"))
    vim.keymap.set({ "n", "i" }, "<C-g>f", "<cmd>GpChatFinder<cr>", opts("Chat Finder"))

    vim.keymap.set("v", "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", opts("Visual Chat New"))
    vim.keymap.set("v", "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", opts("Visual Chat Paste"))
    vim.keymap.set("v", "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", opts("Visual Toggle Chat"))

    vim.keymap.set({ "n", "i" }, "<C-g><C-x>", "<cmd>GpChatNew split<cr>", opts("New Chat split"))
    vim.keymap.set({ "n", "i" }, "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", opts("New Chat vsplit"))
    vim.keymap.set({ "n", "i" }, "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", opts("New Chat tabnew"))

    vim.keymap.set("v", "<C-g><C-x>", ":<C-u>'<,'>GpChatNew split<cr>", opts("Visual Chat New split"))
    vim.keymap.set("v", "<C-g><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", opts("Visual Chat New vsplit"))
    vim.keymap.set("v", "<C-g><C-t>", ":<C-u>'<,'>GpChatNew tabnew<cr>", opts("Visual Chat New tabnew"))

    -- Prompt commands
    vim.keymap.set({ "n", "i" }, "<C-g>r", "<cmd>GpRewrite<cr>", opts("Inline Rewrite"))
    vim.keymap.set({ "n", "i" }, "<C-g>a", "<cmd>GpAppend<cr>", opts("Append (after)"))
    vim.keymap.set({ "n", "i" }, "<C-g>b", "<cmd>GpPrepend<cr>", opts("Prepend (before)"))

    vim.keymap.set("v", "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", opts("Visual Rewrite"))
    vim.keymap.set("v", "<C-g>a", ":<C-u>'<,'>GpAppend<cr>", opts("Visual Append (after)"))
    vim.keymap.set("v", "<C-g>b", ":<C-u>'<,'>GpPrepend<cr>", opts("Visual Prepend (before)"))
    vim.keymap.set("v", "<C-g>i", ":<C-u>'<,'>GpImplement<cr>", opts("Implement selection"))

    vim.keymap.set({ "n", "i" }, "<C-g>gp", "<cmd>GpPopup<cr>", opts("Popup"))
    vim.keymap.set({ "n", "i" }, "<C-g>ge", "<cmd>GpEnew<cr>", opts("GpEnew"))
    vim.keymap.set({ "n", "i" }, "<C-g>gn", "<cmd>GpNew<cr>", opts("GpNew"))
    vim.keymap.set({ "n", "i" }, "<C-g>gv", "<cmd>GpVnew<cr>", opts("GpVnew"))
    vim.keymap.set({ "n", "i" }, "<C-g>gt", "<cmd>GpTabnew<cr>", opts("GpTabnew"))

    vim.keymap.set("v", "<C-g>gp", ":<C-u>'<,'>GpPopup<cr>", opts("Visual Popup"))
    vim.keymap.set("v", "<C-g>ge", ":<C-u>'<,'>GpEnew<cr>", opts("Visual GpEnew"))
    vim.keymap.set("v", "<C-g>gn", ":<C-u>'<,'>GpNew<cr>", opts("Visual GpNew"))
    vim.keymap.set("v", "<C-g>gv", ":<C-u>'<,'>GpVnew<cr>", opts("Visual GpVnew"))
    vim.keymap.set("v", "<C-g>gt", ":<C-u>'<,'>GpTabnew<cr>", opts("Visual GpTabnew"))

    vim.keymap.set({ "n", "i" }, "<C-g>x", "<cmd>GpContext<cr>", opts("Toggle Context"))
    vim.keymap.set("v", "<C-g>x", ":<C-u>'<,'>GpContext<cr>", opts("Visual Toggle Context"))

    vim.keymap.set({ "n", "i", "v", "x" }, "<C-g>s", "<cmd>GpStop<cr>", opts("Stop"))
    vim.keymap.set({ "n", "i", "v", "x" }, "<C-g>n", "<cmd>GpNextAgent<cr>", opts("Next Agent"))

    -- Optional Whisper commands with prefix <C-g>w
    vim.keymap.set({ "n", "i" }, "<C-g>ww", "<cmd>GpWhisper<cr>", opts("Whisper"))
    vim.keymap.set("v", "<C-g>ww", ":<C-u>'<,'>GpWhisper<cr>", opts("Visual Whisper"))

    vim.keymap.set({ "n", "i" }, "<C-g>wr", "<cmd>GpWhisperRewrite<cr>", opts("Whisper Inline Rewrite"))
    vim.keymap.set({ "n", "i" }, "<C-g>wa", "<cmd>GpWhisperAppend<cr>", opts("Whisper Append (after)"))
    vim.keymap.set({ "n", "i" }, "<C-g>wb", "<cmd>GpWhisperPrepend<cr>", opts("Whisper Prepend (before) "))

    vim.keymap.set("v", "<C-g>wr", ":<C-u>'<,'>GpWhisperRewrite<cr>", opts("Visual Whisper Rewrite"))
    vim.keymap.set("v", "<C-g>wa", ":<C-u>'<,'>GpWhisperAppend<cr>", opts("Visual Whisper Append (after)"))
    vim.keymap.set("v", "<C-g>wb", ":<C-u>'<,'>GpWhisperPrepend<cr>", opts("Visual Whisper Prepend (before)"))

    vim.keymap.set({ "n", "i" }, "<C-g>wp", "<cmd>GpWhisperPopup<cr>", opts("Whisper Popup"))
    vim.keymap.set({ "n", "i" }, "<C-g>we", "<cmd>GpWhisperEnew<cr>", opts("Whisper Enew"))
    vim.keymap.set({ "n", "i" }, "<C-g>wn", "<cmd>GpWhisperNew<cr>", opts("Whisper New"))
    vim.keymap.set({ "n", "i" }, "<C-g>wv", "<cmd>GpWhisperVnew<cr>", opts("Whisper Vnew"))
    vim.keymap.set({ "n", "i" }, "<C-g>wt", "<cmd>GpWhisperTabnew<cr>", opts("Whisper Tabnew"))

    vim.keymap.set("v", "<C-g>wp", ":<C-u>'<,'>GpWhisperPopup<cr>", opts("Visual Whisper Popup"))
    vim.keymap.set("v", "<C-g>we", ":<C-u>'<,'>GpWhisperEnew<cr>", opts("Visual Whisper Enew"))
    vim.keymap.set("v", "<C-g>wn", ":<C-u>'<,'>GpWhisperNew<cr>", opts("Visual Whisper New"))
    vim.keymap.set("v", "<C-g>wv", ":<C-u>'<,'>GpWhisperVnew<cr>", opts("Visual Whisper Vnew"))
    vim.keymap.set("v", "<C-g>wt", ":<C-u>'<,'>GpWhisperTabnew<cr>", opts("Visual Whisper Tabnew"))
  end,
}
