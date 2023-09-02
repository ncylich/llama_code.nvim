local code_llama_module = {}

function code_llama_module.greeting(name)
   return "Hello " .. name
end

LLAMA_CALL = "/Users/noahcylich/LLAMA2/llama.cpp/main -m ./models/7B/ggml-model-q4_0.bin"

local suggested_code, curr_code = nil, nil

local function get_file_type()
  return vim.api.nvim_buf_get_option(0, 'filetype')
end

local function llama_request(request)
  local cmd = LLAMA_CALL.."-p"..request
  return vim.fn.system(cmd)
end

local function update()
  if suggested_code ~= nil and curr_code ~= nil then
    vim.api.nvim_set_current_line(suggested_code)
    suggested_code, curr_code = nil, nil
  end
end

-- popup.menu caused an error: field menu is nil?
-- Try launching terminal instead of using popup?
local function create_popup()
  local popup = require('popup')

  local lines = {
    'current code: '..curr_code,
    'suggested code: '..suggested_code,
  }

  local opts = {
    title = 'Code Llama Suggestion',
    line = 10,
    -- col = 20,
    border = true
  }

  local items = {
    'Implement',
    'Disregard',
    {text = 'Option 3', code = 'update()'}
  }

  local win_id, win_opts = popup.menu(lines, opts, items)
end

local function check_response(response)
  response = string.lower(response)
  if string.find(response, 'yes') or 'y' == string.gsub(response, ' ', '') then
    return true
  end
  return false
end

local function prompt_user()
  print('Current Code: '..curr_code)
  print('Suggested Code: '..suggested_code)
  local response = vim.fn.input('Implement Suggestions? [y/N]')
  if check_response(response) then
    vim.api.nvim_set_current_line(suggested_code)
  end
  suggested_code, curr_code = nil, nil
end

function code_llama_module.llama_suggest()
  local language = get_file_type()
  curr_code = vim.api.nvim_get_current_line()
  local request = 'Help complete the following code - the file ends in "'..language..'":\n'..curr_code
  suggested_code = llama_request(request)
  prompt_user()
end

return code_llama_module
