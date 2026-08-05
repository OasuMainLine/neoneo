local M = {}

---@param bufnr integer
---@return string
local function start_path(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == '' then return vim.uv.cwd() end

  local stat = vim.uv.fs_stat(path)
  if stat and stat.type == 'file' then return vim.fs.dirname(path) end

  return path
end

---@param bufnr integer
---@param names string[]
---@return string?
local function find_upward(bufnr, names) return vim.fs.find(names, { path = start_path(bufnr), upward = true })[1] end

---@param path string?
---@return string?
local function read_file(path)
  if not path then return nil end

  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then return nil end

  return table.concat(lines, '\n')
end

---@param bufnr integer
---@param names string[]
---@return boolean
local function has_any_file(bufnr, names) return find_upward(bufnr, names) ~= nil end

---@param text string
---@param package string
---@return boolean
local function requirements_include_package(text, package)
  local normalized_package = package:lower()

  for line in text:gmatch '[^\r\n]+' do
    local normalized = line:gsub('#.*$', ''):lower():gsub('%s+', '')
    if normalized:find('^' .. vim.pesc(normalized_package)) then
      local rest = normalized:sub(#normalized_package + 1)

      if rest:sub(1, 1) == '[' then
        local extras_end = rest:find(']', 1, true)
        if extras_end then rest = rest:sub(extras_end + 1) end
      end

      if rest == '' or rest:match '^[<>=!~@;]' then return true end
    end
  end

  return false
end

---@param bufnr integer
---@param package string
---@return boolean
local function python_package_is_declared(bufnr, package)
  local requirement_path = find_upward(bufnr, {
    'requirements.txt',
    'requirements-dev.txt',
    'requirements-test.txt',
    'requirements-lint.txt',
  })

  if requirements_include_package(read_file(requirement_path) or '', package) then return true end

  local pyproject = read_file(find_upward(bufnr, { 'pyproject.toml' }))
  if not pyproject then return false end

  local normalized_package = package:lower()
  local escaped_package = vim.pesc(normalized_package)

  for line in pyproject:gmatch '[^\r\n]+' do
    local normalized = line:gsub('#.*$', ''):lower()
    if normalized:match('^%s*%[tool%.' .. escaped_package .. '%]%s*$') then return true end
    if normalized:match('^%s*' .. escaped_package .. '%s*=') then return true end

    for dependency in normalized:gmatch '["\']([^"\']+)["\']' do
      if requirements_include_package(dependency, normalized_package) then return true end
    end
  end

  return false
end

local installed_checks = {
  ruff = function(bufnr) return has_any_file(bufnr, { '.ruff.toml', 'ruff.toml', '.ruff_cache' }) or python_package_is_declared(bufnr, 'ruff') end,
}

---@param bufnr integer
---@param tool string
---@return boolean
function M.installed(bufnr, tool)
  local check = installed_checks[tool]
  if not check then return false end

  return check(bufnr)
end

return M
