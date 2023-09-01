local code_llama_module = {}

function code_llama_module.greeting(name)
   return "Hello " .. name
end

local base_llama_call = "/Users/noahcylich/LLAMA2/llama.cpp/main -m ./models/7B/ggml-model-q4_0.bin"

local function get_file_type()
  return vim.api.nvim_buf_get_option(0, 'filetype')
end

local function llama_request(request)
  local cmd = base_llama_call.."-p"..request
  return vim.fn.system(cmd)
end

function code_llama_module.llama_suggest()
  local language = get_file_type()
  local curr_code = vim.api.nvim_get_current_line()
  local request = 'Help complete the following code - the file ends in "'..language..'":\n'..curr_code
  return llama_request(request)
end

return code_llama_module
