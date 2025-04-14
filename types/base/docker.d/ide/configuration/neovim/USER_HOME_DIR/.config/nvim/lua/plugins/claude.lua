return {
  {
    "pasky/claude.vim",
    lazy = false,
    config = function()
      vim.g.claude_api_key = vim.env.ANTHROPIC_API_KEY
      vim.g.claude_map_implement = "<Leader>aii"
      vim.g.claude_map_open_chat = "<Leader>aic"
      vim.g.claude_map_send_chat_message = "<Leader>aicc"
      vim.g.claude_map_cancel_response = "<Leader>aix"
    end,
  },
}
