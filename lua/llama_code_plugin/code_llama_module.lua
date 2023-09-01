local code_llama_module = {}

function code_llama_module.greeting(name)
   return "Hello " .. name
end

local base_llama_call = "/Users/noahcylich/LLAMA2/llama.cpp/main -m ./models/7B/ggml-model-q4_0.bin"

local suggested_code = nil

local function get_file_type()
  return vim.api.nvim_buf_get_option(0, 'filetype')
end

local function llama_request(request)
  local cmd = base_llama_call.."-p"..request
  return vim.fn.system(cmd)
end

local function filter(id, key, options)
  key = string.lower(key)
  if string.find(key, 'yes') or string.gsub(key, ' ', '') == 'y' then
    return 1
  else
    return 0
  end
end

local function callback(id, result)
  if result == 1 and suggested_code ~= nil then
    vim.api.nvim_set_current_line(suggested_code)
    suggested_code = nil
  end
end

-- doesn't work: needs another plugin
local function create_popup(curr_code)
  if suggested_code ~= nil then
    return vim.api.nvim_call('popup_create', ['current code: '..curr_code, 'suggested code: '..suggested_code], {'col': 1, 'padding': [1, 1, 1,], 'filter': filter, 'callback': callback})
  end
end

function code_llama_module.llama_suggest()
  local language = get_file_type()
  local curr_code = vim.api.nvim_get_current_line()
  local request = 'Help complete the following code - the file ends in "'..language..'":\n'..curr_code
  suggested_code = llama_request(request)
  return create_popup(curr_code)
end

return code_llama_module
