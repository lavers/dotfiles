vim.o.completeopt = "menuone,noselect"
local lsp_servers = {
	'pyright',
	-- 'rust_analyzer',
	'clangd',
	'bashls',
	'phpactor',
	'tsserver',
	'cssls',
	'html',
	'jsonls'
}

require('nvim-treesitter.configs').setup {
	ensure_installed = {
		"bash",
		"c",
		"c_sharp",
		"cpp",
		"css",
		"graphql",
		"html",
		"java",
		"javascript",
		"json",
		"kotlin",
		"lua",
		"php",
		"python",
		"regex",
		"ruby",
		"rust",
		"toml",
		"typescript",
		"yaml"
	},
	highlight = {
		enable = true,
		--additional_vim_regex_highlighting = { 'php' }
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		}
	}
}

vim.api.nvim_command('autocmd FileType php set indentexpr=')
vim.api.nvim_command('autocmd FileType php set autoindent')
vim.api.nvim_command('autocmd FileType php set smartindent')

vim.api.nvim_set_option('foldmethod', 'expr')
vim.api.nvim_set_option('foldexpr', 'nvim_treesitter#foldexpr()')

local lspconfig = require('lspconfig')

local on_lspserver_attach = function(client, bufnr)
	local function bufmap(lhs, rhs)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', lhs, rhs, { noremap=true, silent=true })
	end
	local function bufopt(...) vim.api.nvim_buf_set_option(bufnr, ...) end
	bufopt('omnifunc', 'v:lua.vim.lsp.omnifunc')
	bufmap('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
	bufmap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
	bufmap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
	bufmap('gr', '<cmd>lua vim.lsp.buf.references()<CR>')

	bufmap('<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')

	bufmap('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
	bufmap('<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')

	bufmap('<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>')
	bufmap('<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
	bufmap('<leader>i', '<cmd>lua vim.diagnostic.open_float()<CR>')
	bufmap('<leader>ll', '<cmd>lua vim.diagnostic.setloclist()<CR>')
	bufmap('<leader>fm', '<cmd>lua vim.lsp.buf.formatting()<CR>')
	bufmap('[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
	bufmap(']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')

	--probably rarely if ever going to use these..?
	--bufmap('<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
	--bufmap('<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
	--bufmap('<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')

	require('lsp_signature').on_attach({
		bind = true,
		floating_window = false,
		hint_prefix = ">> "
	})
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

for _, lsp in ipairs(lsp_servers) do
	lspconfig[lsp].setup {
		on_attach = on_lspserver_attach,
		capabilities = capabilities,
		flags = {
			debounce_text_changes = 150,
		}
	}
end

require('rust-tools').setup({
	server = {
		on_attach = on_lspserver_attach
	},
	tools = {
		hover_actions = {
			border = "solid"
		}
	}
})

require('compe').setup {
	enabled = true;
	autocomplete = true;
	debug = false;
	min_length = 1;
	preselect = 'enable';
	throttle_time = 80;
	source_timeout = 200;
	resolve_timeout = 800;
	incomplete_delay = 400;
	max_abbr_width = 100;
	max_kind_width = 100;
	max_menu_width = 100;
	documentation = {
		border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
		winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
		max_width = 120,
		min_width = 60,
		max_height = math.floor(vim.o.lines * 0.3),
		min_height = 1,
	};

	source = {
		path = true;
		buffer = true;
		calc = true;
		nvim_lsp = true;
		nvim_lua = true;
		vsnip = true;
		ultisnips = true;
		luasnip = true;
	};
}

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
	local col = vim.fn.col('.') - 1
	return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

_G.tab_complete = function()
	if vim.fn.pumvisible() == 1 then
		return t "<C-n>"
	--elseif vim.fn['vsnip#available'](1) == 1 then
		--return t "<Plug>(vsnip-expand-or-jump)"
	elseif check_back_space() then
		return t "<Tab>"
	else
		return vim.fn['compe#complete']()
	end
end
_G.s_tab_complete = function()
	if vim.fn.pumvisible() == 1 then
		return t "<C-p>"
	-- elseif vim.fn['vsnip#jumpable'](-1) == 1 then
		--return t "<Plug>(vsnip-jump-prev)"
	else
		-- If <S-Tab> is not working in your terminal, change it to <C-h>
		return t "<S-Tab>"
	end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

local defaults = { Error = "Red", Warn = "Yellow", Info = "14", Hint = "13" }

for type, color in pairs(defaults) do
	local group = "Diagnostic" .. type
	local hl = vim.api.nvim_get_hl_by_name(group, true)
	vim.cmd("hi " .. group .. " ctermfg=" .. color)
	vim.fn.sign_define("LspDiagnosticsSign" .. type, { text = ">>", texthl = group })
end

vim.api.nvim_set_hl(0, "@variable", { ctermfg = 252 })
vim.api.nvim_set_hl(0, "@variable.builtin", { link = 'Special' })
vim.api.nvim_set_hl(0, "@type.qualifier", { link = 'Operator' })
vim.api.nvim_set_hl(0, "@exception", { link = 'Error' })
vim.api.nvim_set_hl(0, "@namespace", { link = 'Include' })
vim.api.nvim_set_hl(0, "@storageclass", { link = 'Keyword' })
vim.api.nvim_set_hl(0, "@storageclass.lifetime", { link = 'Label' })
