# Neo-tree.nvim

Neo-tree is a Neovim plugin to browse the file system and other tree like
structures in whatever style suits you, including sidebars, floating windows,
netrw split style, or all of them at once!

This screenshot shows Neo-tree opened in the traditional sidebar layout:

![Neo-tree file system
sidebar](https://github.com/nvim-neo-tree/resources/blob/main/images/Neo-tree-with-right-aligned-symbols.png)

<details>
  <summary>
    Neo-tree filesystem screenshot, Netrw Style
  </summary>

The below screenshot shows Neo-tree opened "netrw style" (`:Neotree
position=current`). When opened in this way, there is more room so the extra
detail columns can be shown. This screenshot also shows how the contents can be
sorted on any column. In this example, we are sorted on "Size" descending:

![Neo-tree file system
details](https://github.com/nvim-neo-tree/resources/blob/main/images/Neo-tree-with-file-details-and-sort.png)

</details>

### Breaking Changes BAD :bomb: :imp:

The biggest and most important feature of Neo-tree is that we will never
knowingly push a breaking change and interrupt your day. Bugs happen, but
breaking changes can always be avoided. When breaking changes are needed, there
will be a new branch that you can opt into, when it is a good time for you.

See [What is a Breaking Change?](#what-is-a-breaking-change) for details.

See [Changelog
3.0](https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Changelog#30) for
breaking changes and deprecations in 3.0.

### User Experience GOOD :slightly_smiling_face: :thumbsup:

Aside from being polite about breaking changes, Neo-tree is also focused on the
little details of user experience. Everything should work exactly as you would
expect a sidebar to work without all of the glitchy behavior that is normally
accepted in (neo)vim sidebars. I can't stand glitchy behavior, and neither
should you!

- Neo-tree won't let other buffers take over its window.
- Neo-tree won't leave its window scrolled to the last line when there is plenty
of room to display the whole tree.
- Neo-tree does not need to be manually refreshed (set
`use_libuv_file_watcher=true`)
- Neo-tree can intelligently follow the current file (set
`follow_current_file.enabled=true`)
- Neo-tree is thoughtful about maintaining or setting focus on the right node
- Neo-tree windows in different tabs are completely separate
- `respect_gitignore` actually works!

> [!NOTE]
> Neo-tree is meant to be smooth, efficient, stable, and intuitive. If you find
> anything janky, slow, broken, or unintuitive, please open an issue so we can
> fix it.

## Installation

This plugin relies upon these two excellent library plugins:

- [MunifTanjim/nui.nvim](https://github.com/MunifTanjim/nui.nvim) for all UI
components, including the tree!
- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim) for backend
utilities, such as scanning the filesystem.

There are also some optional plugins that work with Neo-tree:

- [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) for file icons.
- [antosha417/nvim-lsp-file-operations](https://github.com/antosha417/nvim-lsp-file-operations) for LSP-enhanced renames/etc.
- [folke/snacks.nvim](https://github.com/folke/snacks.nvim) for image previews, see Preview Mode section.
  - [snacks.rename](https://github.com/folke/snacks.nvim/blob/main/docs/rename.md#neo-treenvim) can also work with
  Neo-tree
- [3rd/image.nvim](https://github.com/3rd/image.nvim) for image previews.
  - If both snacks.nvim and image.nvim are installed. Neo-tree currently will
  try to preview with snacks.nvim first, then try image.nvim.
- [s1n7ax/nvim-window-picker](https://github.com/s1n7ax/nvim-window-picker) for `_with_window_picker` keymaps.


### mini.deps example:

```lua
local add = MiniDeps.add

add({
  source = 'nvim-neo-tree/neo-tree.nvim',
  checkout = '3.x',
  depends = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons", -- optional, but recommended
  }
})
```

### lazy.nvim example:

```lua
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
  }
}
```

<details>
  <summary>
    lazy.nvim example with all optional plugins:
  </summary>

```lua
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim", -- makes sure that this loads after Neo-tree.
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
  {
    "s1n7ax/nvim-window-picker",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { "neo-tree", "neo-tree-popup", "notify" },
            -- if the buffer type is one of following, the window will be ignored
            buftype = { "terminal", "quickfix" },
          },
        },
      })
    end,
  },
}
```

</details>

<details>
  <summary>
    Packer.nvim example:
  </summary>

```lua
use({
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  requires = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons", -- optional, but recommended
  }
})
```

</details>

<details>
  <summary>
    vim.pack example (Neovim v0.12, still in development at time of writing):
  </summary>

```lua
vim.pack.add({
  {
    src = 'https://github.com/nvim-neo-tree/neo-tree.nvim',
    version = vim.version.range('3')
  },
  -- dependencies
  "nvim-lua/plenary.nvim",
  "MunifTanjim/nui.nvim",
  -- optional, but recommended
  "nvim-tree/nvim-web-devicons",
})
```

</details>

### Manual installation via `:h packages`

See [doc/install.sh](doc/install.sh) and [doc/install.ps1](doc/install.ps1) for
POSIX/Windows respectively.

## Post-install: Try it out!

Try `:Neotree` to open Neo-tree as a sidebar, and press `?` while in Neo-tree to
open the keyboard help.

> [!TIP]
> You can `:checkhealth neo-tree` to ensure you have all the required
> dependencies. It can also check that your config table looks correct. This is
> still in its early stages, so please file issues if you'd like to see more
> checks added or a check isn't working properly.

## Configuration

```lua
require('neo-tree').setup({
  -- options go here
})
```

<details>
  <summary>
    💤 lazy.nvim/Neovim distro users:
  </summary>

The table passed into `setup()` has a type of `neotree.Config`. If you're on a
distro using lazy.nvim (e.g. LazyVim) or you just like the syntax, you might
want to consider using lazy.nvim's `opts` instead:

```lua
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons", -- optional, but recommended
  },
  lazy = false, -- neo-tree will lazily load itself
  ---@module 'neo-tree'
  ---@type neotree.Config
  opts = {
    -- options go here
  }
}
```

</details>

> [!NOTE]
> You do not need to call `setup()` for Neo-tree and its commands to work. `setup()` is only for configuration.

<details>
  <summary>
    Example configuration featuring many interesting settings:
  </summary>

```lua
vim.keymap.set("n", "<leader>e", "<Cmd>Neotree<CR>")
require("neo-tree").setup({
  close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
  popup_border_style = "NC", -- or "" to use 'winborder' on Neovim v0.11+
  enable_git_status = true,
  enable_diagnostics = true,
  open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
  open_files_using_relative_paths = false,
  sort_case_insensitive = false, -- used when sorting files and directories in the tree
  sort_function = nil, -- use a custom function for sorting files and directories in the tree
  -- sort_function = function (a,b)
  --       if a.type == b.type then
  --           return a.path > b.path
  --       else
  --           return a.type > b.type
  --       end
  --   end , -- this sorts files and directories descendantly
  default_component_configs = {
    container = {
      enable_character_fade = true,
    },
    indent = {
      indent_size = 2,
      padding = 1, -- extra padding on left hand side
      -- indent guides
      with_markers = true,
      indent_marker = "│",
      last_indent_marker = "└",
      highlight = "NeoTreeIndentMarker",
      -- expander config, needed for nesting files
      with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
    icon = {
      folder_closed = "",
      folder_open = "",
      folder_empty = "󰜌",
      provider = function(icon, node, state) -- default icon provider utilizes nvim-web-devicons if available
        if node.type == "file" or node.type == "terminal" then
          local success, web_devicons = pcall(require, "nvim-web-devicons")
          local name = node.type == "terminal" and "terminal" or node.name
          if success then
            local devicon, hl = web_devicons.get_icon(name)
            icon.text = devicon or icon.text
            icon.highlight = hl or icon.highlight
          end
        end
      end,
      -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
      -- then these will never be used.
      default = "*",
      highlight = "NeoTreeFileIcon",
    },
    modified = {
      symbol = "[+]",
      highlight = "NeoTreeModified",
    },
    name = {
      trailing_slash = false,
      use_git_status_colors = true,
      highlight = "NeoTreeFileName",
    },
    git_status = {
      symbols = {
        -- Change type
        added = "", -- or "✚"
        modified = "", -- or ""
        deleted = "✖", -- this can only be used in the git_status source
        renamed = "󰁕", -- this can only be used in the git_status source
        -- Status type
        untracked = "",
        ignored = "",
        unstaged = "󰄱",
        staged = "",
        conflict = "",
      },
    },
    -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
    file_size = {
      enabled = true,
      width = 12, -- width of the column
      required_width = 64, -- min width of window required to show this column
    },
    type = {
      enabled = true,
      width = 10, -- width of the column
      required_width = 122, -- min width of window required to show this column
    },
    last_modified = {
      enabled = true,
      width = 20, -- width of the column
      required_width = 88, -- min width of window required to show this column
    },
    created = {
      enabled = true,
      width = 20, -- width of the column
      required_width = 110, -- min width of window required to show this column
    },
    symlink_target = {
      enabled = false,
    },
  },
  -- A list of functions, each representing a global custom command
  -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
  -- see `:h neo-tree-custom-commands-global`
  commands = {},
  window = {
    position = "left",
    width = 40,
    mapping_options = {
      noremap = true,
      nowait = true,
    },
    mappings = {
      ["<space>"] = {
        "toggle_node",
        nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
      },
      ["<2-LeftMouse>"] = "open",
      ["<cr>"] = "open",
      ["<esc>"] = "cancel", -- close preview or floating neo-tree window
      ["P"] = {
        "toggle_preview",
        config = {
          use_float = true,
          use_snacks_image = true,
          use_image_nvim = true,
        },
      },
      -- Read `# Preview Mode` for more information
      ["l"] = "focus_preview",
      ["S"] = "open_split",
      ["s"] = "open_vsplit",
      -- ["S"] = "split_with_window_picker",
      -- ["s"] = "vsplit_with_window_picker",
      ["t"] = "open_tabnew",
      -- ["<cr>"] = "open_drop",
      -- ["t"] = "open_tab_drop",
      ["w"] = "open_with_window_picker",
      --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
      ["C"] = "close_node",
      -- ['C'] = 'close_all_subnodes',
      ["z"] = "close_all_nodes",
      --["Z"] = "expand_all_nodes",
      --["Z"] = "expand_all_subnodes",
      ["a"] = {
        "add",
        -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
        -- some commands may take optional config options, see `:h neo-tree-mappings` for details
        config = {
          show_path = "none", -- "none", "relative", "absolute"
        },
      },
      ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
      ["d"] = "delete",
      ["r"] = "rename",
      ["b"] = "rename_basename",
      ["y"] = "copy_to_clipboard",
      ["x"] = "cut_to_clipboard",
      ["p"] = "paste_from_clipboard",
      ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
      -- ["c"] = {
      --  "copy",
      --  config = {
      --    show_path = "none" -- "none", "relative", "absolute"
      --  }
      --}
      ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
      ["q"] = "close_window",
      ["R"] = "refresh",
      ["?"] = "show_help",
      ["<"] = "prev_source",
      [">"] = "next_source",
      ["i"] = "show_file_details",
      -- ["i"] = {
      --   "show_file_details",
      --   -- format strings of the timestamps shown for date created and last modified (see `:h os.date()`)
      --   -- both options accept a string or a function that takes in the date in seconds and returns a string to display
      --   -- config = {
      --   --   created_format = "%Y-%m-%d %I:%M %p",
      --   --   modified_format = "relative", -- equivalent to the line below
      --   --   modified_format = function(seconds) return require('neo-tree.utils').relative_date(seconds) end
      --   -- }
      -- },
    },
  },
  nesting_rules = {},
  filesystem = {
    filtered_items = {
      visible = false, -- when true, they will just be displayed differently than normal items
      hide_dotfiles = true,
      hide_gitignored = true,
      hide_hidden = true, -- only works on Windows for hidden files/directories
      hide_by_name = {
        --"node_modules"
      },
      hide_by_pattern = { -- uses glob style patterns
        --"*.meta",
        --"*/src/*/tsconfig.json",
      },
      always_show = { -- remains visible even if other settings would normally hide it
        --".gitignored",
      },
      always_show_by_pattern = { -- uses glob style patterns
        --".env*",
      },
      never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
        --".DS_Store",
        --"thumbs.db"
      },
      never_show_by_pattern = { -- uses glob style patterns
        --".null-ls_*",
      },
    },
    follow_current_file = {
      enabled = false, -- This will find and focus the file in the active buffer every time
      --               -- the current file is changed while the tree is open.
      leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
    },
    group_empty_dirs = false, -- when true, empty folders will be grouped together
    hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
    -- in whatever position is specified in window.position
    -- "open_current",  -- netrw disabled, opening a directory opens within the
    -- window like netrw would, regardless of window.position
    -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
    use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
    -- instead of relying on nvim autocmd events.
    window = {
      mappings = {
        ["<bs>"] = "navigate_up",
        ["."] = "set_root",
        ["H"] = "toggle_hidden",
        ["/"] = "fuzzy_finder",
        ["D"] = "fuzzy_finder_directory",
        ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
        -- ["D"] = "fuzzy_sorter_directory",
        ["f"] = "filter_on_submit",
        ["<c-x>"] = "clear_filter",
        ["[g"] = "prev_git_modified",
        ["]g"] = "next_git_modified",
        ["o"] = {
          "show_help",
          nowait = false,
          config = { title = "Order by", prefix_key = "o" },
        },
        ["oc"] = { "order_by_created", nowait = false },
        ["od"] = { "order_by_diagnostics", nowait = false },
        ["og"] = { "order_by_git_status", nowait = false },
        ["om"] = { "order_by_modified", nowait = false },
        ["on"] = { "order_by_name", nowait = false },
        ["os"] = { "order_by_size", nowait = false },
        ["ot"] = { "order_by_type", nowait = false },
        -- ['<key>'] = function(state) ... end,
      },
      fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
        ["<down>"] = "move_cursor_down",
        ["<C-n>"] = "move_cursor_down",
        ["<up>"] = "move_cursor_up",
        ["<C-p>"] = "move_cursor_up",
        ["<esc>"] = "close",
        ["<S-CR>"] = "close_keep_filter",
        ["<C-CR>"] = "close_clear_filter",
        ["<C-w>"] = { "<C-S-w>", raw = true },
        {
          -- normal mode mappings
          n = {
            ["j"] = "move_cursor_down",
            ["k"] = "move_cursor_up",
            ["<S-CR>"] = "close_keep_filter",
            ["<C-CR>"] = "close_clear_filter",
            ["<esc>"] = "close",
          }
        }
        -- ["<esc>"] = "noop", -- if you want to use normal mode
        -- ["key"] = function(state, scroll_padding) ... end,
      },
    },

    commands = {}, -- Add a custom command or override a global one using the same function name
  },
  buffers = {
    follow_current_file = {
      enabled = true, -- This will find and focus the file in the active buffer every time
      --              -- the current file is changed while the tree is open.
      leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
    },
    group_empty_dirs = true, -- when true, empty folders will be grouped together
    show_unloaded = true,
    window = {
      mappings = {
        ["d"] = "buffer_delete",
        ["bd"] = "buffer_delete",
        ["<bs>"] = "navigate_up",
        ["."] = "set_root",
        ["o"] = {
          "show_help",
          nowait = false,
          config = { title = "Order by", prefix_key = "o" },
        },
        ["oc"] = { "order_by_created", nowait = false },
        ["od"] = { "order_by_diagnostics", nowait = false },
        ["om"] = { "order_by_modified", nowait = false },
        ["on"] = { "order_by_name", nowait = false },
        ["os"] = { "order_by_size", nowait = false },
        ["ot"] = { "order_by_type", nowait = false },
      },
    },
  },
  git_status = {
    window = {
      position = "float",
      mappings = {
        ["A"] = "git_add_all",
        ["gu"] = "git_unstage_file",
        ["gU"] = "git_undo_last_commit",
        ["ga"] = "git_add_file",
        ["gr"] = "git_revert_file",
        ["gc"] = "git_commit",
        ["gp"] = "git_push",
        ["gg"] = "git_commit_and_push",
        ["o"] = {
          "show_help",
          nowait = false,
          config = { title = "Order by", prefix_key = "o" },
        },
        ["oc"] = { "order_by_created", nowait = false },
        ["od"] = { "order_by_diagnostics", nowait = false },
        ["om"] = { "order_by_modified", nowait = false },
        ["on"] = { "order_by_name", nowait = false },
        ["os"] = { "order_by_size", nowait = false },
        ["ot"] = { "order_by_type", nowait = false },
      },
    },
  },
})
```

</details>

See `:h neo-tree` for full documentation. You can also preview that online at
[doc/neo-tree.txt](doc/neo-tree.txt), although it's best viewed within Neovim.

To see all of the default config options with commentary, you can view it online
at [lua/neo-tree/defaults.lua](lua/neo-tree/defaults.lua). You can also paste it
into a buffer after installing Neo-tree by running:

```
:lua require("neo-tree").paste_default_config()
```

<details>
  <summary>Diagnostics icons:</summary>

If you want icons for diagnostic errors, you'll need to define them somewhere.
In Neovim v0.10+, you can configure them in vim.diagnostic.config(), like:

```lua
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '󰌵',
    },
  }
})
```

For older versions of Neovim:

```lua
vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })
```

</details>

## The `:Neotree` Command

The single `:Neotree` command accepts a range of arguments that give you full
control over the details of what and where it will show. For example, the following
command will open a file browser on the right hand side, "revealing" the currently
active file:

```
:Neotree filesystem reveal right
```

Arguments can be specified as either a key=value pair or just as the value. The
key=value form is more verbose but may help with clarity. For example, the command
above can also be specified as:

```
:Neotree source=filesystem reveal=true position=right
```

All arguments are optional and can be specified in any order. If you issue the command
without any arguments, it will use default values for everything. For example:

```
:Neotree
```

will open the filesystem source on the left hand side and focus it, if you are using
the default config.

### Tab Completion

Neotree supports tab completion for all arguments. Once a given argument has a value,
it will stop suggesting those completions. It will also offer completions for paths.
The simplest way to disambiguate a path from another type of argument is to start
them with `/` or `./`.

### Arguments

Here is the full list of arguments you can use:

#### `action`

What to do. Can be one of:

| Option | Description |
|--------|-------------|
| focus | Show and/or switch focus to the specified Neotree window. DEFAULT |
| show  | Show the window, but keep focus on your current window. |
| close | Close the window(s) specified. Can be combined with "position" and/or "source" to specify which window(s) to close. |

#### `source`

What to show. Can be one of:

| Option | Description |
|--------|-------------|
| filesystem | Show a file browser. DEFAULT |
| buffers    | Show a list of currently open buffers. |
| git_status | Show the output of `git status` in a tree layout. |
| last       | Equivalent to the last source used |

#### `position`

Where to show it, can be one of:

| Option  | Description |
|---------|-------------|
| left     | Open as left hand sidebar. DEFAULT |
| right    | Open as right hand sidebar. |
| top      | Open as top window. |
| bottom   | Open as bottom window. |
| float    | Open as floating window. |
| current  | Open within the current window, like netrw or vinegar would. |

#### `toggle`

This is a boolean flag. Adding this means that the window will be closed if it
is already open.

#### `dir`

The directory to set as the root/cwd of the specified window. If you include a
directory as one of the arguments, it will be assumed to be this option, you
don't need the full dir=/path. You may use any value that can be passed to the
'expand' function, such as `%:p:h:h` to specify two directories up from the
current file. For example:

```
:Neotree ./relative/path
:Neotree /home/user/relative/path
:Neotree dir=/home/user/relative/path
:Neotree position=current dir=relative/path
```

#### `git_base`

The base that is used to calculate the git status for each dir/file.
By default it uses `HEAD`, so it shows all changes that are not yet committed.
You can for example work on a feature branch, and set it to `main`. It will
show all changes that happened on the feature branch and main since you
branched off.

Any git ref, commit, tag, or sha will work.

```
:Neotree main
:Neotree v1.0
:Neotree git_base=8fe34be
:Neotree git_base=HEAD
```

#### `reveal`

This is a boolean flag. Adding this will make Neotree automatically find and
focus the current file when it opens.

#### `reveal_file`

A path to a file to reveal. This supersedes the "reveal" flag so there is no
need to specify both. Use this if you want to reveal something other than the
current file. If you include a path to a file as one of the arguments, it will
be assumed to be this option. Like "dir", you can pass any value that can be
passed to the 'expand' function. For example:

```
:Neotree reveal_file=/home/user/my/file.text
:Neotree position=current dir=%:p:h:h reveal_file=%:p
:Neotree current %:p:h:h %:p
```

One neat trick you can do with this is to open a Neotree window which is
focused on the file under the cursor using the `<cfile>` keyword:

```
nnoremap gd :Neotree float reveal_file=<cfile> reveal_force_cwd<cr>
```

#### `reveal_force_cwd`

This is a boolean flag. Normally, if you use one of the reveal options and the
given file is not within the current working directory, you will be asked if you
want to change the current working directory. If you include this flag, it will
automatically change the directory without prompting. This option implies
"reveal", so you do not need to specify both.

#### `selector`

This is a boolean flag. When you specifically set this to false (`selector=false`)
neo-tree will disable the [source selector](#source-selector) for that neo-tree
instance. Otherwise, the source selector will depend on what you specified in
the configuration (`config.source_selector.{winbar,statusline}`).

See `:h neo-tree-commands` for details and a full listing of available arguments.

### File Nesting

See `:h neo-tree-file-nesting` for more details about file nesting.

### Netrw Hijack

```
:edit .
:[v]split .
```

If `"filesystem.window.position"` is set to `"current"`, or if you have specified
`filesystem.hijack_netrw_behavior = "open_current"`, then any command
that would open a directory will open neo-tree in the specified window.

## Sources

Neo-tree is built on the idea of supporting various sources. Sources are
basically interface implementations whose job it is to provide a list of
hierarchical items to be rendered, along with commands that are appropriate to
those items.

### filesystem
The default source is `filesystem`, which displays your files and folders. This
is the default source in commands when none is specified.

This source can be used to:
- Browse the filesystem
- Control the current working directory of nvim
- Add/Copy/Delete/Move/Rename files and directories
- Search the filesystem
- Monitor git status and lsp diagnostics for the current working directory

### buffers
![Neo-tree buffers](https://github.com/nvim-neo-tree/resources/raw/main/images/Neo-tree-buffers.png)

Another available source is `buffers`, which displays your open buffers. This is
the same list you would see from `:ls`. To show with the `buffers` list, use:

```
:Neotree buffers
```

### git_status
This view take the results of the `git status` command and display them in a
tree. It includes commands for adding, unstaging, reverting, and committing.

The screenshot below shows the result of `:Neotree float git_status` while the
filesystem is open in a sidebar:

![Neo-tree git_status](https://github.com/nvim-neo-tree/resources/raw/main/images/Neo-tree-git_status.png)

You can specify a different git base here as well. But be aware that it is not
possible to unstage / revert a file that is already committed.

```
:Neotree float git_status git_base=main
```

### document_symbols

![Neo-tree document_symbols](https://github.com/nvim-neo-tree/resources/raw/main/images/neo-tree-document-symbols.png)
The document_symbols source lists the symbols in the current document obtained
by the LSP request "textDocument/documentSymbols". It currently supports the
following features:
- [x] UI:
	- [x] Display all symbols in the current file with symbol kinds
	- [x] Symbols nesting
	- [x] Configurable kinds' name and icon
	- [x] Auto-refresh symbol list
        - [x] Follow cursor
- [ ] Commands
	- [x] Jump to symbols, open symbol in split,... (`open_split` and friends)
	- [x] Rename symbols (`rename`)
	- [x] Preview symbol (`preview` and friends)
	- [ ] Hover docs
	- [ ] Call hierarchy
- [x] LSP
   - [x] LSP Support
   - [x] LSP server selection (ignore, allow_only, use first, use all, etc.)
- [ ] CoC Support

See #879 for the tracking issue of these features.

This source is currently experimental, so in order to use it, you need to first
add `"document_symbols"` to `config.sources` and open it with the command
```
:Neotree document_symbols
```

### External Sources

There are more sources available as extensions that are managed outside of this
repository. See the
[wiki](https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/External-Sources) for
more information.

### Source Selector

![Neo-tree source
selector](https://github.com/nvim-neo-tree/resources/raw/main/images/Neo-tree-source-selector.png)

You can enable a clickable source selector in either the winbar (requires neovim
0.8+) or the statusline. To do so, set one of these options to `true`:

```lua
    require("neo-tree").setup({
        source_selector = {
            winbar = false,
            statusline = false
        }
    })
