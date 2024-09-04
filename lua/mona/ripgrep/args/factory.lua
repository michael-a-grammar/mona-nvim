local M = {}

local function insert_arg(arg, args, exclude_prefix)
  local prefix = (exclude_prefix and "") or "--"

  table.insert(args, prefix .. arg)
end

local function insert_if(condition, arg, args, exclude_prefix)
  if condition then
    insert_arg(arg, args, exclude_prefix)
  end
end

local function insert_arg_with_value(arg, args, opts)
  local key = string.gsub(arg, "-", "_")

  local arg_value = opts[key]

  insert_if(arg_value, arg, args, false)
  insert_if(arg_value, arg_value, args, true)
end

function M.default(opts)
  local args = {}

  for _, arg in ipairs({
    "case-sensitive",
    "trim",
    "vimgrep",
    "with-filename",
    "word-regexp",
  }) do
    insert_arg(arg, args)
  end

  for _, arg in ipairs({ "glob", "replace", "regexp" }) do
    insert_arg_with_value(arg, args, opts)
  end

  insert_arg(opts.directory, args, true)

  return args
end

return M
