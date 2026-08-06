---@class Config
---@field use_mason boolean
---@field ignore_entries string[]
---@field project_directories string[]

---@class PartialConfig
---@field use_mason? boolean
---@field ignore_entries? string[]
---@field project_directories? string[]

---@type Config
local M = {
  use_mason = true,
  ignore_entries = { '!conf/*', '!.env', '!.env.*', '!**/.local', '!local_config.lua'},
  project_directories = {},
}

local config_dir = vim.fn.stdpath 'config'
local local_config_path = vim.fs.joinpath(config_dir, 'local_config.lua')
local local_config_example_path = vim.fs.joinpath(config_dir, 'local_config.lua.example')

if vim.uv.fs_stat(local_config_path) == nil and vim.uv.fs_stat(local_config_example_path) then
  local example = io.open(local_config_example_path, 'r')
  if example then
    local content = example:read '*a'
    example:close()

    local local_config = io.open(local_config_path, 'w')
    if local_config then
      local_config:write(content)
      local_config:close()
    else
      vim.notify('Unable to create local_config.lua from local_config.lua.example', vim.log.levels.WARN)
    end
  end
end

local local_config_stat = vim.uv.fs_stat(local_config_path)

if local_config_stat then
  local ok, local_config = pcall(dofile, local_config_path)
  if ok and type(local_config) == 'table' then
    ---@type PartialConfig
    local overrides = local_config
    M = vim.tbl_deep_extend('force', M, overrides)
  end
end

return M
