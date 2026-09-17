-- Plugin loader.
--
-- Every module in lua/plugins/ returns:
--   { specs = { "owner/repo" | vim.pack.Spec, ... }, setup = function() ... end }
--
-- All specs are gathered first and installed with ONE vim.pack.add() call,
-- then each module's setup() runs in the order listed below.
local pack = require("core.pack")

local modules = {
  "ui", -- colorscheme, icons, statusline, which-key
  "editor", -- picker, file explorer, mini.* editing helpers
  "git",
  "mason", -- installers; needed by treesitter (CLI) and lsp
  "treesitter",
  "completion", -- must precede lsp (capabilities)
  "lsp",
  "format",
  "lint",
  "debug",
}

local function report(what, err)
  vim.notify(("[plugins] %s:\n%s"):format(what, err), vim.log.levels.ERROR)
end

-- 1. Hooks must exist before the first vim.pack.add()
pack.register_hooks()

-- 2. Collect specs
local loaded, specs = {}, {}
for _, name in ipairs(modules) do
  local ok, mod = pcall(require, "plugins." .. name)
  if ok and type(mod) == "table" then
    loaded[#loaded + 1] = { name = name, mod = mod }
    vim.list_extend(specs, mod.specs or {})
  else
    report("failed to load plugins." .. name, mod)
  end
end
vim.list_extend(specs, require("lang").all().plugins)

-- 3. Install + add to runtimepath
pack.add(specs)

-- 4. Configure
for _, entry in ipairs(loaded) do
  if type(entry.mod.setup) == "function" then
    local ok, err = xpcall(entry.mod.setup, debug.traceback)
    if not ok then
      report("setup failed for plugins." .. entry.name, err)
    end
  end
end
