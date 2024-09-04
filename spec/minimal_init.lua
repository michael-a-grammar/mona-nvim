vim.opt.rtp:append(".")

for _, repository in ipairs({
  "nvim-lua/plenary.nvim",
  "nvim-telescope/telescope.nvim",
}) do
  local _, directory = string.match(repository, "(.*)/(.*)")

  directory = "/tmp/" .. directory

  local is_directory = vim.fn.isdirectory(directory) ~= 0

  if not is_directory then
    vim.fn.system({
      "git",
      "clone",
      "https://github.com/" .. repository,
      directory,
    })
  end

  vim.opt.rtp:append(directory)
end

vim.cmd("runtime plugin/plenary.vim")

_G.TEST = true

require("plenary.busted")