```

There are many configuration options to change the style of these tabs.
See [lua/neo-tree/defaults.lua](lua/neo-tree/defaults.lua) for details.

### Preview Mode

`:h neo-tree-preview-mode`

Preview mode will temporarily show whatever file the cursor is on without
switching focus from the Neo-tree window. By default, files will be previewed
in a new floating window. This can also be configured to automatically choose
an existing split by configuring the command like this:

```lua
require("neo-tree").setup({
  window = {
    mappings = {
      ["P"] = {
        "toggle_preview",
        config = {
          use_float = false,
          -- use_image_nvim = true,
          -- use_snacks_image = true,
          -- title = 'Neo-tree Preview',
        },
      },
    }
  }
})
```

Anything that causes Neo-tree to lose focus will end preview mode. When
`use_float = false`, the window that was taken over by preview mode will revert
back to whatever was shown in that window before preview mode began.

You can choose a custom title for the floating window by setting the `title`
option in its config.

If you want to work with the floating preview mode window in autocmds or other
custom code, the window will have the `neo-tree-preview` filetype.

When preview mode is not using floats, the window will have the window local
variable `neo_tree_preview` set to `1` to indicate that it is being used as a
preview window. You can refer to this in statusline and winbar configs to mark a
window as being used as a preview.

#### Image Support in Preview Mode

If you have
[folke/snacks.nvim](https://github.com/folke/snacks.nvim/blob/main/docs/image.md)
or [3rd/image.nvim](https://github.com/3rd/image.nvim) installed, preview mode
supports image rendering by default using kitty graphics protocol or ueberzug
([Video](https://user-images.githubusercontent.com/41065736/277180763-b7152637-f310-43a5-b8c3-4bcba135629d.mp4)).

However, if you do not want this feature, you can disable it by setting
`use_snacks_image = false` or `use_image_nvim = false` in the mappings config
mentioned above.

## Configuration and Customization

This is designed to be flexible. The way that is achieved is by making
everything a function, or a string that identifies a built-in function. All of
the built-in functions can be replaced with your own implementation, or you can
add new ones.

Each node in the tree is created from the renderer specified for the given node
type, and each renderer is a list of component configs to be rendered in order.
Each component is a function, either built-in or specified in your config. Those
functions simply return the text and highlight group for the component.

Additionally, there is an events system that you can hook into. If you want to
show some new data point related to your files, gather it in the `before_render`
event, create a component to display it, and reference that component in the
renderer for the `file` and/or `directory` type.

Details on how to configure everything is in the help file at `:h
neo-tree-configuration` or online at
[neo-tree.txt](https://github.com/nvim-neo-tree/neo-tree.nvim/blob/main/doc/neo-tree.txt)

Recipes for customizations can be found on the
[wiki](https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes). Recipes
include things like adding a component to show the
[Harpoon](https://github.com/ThePrimeagen/harpoon) index for files, or
responding to the `"file_opened"` event to auto clear the search when you open a
file.

## Why?

There are many tree plugins for (Neo)vim, so why make another one? Well, I
wanted something that was:

1. Easy to maintain and enhance.
2. Stable.
3. Easy to customize.

### Easy to maintain and enhance

This plugin is designed to grow and be flexible. This is accomplished by making
the code as decoupled and functional as possible. Hopefully new contributors
will find it easy to work with.

One big difference between this plugin and the ones that came before it, which
is also what finally pushed me over the edge into making a new plugin, is that
we now have libraries to build upon that did not exist when other tree plugins
were created. Most notably, [nui.nvim](https://github.com/MunifTanjim/nui.nvim)
and [plenary.nvm](https://github.com/nvim-lua/plenary.nvim). Building upon
shared libraries will go a long way in making neo-tree easy to maintain.

### Stable

This project will have releases and release tags that follow a simplified
Semantic Versioning scheme. The quickstart instructions will always refer to the
latest stable major version. Following the **main** branch is for contributors
and those that always want bleeding edge. There will be branches for **v1.x**,
**v2.x**, etc which will receive updates after a short testing period in
**main**. You should be safe to follow those branches and be sure your tree
won't break in an update. There will also be tags for each release pushed to
those branches named **v1.1**, **v1.2**, etc. If stability is critical to you,
or a bug accidentally makes it into **v3.x**, you can use those tags instead.
It's possible we may backport bug fixes to those tags, but no guarantees on
that.

There will never be a breaking change within a major version (1.x, 2.x, etc.) If
a breaking change is needed, there will be depracation warnings in the prior
major version, and the breaking change will happen in the next major version.

### Easy to Customize

Neo-tree follows in the spirit of plugins like
[lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) and
[nvim-cokeline](https://github.com/noib3/nvim-cokeline). Everything will be
configurable and take either strings, tables, or functions. You can take sane
defaults or build your tree items from scratch. There should be the ability to
add any features you can think of through existing hooks in the setup function.

## What is a Breaking Change?

As of v1.30, a breaking change is defined as anything that _changes_ existing:

- vim commands (`:Neotree`)
- configuration options that are passed into the `setup()` function
- `NeoTree*` highlight groups
- lua functions exported in the following modules that are not prefixed with
`_`:
* `neo-tree`
* `neo-tree.events`
* `neo-tree.sources.manager`
* `neo-tree.sources.*` (init.lua files)
* `neo-tree.sources.*.commands`
* `neo-tree.ui.renderer`
* `neo-tree.utils`

If there are other functions you would like to use that are not yet considered
part of the public API, please open an issue so we can discuss it.

## Contributions

Contributions are encouraged. Please see [CONTRIBUTING](CONTRIBUTING.md) for
more details.

## Acknowledgements

### Maintainers

First and foremost, this project is a community endeavor and would not survive
without the constant stream of features and bug fixes that comes from that
community. There have been many valued contributors, but a few have stepped up
to become maintainers that generously donate their time to guide the project,
help out others, and manage the issues. The current list of maintainers are:

- @pynappo

### Past maintainers:

(in alphabetical order)

- @cseickel
- @miversen33
- @nhat-vo
- @pysan3

### Other Projects

The design is heavily inspired by these excellent plugins:
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- [nvim-cokeline](https://github.com/noib3/nvim-cokeline)

Everything I know about writing a tree control in lua, I learned from:
- [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua)

<!-- vim: set textwidth=80 shiftwidth=2: -->

