-- lua/plugins/mason.lua

return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- 설치할 LSP 서버 목록
    local servers = {
      "neocmake",
      "clangd",
      "jsonls",
      "lua_ls",
      "marksman",
      "pyright",
      "vimls",
      "arduino_language_server",
    }

    -- mason 설정: UI 등 기본 설정
    require("mason").setup()

    -- mason-lspconfig 설정: mason과 nvim-lspconfig를 연결
    require("mason-lspconfig").setup({
      -- 위에 정의된 서버들이 자동으로 설치되도록 보장
      ensure_installed = servers,
    })
  end,
}
