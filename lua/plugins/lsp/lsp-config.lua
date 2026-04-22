return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
		"williamboman/mason.nvim",
	},

	config = function()
		require("lspconfig") -- ensure all lspconfig server definitions are registered
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap

		-- keymaps on attach
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }

				opts.desc = "Organize imports"
				keymap.set({ "n", "v" }, "<leader>co", ":OrganizeImports<CR>", opts)

				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

				-- svelte: notify server when JS/TS files change
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if client and client.name == "svelte" then
					vim.api.nvim_create_autocmd("BufWritePost", {
						group = vim.api.nvim_create_augroup("SvelteLspNotify", { clear = false }),
						pattern = { "*.js", "*.ts" },
						callback = function(ctx)
							client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
						end,
					})
				end

				-- ts_ls: notify server when TS/JS files change
				if client and client.name == "ts_ls" then
					vim.api.nvim_create_autocmd("BufWritePost", {
						group = vim.api.nvim_create_augroup("TsLsNotify", { clear = false }),
						pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
						callback = function(ctx)
							client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
						end,
					})
				end
			end,
		})

		-- diagnostic signs
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end
		vim.diagnostic.config({
			virtual_text = {
				spacing = 2,
				prefix = "●",
				format = function(diagnostic)
					return string.format("%s (%s)", diagnostic.message, diagnostic.source)
				end,
			},
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})

		-- OrganizeImports command
		local function organize_imports()
			vim.lsp.buf.execute_command({
				command = "_typescript.organizeImports",
				arguments = { vim.api.nvim_buf_get_name(0) },
				title = "",
			})
		end

		local function organize_python_imports()
			local filename = vim.api.nvim_buf_get_name(0)
			if filename and filename ~= "" then
				local result = vim.fn.system("ruff check --fix " .. vim.fn.shellescape(filename))
				vim.cmd("edit!")
				if vim.v.shell_error == 0 then
					vim.notify("Fixed all auto-fixable issues with Ruff", vim.log.levels.INFO)
				else
					vim.notify("Ruff fix failed: " .. result, vim.log.levels.ERROR)
				end
			else
				vim.notify("No file to fix", vim.log.levels.WARN)
			end
		end

		vim.api.nvim_create_user_command("OrganizeImports", function()
			local ft = vim.bo.filetype
			if ft == "python" then
				organize_python_imports()
			elseif
				ft == "typescript"
				or ft == "typescriptreact"
				or ft == "javascript"
				or ft == "javascriptreact"
				or ft == "svelte"
			then
				organize_imports()
			else
				vim.notify("OrganizeImports not supported for filetype: " .. ft, vim.log.levels.WARN)
			end
		end, { desc = "Organize imports for current filetype" })

		-- global capabilities
		local capabilities = cmp_nvim_lsp.default_capabilities()
		vim.lsp.config("*", { capabilities = capabilities })

		-- per-server configs
		vim.lsp.config("pyright", {
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						diagnosticMode = "workspace",
						useLibraryCodeForTypes = true,
						autoImportCompletions = true,
					},
				},
			},
		})

		vim.lsp.config("svelte", {
			root_dir = function(bufnr, on_dir)
				local markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock", ".git" }
				local root = vim.fs.root(bufnr, markers) or vim.fn.getcwd()
				on_dir(root)
			end,
		})

		vim.lsp.config("lua_ls", {
			root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
		})

		vim.lsp.config("graphql", {
			filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
		})

		-- TODO: root_dir overrides for ts_ls, svelte are workarounds for a bug in lspconfig's
		-- grouped root_markers (nvim-0.11.3 API) not working on nvim 0.12.0-dev. Remove once fixed upstream.
		vim.lsp.config("ts_ls", {
			filetypes = { "typescriptreact", "typescript", "javascript", "javascriptreact" },
			root_dir = function(bufnr, on_dir)
				local markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock", ".git" }
				local root = vim.fs.root(bufnr, markers)
				if root then
					on_dir(root)
				end
			end,
		})

		vim.lsp.config("tailwindcss", {
			filetypes = {
				"html",
				"css",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"svelte",
			},
			settings = {
				tailwindCSS = {
					files = {
						exclude = {
							"**/.git/**",
							"**/node_modules/**",
							"**/.next/**",
							"**/dist/**",
							"**/build/**",
							"**/out/**",
							"**/.cache/**",
							"**/coverage/**",
							"**/.turbo/**",
							"**/.vercel/**",
							"**/.svelte-kit/**",
						},
					},
				},
			},
		})

		-- enable servers excluded from mason automatic_enable
		vim.lsp.enable({ "pyright", "svelte", "graphql", "ts_ls", "tailwindcss", "lua_ls" })
	end,
}
