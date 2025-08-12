function Navic()
  return {
    {
      "SmiteshP/nvim-navic",
      lazy = true,
      opts = function()
        return {
          separator = " ",
          highlight = true,
          depth_limit = 5,
          icons = Icons.kinds,
          lazy_update_context = true,
        }
      end,
    }
  }
end
