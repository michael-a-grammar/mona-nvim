local M = {}

M.string = {}

function M.string.capitalise(str)
  return (str:gsub("^%l", string.upper))
end

return M
