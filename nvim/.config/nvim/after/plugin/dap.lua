local ok_dap, dap = pcall(require, 'dap')
local ok_ui, dapui = pcall(require, 'dapui')
if not ok_dap or not ok_ui then return end

dapui.setup()

-- Python: use system python3 (must have debugpy installed)
local ok_py = pcall(require, 'dap-python')
if ok_py then
    require('dap-python').setup(vim.fn.exepath('python3'))
end

-- Auto-open/close UI with debug sessions
dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end
