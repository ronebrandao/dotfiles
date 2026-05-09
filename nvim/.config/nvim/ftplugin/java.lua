local jdtls = require('jdtls')

local root_dir = jdtls.setup.find_root({ 'gradlew', 'mvnw', 'pom.xml', '.git' })
if not root_dir then return end

local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name

-- java-debug-adapter bundle for DAP support (installed via Mason)
local bundles = {}
local java_debug = vim.fn.glob(
    vim.fn.stdpath('data') .. '/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar',
    true, true
)
vim.list_extend(bundles, java_debug)

jdtls.start_or_attach({
    cmd = {
        vim.fn.stdpath('data') .. '/mason/bin/jdtls',
        '-data', workspace,
    },
    root_dir = root_dir,
    settings = {
        java = {
            format = { enabled = false },  -- let conform handle formatting
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' },
            completion = {
                favoriteStaticMembers = {
                    "org.junit.Assert.*",
                    "org.mockito.Mockito.*",
                },
            },
        },
    },
    init_options = { bundles = bundles },
})
