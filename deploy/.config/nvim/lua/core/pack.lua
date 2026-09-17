-- Thin wrapper around the built-in `vim.pack` plugin manager.
--  * accepts GitHub shorthand ("owner/repo")
--  * de-duplicates specs collected from many modules
--  * runs post-install/update build hooks via the PackChanged event
local M = {}

--- Build hooks keyed by plugin name (directory name under site/pack/core/opt).
--- Each hook receives the PackChanged event data: { kind, spec, path, active }.
M.hooks = {
  ["nvim-treesitter"] = function(data)
    if data.kind ~= "update" then
      return -- fresh installs are handled by plugins/treesitter.lua
    end
    if not data.active then
      vim.cmd.packadd("nvim-treesitter")
    end
    vim.schedule(function()
      pcall(vim.cmd, "TSUpdate")
    end)
  end,
}

--- Must run before the very first vim.pack.add() so install hooks fire.
function M.register_hooks()
  vim.api.nvim_create_autocmd("PackChanged", {
    group = vim.api.nvim_create_augroup("user_pack_hooks", { clear = true }),
    callback = function(ev)
      local data = ev.data
      local hook = M.hooks[data.spec.name]
      if hook and (data.kind == "install" or data.kind == "update") then
        local ok, err = pcall(hook, data)
        if not ok then
          vim.notify(("Build hook for %s failed:\n%s"):format(data.spec.name, err), vim.log.levels.ERROR)
        end
      end
    end,
  })
end

local function normalize(spec)
  if type(spec) == "string" then
    spec = { src = spec }
  else
    spec = vim.deepcopy(spec)
  end
  if not spec.src:match("^%a[%w+.-]*://") and not spec.src:match("^git@") then
    spec.src = "https://github.com/" .. spec.src
  end
  return spec
end

--- Install (if needed) and add all plugins to the session in a single call.
---@param specs (string|vim.pack.Spec)[]
function M.add(specs)
  local by_src, ordered = {}, {}
  for _, raw in ipairs(specs) do
    local spec = normalize(raw)
    local existing = by_src[spec.src]
    if existing then
      -- keep the first spec but fill in any fields (e.g. version) it lacks
      by_src[spec.src] = vim.tbl_extend("keep", existing, spec)
    else
      by_src[spec.src] = spec
      table.insert(ordered, spec.src)
    end
  end

  local final = vim.tbl_map(function(src)
    return by_src[src]
  end, ordered)

  -- confirm = false: install missing plugins without an interactive prompt
  vim.pack.add(final, { confirm = false })
end

return M
