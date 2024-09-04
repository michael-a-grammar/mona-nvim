local notify = require("mona.notify").for_mona("nvim")()

if vim.fn.executable("rg") ~= 1 then
  notify.warn({
    message = "mona requires ripgrep, please visit https://github.com/BurntSushi/ripgrep",
  })
end
