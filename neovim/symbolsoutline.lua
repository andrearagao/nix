Kind_filter = {
  default = {
    "Class",
    "Constructor",
    "Enum",
    "Field",
    "Function",
    "Interface",
    "Method",
    "Module",
    "Namespace",
    "Package",
    "Property",
    "Struct",
    "Trait",
  },
  markdown = false,
  help = false,
  -- you can specify a different filter for each filetype
  lua = {
    "Class",
    "Constructor",
    "Enum",
    "Field",
    "Function",
    "Interface",
    "Method",
    "Module",
    "Namespace",
    -- "Package", -- remove package since luals uses it for control flow structures
    "Property",
    "Struct",
    "Trait",
  },
}
function SymbolsOutline()
  return {
    {
      "simrat39/symbols-outline.nvim",
      keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
      cmd = "SymbolsOutline",
      opts = function()
        local defaults = require("symbols-outline.config").defaults
        local opts = {
          symbols = {},
          symbol_blacklist = {},
        }
        local filter = Kind_filter

        if type(filter) == "table" then
          filter = filter.default
          if type(filter) == "table" then
            for kind, symbol in pairs(defaults.symbols) do
              opts.symbols[kind] = {
                icon = Icons.kinds[kind] or symbol.icon,
                hl = symbol.hl,
              }
              if not vim.tbl_contains(filter, kind) then
                table.insert(opts.symbol_blacklist, kind)
              end
            end
          end
        end
        return opts
      end,
    }
  }
end
