-- Leader Space
vim.g.mapleader = " "
-- Escape File Leader pv
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Move Highlighted Text Shift J, K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Line from below on the end of the current line
vim.keymap.set("n", "J", "mzJ`z")

-- Half Page Jumping Keeps cursor in the middle
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Search Terms cursor in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")


-- Keeps clipboard after pasting over text
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Leader Y -- Use System Clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])


vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<C-f>", [[:.r !inkscape-figures create <C-r><C-L> %:p:h/figures <C-M>]])
vim.keymap.set("n", "<C-l>", [[:!inkscape-figures edit %:p:h/figures/ > /dev/null 2>&1 <CR> ]])

-- Spell Check
vim.keymap.set("i", "<C-k>", "<c-g>u<Esc>[s1z=`]a<c-g>u")

-- Format
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Quick Fix navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Space S : Replaces the word that cursor was on
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Make file executable from file with leader x
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Run build script
vim.keymap.set("n", "<leader>c", "<cmd>!./build.sh %:t:r<CR>")
-- Run output script
vim.keymap.set("n", "<leader>v", "<cmd>!./output.sh %:t:r<CR>")
-- Run build and output script
vim.keymap.set("n", "<leader>b", "<cmd>!./build.sh %:t:r && ./output.sh %:t:r<CR>")



