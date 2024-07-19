return {
	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",
	-- {
	-- "junegunn/fzf.vim",
	-- 	dependencies = { "junegunn/fzf" },
	-- },

	{
		-- Autocompletion
		"hrsh7th/nvim-cmp",
		dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
	},

	-- "gc" to comment visual regions/lines
	{
		'echasnovski/mini.comment',
		config = function()
			require('mini.comment').setup()
		end,
	}
}

