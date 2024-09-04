local M = {}

local Path = require("plenary.path")

local notify_factory = require("mona.notify").for_mona("directories")

local git_directory_name = _G.TEST and "_git" or ".git"

local function is_path_valid(path)
  return path and path["exists"] and path:exists()
end

local function get_current_working_directory()
  return Path:new(vim.fn.getcwd())
end

local function get_buffer_directory()
  local bufname_path = Path:new(vim.fn.bufname()):parent()

  if not is_path_valid(bufname_path) then
    return false
  end

  return bufname_path
end

function M.project()
  local notify = notify_factory("project")

  local current_working_directory = get_current_working_directory()

  local git_path = current_working_directory:find_upwards(git_directory_name)

  if not is_path_valid(git_path) then
    notify.warn(
      "can not find git directory, current working directory: "
        .. current_working_directory.filename
    )
    return false
  end

  local project_path = git_path:parent()
  local mix_path = Path:new(project_path.filename .. "/mix.exs")

  if not is_path_valid(mix_path) then
    notify.warn(
      "can not find mix.exs file, current working directory: "
        .. current_working_directory.filename
    )
    return false
  end

  return project_path.filename
end

function M.application()
  local notify = notify_factory("application")

  local buffer_directory = get_buffer_directory()

  if not buffer_directory then
    return notify.warn("can not find buffer directory")
  end

  local mix_path = buffer_directory:find_upwards("mix.exs")

  if not is_path_valid(mix_path) then
    notify.warn(
      "can not find mix.exs file, buffer directory: "
        .. buffer_directory.filename
    )
    return false
  end

  local application_directory = mix_path:parent().filename

  local project_directory = M.project()

  if not project_directory then
    return false
  end

  if application_directory == project_directory then
    notify.warn(
      "application directory is the project directory, buffer directory: "
        .. buffer_directory.filename
    )
    return false
  end

  return application_directory
end

function M.buffer()
  local notify = notify_factory("buffer")

  local buffer_directory = get_buffer_directory()

  if not buffer_directory then
    notify.warn("can not find buffer directory")
    return false
  end

  return buffer_directory.filename
end

return M
