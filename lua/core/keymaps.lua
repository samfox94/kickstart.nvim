-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- save file
vim.keymap.set({ 'n', 'i' }, '<C-s>', '<cmd> w <CR><Esc>', opts)

-- save file without auto-formatting
-- vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', { noremap = true, silent = true, desc = '[S]ave with [N]o formatting' })

-- quit file
vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts)

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', opts)

-- Vertical scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- Resize with arrows
vim.keymap.set('n', '<Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', opts)

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', { noremap = true, silent = true, desc = 'Close current buffer' })    -- close buffer
vim.keymap.set('n', '<leader>nb', '<cmd> enew <CR>', { noremap = true, silent = true, desc = '[N]ew empty [B]uffer' }) -- new buffer

-- Window management
vim.keymap.set('n', '<leader>pv', '<C-w>v', { noremap = true, silent = true, desc = 'Split [P]ane [V]ertically' })  -- split window vertically
vim.keymap.set('n', '<leader>ph', '<C-w>s', { noremap = true, silent = true, desc = 'Split [P]ane [H]orizonally' }) -- split window horizontally
vim.keymap.set('n', '<leader>pe', '<C-w>=', { noremap = true, silent = true, desc = 'Split [P]anes [E]qually' })    -- make split windows equal width & height
vim.keymap.set('n', '<leader>xs', ':close<CR>', opts)                                                               -- close current split window

-- Navigate between splits
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)

-- -- Tabs
-- vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts)   -- open new tab
-- vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts) -- close current tab
-- vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts)     --  go to next tab
-- vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts)     --  go to previous tab

-- Toggle line wrapping
vim.keymap.set('n', '<leader>tw', '<cmd>set wrap!<CR>', { noremap = true, silent = true, desc = '[T]oggle line [W]rap' })

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
