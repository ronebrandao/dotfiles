local ok_dap, dap = pcall(require, 'dap')
local ok_ui, dapui = pcall(require, 'dapui')
if not ok_dap or not ok_ui then return end

-- Auto-install debug adapters via Mason. No `handlers` key is passed, so
-- mason-nvim-dap only manages installation and leaves adapter configuration
-- to the explicit setup below (e.g. dap-python).
local ok_mdap, mason_dap = pcall(require, 'mason-nvim-dap')
if ok_mdap then
    mason_dap.setup({
        ensure_installed = { "python" }, -- installs debugpy
        automatic_installation = true,
    })
end

dapui.setup()

-- Python: prefer the dedicated debugpy venv created by install.sh (PEP 668
-- distros block installing debugpy into the system interpreter). Fall back to
-- system python3 if the venv isn't present.
local ok_py = pcall(require, 'dap-python')
if ok_py then
    local venv_python = vim.fn.stdpath('data') .. '/debugpy-venv/bin/python'
    local python = vim.fn.executable(venv_python) == 1 and venv_python or vim.fn.exepath('python3')
    require('dap-python').setup(python)
end

-- Auto-open/close UI with debug sessions
dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end
