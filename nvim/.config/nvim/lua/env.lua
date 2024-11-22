local M = {}

function M.read_file(file_path)
  local env_file = io.open(vim.fn.expand(file_path), "r")
  local env_table = {}

  if not env_file then
    print("Failed to open file: " .. file_path)
    return nil
  end

  for line in env_file:lines() do
    local key, value = line:match("^%s*(%S+)%s*=%s*(.-)%s*$")

    if key and value then
      env_table[key] = value
    end
  end

  env_file:close()
  return env_table
end

return M
