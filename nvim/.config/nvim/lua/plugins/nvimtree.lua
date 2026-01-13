return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup()

    vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

    local function open_nvim_tree_on_startup(data)
      local directory = vim.fn.isdirectory(data.file) == 1
      if directory then
        vim.cmd.cd(data.file)
        require("nvim-tree.api").tree.open()
      end
    end

    vim.api.nvim_create_autocmd({ "VimEnter" }, {
      callback = open_nvim_tree_on_startup
    })
  end
}
