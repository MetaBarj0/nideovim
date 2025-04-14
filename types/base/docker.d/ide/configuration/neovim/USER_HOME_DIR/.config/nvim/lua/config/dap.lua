local has_dap, dap = pcall(require, "dap")

if not has_dap then
	return
end

dap.adapters.lldb = {
	type = "executable",
	command = "lldb-dap",
	name = "lldb",
}

dap.configurations.env = (function()
	local variables = {}
	for k, v in pairs(vim.fn.environ()) do
		table.insert(variables, string.format("%s=%s", k, v))
	end
	return variables
end)()

dap.configurations.cpp = {
	{
		name = "Launch",
		type = "lldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},

		-- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
		--
		--    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
		--
		-- Otherwise you might get the following error:
		--
		--    Error on launch: Failed to attach to the target process
		--
		-- But you should be aware of the implications:
		-- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
		-- runInTerminal = false,
		runInTerminal = false,
	},

	{
		name = "Attach to process",
		type = "lldb", -- Adjust this to match your adapter name (`dap.adapters.<name>`)
		request = "attach",
		pid = require("dap.utils").pick_process,
		args = {},
	},
}

-- If you want to use this for Rust and C, add something like this:
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

-- local api = vim.api

-- local keymap_restore = {}
-- dap.listeners.after["event_initialized"]["me"] = function()
-- 	for _, buf in pairs(api.nvim_list_bufs()) do
-- 		local keymaps = api.nvim_buf_get_keymap(buf, "n")
-- 		for _, keymap in pairs(keymaps) do
-- 			if keymap.lhs == "K" then
-- 				table.insert(keymap_restore, keymap)
-- 				api.nvim_buf_del_keymap(buf, "n", "K")
-- 			end
-- 		end
-- 	end
-- 	api.nvim_set_keymap("n", "K", '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
-- end

-- dap.listeners.after["event_terminated"]["me"] = function()
-- 	for _, keymap in pairs(keymap_restore) do
-- 		api.nvim_buf_set_keymap(keymap.buffer, keymap.mode, keymap.lhs, keymap.rhs, { silent = keymap.silent == 1 })
-- 	end
-- 	keymap_restore = {}
-- end
