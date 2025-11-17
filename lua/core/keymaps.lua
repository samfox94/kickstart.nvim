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

local function tmux_pane_exists(pane_id)
  if not pane_id or pane_id == '' then
    return false
  end
  local panes = vim.fn.systemlist "tmux list-panes -F '#{pane_id}' 2>/dev/null"
  for _, p in ipairs(panes) do
    if p == pane_id then
      return true
    end
  end
  return false
end

local function tmux_pane_command(pane_id)
  if not tmux_pane_exists(pane_id) then
    return nil
  end
  return vim.fn.system('tmux display-message -p -t ' .. pane_id .. " '#{pane_current_command}'"):gsub('%s+$', '')
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.keymap.set({ 'n', 'i', 'v' }, '<F5>', function()
      -- To return to Normal mode from Insert or Select mode using <C-c>
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, false, true), 'n', true)
      vim.cmd 'w'
      local file = vim.fn.expand '%:p'

      -- Detect venv used by Neovim
      local venv = vim.fn.getenv 'VIRTUAL_ENV' or ''
      local activate = ''
      if venv ~= '' then
        activate = "source '" .. venv .. "/bin/activate'; "
      end

      local pane_id = vim.g.python_run_pane_id

      if not tmux_pane_exists(pane_id) then
        ----------------------------------------------------------
        -- First time: create pane, load zsh, activate venv, run script
        ----------------------------------------------------------
        local cmd = "tmux split-window -v -P -F '#{pane_id}' " ..
        '"zsh -lc \'' ..
        activate ..
        'python3 ' .. file .. '; exec zsh -l\'"'                                                                                        -- First time: create pane, load zsh, activate venv, run script
        ----------------------------------------------------------
        local cmd = "tmux split-window -v -P -F '#{pane_id}' " ..
        '"zsh -lc \'' .. activate .. 'python3 ' .. file .. '; exec zsh -l\'"'

        local new_id = vim.fn.system(cmd):gsub('%s+$', '')
        vim.g.python_run_pane_id = new_id
        return
      end

      ----------------------------------------------------------
      -- Pane exists: if python is running, stop it
      ----------------------------------------------------------
      local running_cmd = tmux_pane_command(pane_id)
      if running_cmd == 'python' or running_cmd == 'python3' or running_cmd:match '^python' then
        vim.fn.system('tmux send-keys -t ' .. pane_id .. ' C-c')
      end

      ----------------------------------------------------------
      -- Re-run script with venv
      ----------------------------------------------------------
      vim.fn.system('tmux send-keys -t ' .. pane_id .. " '" .. activate .. 'python3 ' .. file .. "' C-m")
    end, { buffer = true, silent = true })
  end,
})
