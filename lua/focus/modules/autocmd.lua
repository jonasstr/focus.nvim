local cmd = vim.api.nvim_command
local autocmd = {}

local function get_sign_column()
	local default_signcolumn = 'auto'
	if vim.opt.signcolumn:get() == 'no' then
		return default_signcolumn
	else
		return vim.opt.signcolumn:get()
	end
end

local function nvim_create_augroups(definitions)
	for group_name, definition in pairs(definitions) do
		cmd('augroup ' .. group_name)
		cmd('autocmd!')
		for _, def in ipairs(definition) do
			local command = table.concat(vim.tbl_flatten({ 'autocmd', def }), ' ')
			cmd(command)
		end
		cmd('augroup END')
	end
end

function autocmd.setup(config)
	local autocmds = {
		focus_init = {
			-- TODO: This needs a major rework in conjunctions with resize() many many edge cases
			-- Resize files with typical naming convention *.* i.e focus.lua
			{ 'BufEnter,WinEnter', '*', ':lua require"focus".resize()' },
			-- { 'BufLeave,WinLeave', '*.*', ':lua require"focus".resize()' },
			-- Resize files with no filetype
			-- { 'WinEnter', *, ':lua require"focus".resize()' },
			-- Resize startify
			-- { 'Filetype', '', ':lua require"focus".resize()' },
			{ 'Filetype', 'startify', ':lua require"focus".resize()' },
			-- So that we can resize windows such as NvimTree correctly, we run resize when we open a buffer
			-- { 'BufEnter,WinEnter', 'NvimTree,nerdtree,CHADTree,qf', ":lua require'focus'.resize()" },
		},
	}

	if config.signcolumn ~= false then
		-- Explicitly check against false, as it not being present should default to it being on
		autocmds['focus_signcolumn'] = {
			{ 'BufEnter,WinEnter', '*', 'setlocal signcolumn=' .. get_sign_column() },
			{ 'BufLeave,WinLeave', '*', 'setlocal signcolumn=no' },
		}
	end

	if config.cursorline ~= false then
		-- Explicitly check against false, as it not being present should default to it being on
		autocmds['focus_cursorline'] = {
			{ 'BufEnter,WinEnter', '*', 'setlocal cursorline' },
			{ 'BufLeave,WinLeave', '*', 'setlocal nocursorline' },
		}
	end
	if config.number ~= false then
		-- Explicitly check against false, as it not being present should default to it being on
		autocmds['number'] = {
			{ 'BufEnter,WinEnter', '*', 'set number' },
			{ 'BufLeave,WinLeave', '*', 'setlocal nonumber' },
		}
	end
	if config.relativenumber ~= false then
		-- Explicitly check against false, as it not being present should default to it being on
		autocmds['focus_relativenumber'] = {
			{ 'BufEnter,WinEnter', '*', 'set nonumber relativenumber' },
			{ 'BufLeave,WinLeave', '*', 'setlocal nonumber norelativenumber' },
		}
	end
	if config.hybridnumber ~= false then
		-- Explicitly check against false, as it not being present should default to it being on
		autocmds['focus_hybridnumber'] = {
			{ 'BufEnter,WinEnter', '*', 'set number relativenumber' },
			{ 'BufLeave,WinLeave', '*', 'setlocal nonumber norelativenumber' },
		}
	end

	nvim_create_augroups(autocmds)
end

return autocmd
