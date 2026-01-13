return {
  "lervag/vimtex",
  init = function()
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_quickfix_mode = 0

    -- Enable full math syntax highlighting
    vim.g.vimtex_syntax_enabled = 1
    vim.g.vimtex_syntax_math_enabled = 1
    vim.g.vimtex_syntax_math_strict = 1
    vim.g.vimtex_syntax_math_delimiter = 1
    vim.g.vimtex_syntax_math_delimiter_strict = 1

    -- Automatically open PDF in Zathura when compiling
    vim.g.vimtex_view_automatic = 1

    -- Optional: compile continuously when pressing \ll
    vim.g.vimtex_compiler_latexmk = {
      build_dir = 'build',
      options = { '-pdf', '-interaction=nonstopmode', '-synctex=1' },
    }

    -- Inverse search (Ctrl+Click in Zathura jumps back to Neovim)
    vim.g.vimtex_compiler_progname = 'nvr'
    vim.g.vimtex_view_zathura_options = '-x "nvr --remote-silent +%{line} %{input}"'
  end,
}
