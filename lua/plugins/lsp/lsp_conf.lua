return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "onsails/lspkind-nvim",
    "mfussenegger/nvim-jdtls",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },

  config = function()
    local nvim_lsp = require('lspconfig')
    local manson = require('mason')
    local manson_lsp = require('mason-lspconfig')

    -- Mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

      -- Mappings.
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

      vim.cmd [[augroup Format]]
      vim.cmd [[autocmd! * <buffer>]]
      vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
      vim.cmd [[augroup END]]
    end

    local lsp_flags = {
      -- This is the default in Nvim 0.7+
      debounce_text_changes = 150,
    }

    local servers = {
      'pyright',
      'tsserver',
      'lua_ls',
      'clangd',
      'emmet_ls',
      'lemminx',
      'tailwindcss',
      'kotlin_language_server',
      'jdtls'
    }

    manson.setup()
    manson_lsp.setup({ ensure_installed = servers })
    nvim_lsp.tailwindcss.setup {}
    nvim_lsp.kotlin_language_server.setup {}


    for _, lsp in ipairs(servers) do
      nvim_lsp[lsp].setup {
        on_attach = on_attach,
        flags = lsp_flags,
      }
    end

    local signs = {
      { name = "DiagnosticSignError", text = "" },
      { name = "DiagnosticSignWarn", text = "" },
      { name = "DiagnosticSignHint", text = "󰌵" },
      { name = "DiagnosticSignInfo", text = "" },
    }


    for _, sign in ipairs(signs) do
      vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    local config = {
      virtual_text = false,
      signs = {
        active = signs,
      },
      update_in_insert = true,
      underline = true,
      severity_sort = false,
      float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    }

    vim.diagnostic.config(config)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = "rounded",
    })
  end
}
