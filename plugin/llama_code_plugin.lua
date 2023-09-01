if vim.fn.has("nvim-0.7.0") == 0 then
  vim.api.nvim_err_writeln("llama_code_plugin requires at least nvim-0.7.0.1")
  return
end

-- make sure this file is loaded only once
if vim.g.loaded_llama_code_plugin == 1 then
  return
end
vim.g.loaded_llama_code_plugin = 1

-- create any global command that does not depend on user setup
-- usually it is better to define most commands/mappings in the setup function
-- Be careful to not overuse this file!
local llama_code_plugin = require("llama_code_plugin")

vim.api.nvim_create_user_command(
  "MyAwesomePluginGenericGreet",
  llama_code_plugin.generic_greet,
  {})

vim.api.nvim_create_user_command(
  "LlamaSuggest",
  llama_code_plugin.llama_suggest,
  {})

