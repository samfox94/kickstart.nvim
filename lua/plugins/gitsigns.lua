-- Git integration
return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
  opts = {
    signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
      untracked = { text = '▎' },
    },
    signs_staged = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
    },
    -- word_diff = true,
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      map('n', ']h', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gs.nav_hunk 'next'
        end
      end, '[N]ext Git change')
      map('n', '[h', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gs.nav_hunk 'prev'
        end
      end, '[P]rev Git change')
      map('n', ']H', function()
        gs.nav_hunk 'last'
      end, 'Last Git [H]unk')
      map('n', '[H', function()
        gs.nav_hunk 'first'
      end, 'First Git [H]unk')
      map({ 'n', 'v' }, '<leader>gsh', ':Gitsigns stage_hunk<CR>', '[G]it [S]tage [H]unk')
      map({ 'n', 'v' }, '<leader>grh', ':Gitsigns reset_hunk<CR>', '[G]it [R]eset [H]unk')
      map('n', '<leader>gsb', gs.stage_buffer, '[G]it [S]tage buffer')
      map('n', '<leader>guh', gs.undo_stage_hunk, '[G]it [U]ndo stage [H]unk')
      map('n', '<leader>grb', gs.reset_buffer, '[G]it [R]eset buffer')
      map('n', '<leader>gp', gs.preview_hunk_inline, '[G]it [p]review change inline')
      map('n', '<leader>gb', function()
        gs.blame_line { full = true }
      end, '[G]it [b]lame line')
      map('n', '<leader>gB', function()
        gs.blame()
      end, '[G]it [B]lame buffer')
      map('n', '<leader>gd', gs.diffthis, '[G]it [d]iff current buffer')
      -- map("n", "<leader>gD", function() gs.diffthis("~") end, "Diff this ~")
      -- map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns select hunk")
      map('n', '<leader>gc', '<cmd>Telescope git_commits<cr>', '[G]it [C]ommits')
      map('n', '<leader>gS', '<cmd>Telescope git_status<cr>', '[G]it [S]tatus')
    end,
  },
}
