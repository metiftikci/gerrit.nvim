local M = {}

M.show_changes = function(opts)
  opts = opts or {}

  if (type(opts.username) ~= 'string') then
    error('username is required')
    return
  end
  if (type(opts.credentials) ~= 'string') then
    error('credentials is required')
    return
  end
  if (type(opts.host) ~= 'string') then
    error('host is required')
    return
  end

  local command = string.format('curl -s -u %s:%s "%s/a/changes/?q=status:open%%20owner:self&o=CURRENT_REVISION"', opts.username, opts.credentials, opts.host)

  local response = vim.fn.systemlist(command)

  table.remove(response, 1)
  local data = vim.fn.json_decode(response)

  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local previewers = require "telescope.previewers"
  local conf = require("telescope.config").values
  local make_entry = require("telescope.make_entry")
  local actions = require "telescope.actions"

  local cmd_data = {}

  for _, v in ipairs(data) do
      table.insert(cmd_data, v.current_revision .. ' ' .. v.subject)
  end

  pickers.new(opts, {
    prompt_title = "Changes",
    finder = finders.new_table {
      results = cmd_data,
      entry_maker = make_entry.gen_from_git_commits(opts),
    },
    previewer = {
      previewers.git_commit_diff_to_parent.new(opts),
      previewers.git_commit_diff_to_head.new(opts),
      previewers.git_commit_diff_as_was.new(opts),
      previewers.git_commit_message.new(opts),
    },
    attach_mappings = function(_, map)
      actions.select_default:replace(actions.git_checkout)
      return true
    end,
    sorter = conf.generic_sorter(opts),
  }):find()
end

M.setup = function(opts)
  vim.api.nvim_create_user_command('Gerrit', function()
    M.show_changes(opts)
  end, {})
end

return M
