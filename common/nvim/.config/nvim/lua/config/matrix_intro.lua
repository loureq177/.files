local M = {}

local logo = {
	"███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
	"████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
	"██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
	"██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
	"██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
	"╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝    ╚═╝",
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
	{ row = 0, offset = 1 },
}

local function get_noise_char(depth)
	if depth < 0.3 then
		return noise1[math.random(#noise1)]
	elseif depth < 0.6 then
		return katakana_tbl[math.random(#katakana_tbl)]
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

-- helper: stop+close a uv timer safely (was duplicated 3x)
local function stop_timer(t)
	if t and not t:is_closing() then
		t:stop()
		t:close()
	end
end

-- helper: rotate a char-array in place (was duplicated inline in glitch block)
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
	if vim.fn.argc() ~= 0 or vim.api.nvim_buf_get_name(0) ~= "" then
		return
	end

	local dash_win, logo_bufline

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "snacks_dashboard" then
			dash_win = win
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

	if not dash_win or not logo_bufline then
		return
	end

	local spos = vim.fn.screenpos(dash_win, logo_bufline, 1)
	if spos.row == 0 then
		return
	end

	local w = vim.fn.strdisplaywidth(logo[1])
	local win_width = vim.api.nvim_win_get_width(dash_win)
	local win_pos = vim.api.nvim_win_get_position(dash_win)
	local col = win_pos[2] + math.floor((win_width - w) / 2)

	local hl = vim.api.nvim_get_hl(0, { name = "SnacksDashboardHeader", link = false })
	local fg = hl.fg and string.format("#%06x", hl.fg) or "#3fb950"

	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].bufhidden = "wipe"

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
	vim.wo[win].winhighlight = "Normal:MatrixAnimFg3"

	local frame, total = 0, 50
	local timer = vim.uv.new_timer()
	local glitch_timer = nil
	local autocmd_id

	-- NOTE: this is the single source of truth for teardown.
	-- Removed the redundant `nvim_get_current_win() ~= dash_win` checks
	-- that were duplicated inside both timer callbacks below: WinLeave /
	-- CursorMoved / WinEnter already fire (and cleanup) in the same tick
	-- before those checks could ever be true, so they were dead code.
	local function cleanup()
		stop_timer(timer)
		stop_timer(glitch_timer)
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
		if autocmd_id then
			pcall(vim.api.nvim_del_autocmd, autocmd_id)
			autocmd_id = nil
		end
	end

	autocmd_id = vim.api.nvim_create_autocmd(
		{ "BufLeave", "WinLeave", "WinEnter", "CursorMoved", "InsertEnter", "CmdlineEnter" },
		{ callback = cleanup }
	)

	local function set_lines(lines)
		vim.bo[buf].modifiable = true
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
		vim.bo[buf].modifiable = false
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

				glitch_count = glitch_count + 1
				if glitch_count > 8 or not vim.api.nvim_win_is_valid(win) then
					set_lines(logo)
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
		0,
		25,
		vim.schedule_wrap(function()
			if vim.api.nvim_get_current_win() ~= dash_win then
				cleanup()
				return
			end
			frame = frame + 1

			if not vim.api.nvim_buf_is_valid(buf) then
				stop_timer(timer)
				return
			end

			local p = frame / total
			local progress = p < 0.5 and 2 * p * p or -1 + (4 - 2 * p) * p

			local lines = {}
			for i, chars in ipairs(parsed_logo) do
				lines[i] = scramble(chars, progress)
			end
			set_lines(lines)

			local hl_idx = math.min(5, math.floor(progress * 5) + 1)
			vim.wo[win].winhighlight = "Normal:" .. hl_names[hl_idx]

			if frame >= total then
				start_glitch_phase()
			end
		end)
	)
end

return M
