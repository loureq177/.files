local M = {}

local logo = {
	"███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
	"████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
	"██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
	"██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
	"██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
	"╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
}

local katakana_tbl = vim.fn.split(
	"ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝ",
	"\\zs"
)
local noise1 = vim.fn.split("░▒▓", "\\zs")
local noise2 = vim.fn.split("█▓▒░", "\\zs")

local parsed_logo = {}
for _, line in ipairs(logo) do
	table.insert(parsed_logo, vim.fn.split(line, "\\zs"))
end

local glitch_frames = {
	{ row = 1, offset = 2 },
	{ row = 3, offset = -1 },
	{ row = 2, offset = 3 },
	{ row = 4, offset = -2 },
}

local function get_noise_char(depth)
	if depth < 0.4 then
		return katakana_tbl[math.random(#katakana_tbl)]
	elseif depth < 0.7 then
		return math.random() > 0.5 and katakana_tbl[math.random(#katakana_tbl)] or noise1[math.random(#noise1)]
	else
		return noise2[math.random(#noise2)]
	end
end

local function scramble(chars, progress)
	local result = {}
	for _, ch in ipairs(chars) do
		if math.random() < progress then
			result[#result + 1] = ch
		elseif ch == " " then
			result[#result + 1] = (math.random() > 0.7 + progress * 0.3)
					and get_noise_char(math.random())
				or " "
		else
			result[#result + 1] = (math.random() < progress * 0.5) and ch
				or get_noise_char(progress)
		end
	end
	return table.concat(result)
end

local function stop_timer(t)
	if t and not t:is_closing() then
		t:stop()
		t:close()
	end
end

local function rotate(chars, offset)
	if offset > 0 then
		for _ = 1, offset do
			table.insert(chars, 1, table.remove(chars))
		end
	else
		for _ = 1, -offset do
			table.insert(chars, table.remove(chars, 1))
		end
	end
end

function M.play()
	local argc = vim.fn.argc()
	local is_dir = argc == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1
	if (argc == 0 and vim.api.nvim_buf_get_name(0) ~= "") or (argc ~= 0 and not is_dir) then
		return
	end

	local dash_win, dash_buf, logo_bufline

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "snacks_dashboard" then
			dash_win = win
			dash_buf = buf
			local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
			for i, line in ipairs(lines) do
				if line:find("███") then
					logo_bufline = i
					break
				end
			end
			break
		end
	end

	if not dash_win or not dash_buf or not logo_bufline then
		return
	end

	local spos = vim.fn.screenpos(dash_win, logo_bufline, 1)
	if spos.row == 0 then
		vim.cmd("redraw")
		spos = vim.fn.screenpos(dash_win, logo_bufline, 1)
		if spos.row == 0 then
			return
		end
	end

	local w = vim.fn.strdisplaywidth(logo[1])
	local win_width = vim.api.nvim_win_get_width(dash_win)
	if win_width < w then
		return
	end
	local win_pos = vim.api.nvim_win_get_position(dash_win)
	local col = win_pos[2] + math.floor((win_width - w) / 2)

	local hl = vim.api.nvim_get_hl(0, { name = "SnacksDashboardHeader", link = false })
	local fg = hl.fg and string.format("#%06x", hl.fg) or "#3fb950"

	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].modifiable = true

	local initial_lines = {}
	for i, chars in ipairs(parsed_logo) do
		initial_lines[i] = scramble(chars, 0)
	end
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, initial_lines)

	local win = vim.api.nvim_open_win(buf, false, {
		relative = "editor",
		width = w,
		height = #logo,
		row = spos.row - 1,
		col = col,
		style = "minimal",
		zindex = 300,
		focusable = false,
	})

	local hl_names = {}
	for i = 1, 5 do
		hl_names[i] = "MatrixAnimFg" .. i
		vim.api.nvim_set_hl(0, hl_names[i], { fg = fg, bold = i > 3 })
	end

	local last_hl_idx = 1
	vim.wo[win].winhighlight = "Normal:" .. hl_names[last_hl_idx]

	local frame, total = 0, 50
	local timer = vim.uv.new_timer()
	local glitch_timer = nil
	local autocmd_group = nil

	local function cleanup()
		stop_timer(timer)
		stop_timer(glitch_timer)
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
		if autocmd_group then
			pcall(vim.api.nvim_del_augroup_by_id, autocmd_group)
			autocmd_group = nil
		end
	end

	autocmd_group = vim.api.nvim_create_augroup("MatrixIntroTeardown", { clear = true })
	vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
		group = autocmd_group,
		buffer = dash_buf,
		callback = cleanup,
	})
	vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter", "VimResized" }, {
		group = autocmd_group,
		callback = cleanup,
	})
	vim.api.nvim_create_autocmd("CursorMoved", {
		group = autocmd_group,
		callback = function()
			if vim.api.nvim_get_current_win() == dash_win then
				cleanup()
			end
		end,
	})

	local function set_lines(lines)
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	end

	local function start_glitch_phase()
		local glitch_count = 0
		glitch_timer = vim.uv.new_timer()
		glitch_timer:start(
			0,
			40,
			vim.schedule_wrap(function()
				if not vim.api.nvim_buf_is_valid(buf) then
					stop_timer(glitch_timer)
					return
				end

				if not vim.api.nvim_win_is_valid(dash_win) or vim.api.nvim_win_get_buf(dash_win) ~= dash_buf then
					cleanup()
					return
				end

				glitch_count = glitch_count + 1
				if glitch_count > 8 or not vim.api.nvim_win_is_valid(win) then
					set_lines(logo)
					stop_timer(glitch_timer)
					vim.defer_fn(cleanup, 200)
					return
				end

				local glitch = glitch_frames[(glitch_count % #glitch_frames) + 1]
				local glitched_lines = {}
				for i, line in ipairs(logo) do
					if i == glitch.row and glitch.row > 0 and glitch.row <= #logo then
						local chars = vim.fn.split(line, "\\zs")
						rotate(chars, glitch.offset)
						glitched_lines[i] = table.concat(chars)
					else
						glitched_lines[i] = line
					end
				end
				set_lines(glitched_lines)
			end)
		)
	end

	timer:start(
		25,
		25,
		vim.schedule_wrap(function()
			if not vim.api.nvim_win_is_valid(dash_win) or vim.api.nvim_win_get_buf(dash_win) ~= dash_buf then
				cleanup()
				return
			end
			frame = frame + 1

			if not vim.api.nvim_buf_is_valid(buf) then
				stop_timer(timer)
				return
			end

			local progress = frame / total

			local lines = {}
			for i, chars in ipairs(parsed_logo) do
				lines[i] = scramble(chars, progress)
			end
			set_lines(lines)

			local hl_idx = math.min(5, math.floor(progress * 5) + 1)
			if hl_idx ~= last_hl_idx then
				vim.wo[win].winhighlight = "Normal:" .. hl_names[hl_idx]
				last_hl_idx = hl_idx
			end

			if frame >= total then
				stop_timer(timer)
				start_glitch_phase()
			end
		end)
	)
end

return M
