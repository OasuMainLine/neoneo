local M = {}

--- Checks if an item exists in a table
--- @param t table
--- @param item any
function M.includes(t, item)
  for _index, value in ipairs(t) do
    if value == item then return true end
  end
  return false
end

--- Filter the items of a table given a predicate function
--- Function taken from https://stackoverflow.com/a/75012903
--- @alias Predicate fun(item: any): boolean
--- @param t table
--- @param cbk Predicate
function M.filter(t, cbk)
  local i = 1
  while i <= #t do
    if not cbk(t[i]) then
      i = i + 1
    else
      table.remove(t, i)
    end
  end
end

--- Excludes items from t using the exclusion table (exclusion_t)
--- Modifies t in place
--- @param t table
--- @param exclusion_t table
function M.exclude_from(t, exclusion_t)
  M.filter(t, function(item) return M.includes(exclusion_t, item) end)
end

return M
