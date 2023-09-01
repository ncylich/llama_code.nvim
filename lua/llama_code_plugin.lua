local code_llama_module = require("code_llama_plugin.code_llama_module")

local code_llama_plugin = {}

local function with_defaults(options)
   return {
      name = options.name or "John Doe"
   }
end

-- This function is supposed to be called explicitly by users to configure this
-- plugin
function code_llama_plugin.setup(options)
   -- avoid setting global values outside of this function. Global state
   -- mutations are hard to debug and test, so having them in a single
   -- function/module makes it easier to reason about all possible changes
   code_llama_plugin.options = with_defaults(options)

   -- do here any startup your plugin needs, like creating commands and
   -- mappings that depend on values passed in options
   vim.api.nvim_create_user_command("MyAwesomePluginGreet", code_llama_plugin.greet, {})
end

function code_llama_plugin.is_configured()
   return code_llama_plugin.options ~= nil
end

-- This is a function that will be used outside this plugin code.
-- Think of it as a public API
function code_llama_plugin.greet()
   if not code_llama_plugin.is_configured() then
      return
   end

   -- try to keep all the heavy logic on pure functions/modules that do not
   -- depend on Neovim APIs. This makes them easy to test
   local greeting = code_llama_module.greeting(code_llama_plugin.options.name)
   print(greeting)
end

-- Another function that belongs to the public API. This one does not depend on
-- user configuration
function code_llama_plugin.generic_greet()
   print("Hello, unnamed friend!")
end

code_llama_plugin.options = nil
return code_llama_plugin
