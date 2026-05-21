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
			table.insert(result, ch)
		else
			if ch == " " then
				if math.random() > 0.7 + (progress * 0.3) then
					table.insert(result, get_noise_char(math.random()))
				else
					table.insert(result, " ")
				end
			else
				if math.random() < progress * 0.5 then
					table.insert(result, ch)
				else
					table.insert(result, get_noise_char(progress))
				end
			end
		end
	end
	return table.concat(result)
end

function M.play()
	local dash_win, logo_bufline, logo_buf

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "snacks_dashboard" then
			dash_win = win
			logo_buf = buf
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

	local original_lines = {}
	local modifiable = vim.bo[logo_buf].modifiable

	if modifiable then
		original_lines = vim.api.nvim_buf_get_lines(logo_buf, logo_bufline - 1, logo_bufline - 1 + #logo, false)
		vim.api.nvim_buf_set_lines(
			logo_buf,
			logo_bufline - 1,
			logo_bufline - 1 + #logo,
			false,
			vim.tbl_map(function()
				return ""
			end, original_lines)
		)
	end

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
		local name = "MatrixAnimFg" .. i
		hl_names[i] = name
		vim.api.nvim_set_hl(0, name, { fg = fg, bold = i > 3 })
	end
	vim.wo[win].winhighlight = "Normal:MatrixAnimFg3"

	local glitch_frames = {
		{ row = 1, offset = 2 },
		{ row = 3, offset = -1 },
		{ row = 2, offset = 3 },
		{ row = 4, offset = -2 },
		{ row = 0, offset = 1 },
	}

	local frame, total = 0, 50
	local timer = vim.uv.new_timer()
	local glitch_timer = nil

	timer:start(
		0,
		25,
		vim.schedule_wrap(function()
			frame = frame + 1

			if not vim.api.nvim_buf_is_valid(buf) then
				timer:stop()
				if not timer:is_closing() then
					timer:close()
				end
				return
			end

			local p = frame / total
			local progress = p < 0.5 and 2 * p * p or -1 + (4 - 2 * p) * p

			local lines = {}
			for _, chars in ipairs(parsed_logo) do
				table.insert(lines, scramble(chars, progress))
			end

			vim.bo[buf].modifiable = true
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

			local hl_idx = math.min(5, math.floor(progress * 5) + 1)
			vim.wo[win].winhighlight = "Normal:" .. hl_names[hl_idx]

			vim.bo[buf].modifiable = false

			if frame >= total then
				local glitch_count = 0
				glitch_timer = vim.uv.new_timer()
				glitch_timer:start(
					0,
					40,
					vim.schedule_wrap(function()
						if not vim.api.nvim_buf_is_valid(buf) then
							if glitch_timer and not glitch_timer:is_closing() then
								glitch_timer:stop()
								glitch_timer:close()
							end
							return
						end

						glitch_count = glitch_count + 1
						if glitch_count > 8 or not vim.api.nvim_win_is_valid(win) then
							vim.bo[buf].modifiable = true
							vim.api.nvim_buf_set_lines(buf, 0, -1, false, logo)
							vim.bo[buf].modifiable = false

							if modifiable and #original_lines > 0 then
								vim.api.nvim_buf_set_lines(
									logo_buf,
									logo_bufline - 1,
									logo_bufline - 1 + #logo,
									false,
									original_lines
								)
							end

							vim.defer_fn(function()
								if vim.api.nvim_win_is_valid(win) then
									vim.api.nvim_win_close(win, true)
								end
							end, 200)

							if glitch_timer and not glitch_timer:is_closing() then
								glitch_timer:stop()
								glitch_timer:close()
							end

							timer:stop()
							if not timer:is_closing() then
								timer:close()
							end
							return
						end

						local glitched_lines = {}
						for i, line in ipairs(logo) do
							local glitch = glitch_frames[(glitch_count % #glitch_frames) + 1]
							if i == glitch.row and glitch.row > 0 and glitch.row <= #logo then
								local chars = vim.fn.split(line, "\\zs")
								if glitch.offset > 0 then
									for _ = 1, glitch.offset do
										table.insert(chars, 1, table.remove(chars))
									end
								else
									for _ = 1, -glitch.offset do
										table.insert(chars, table.remove(chars, 1))
									end
								end
								table.insert(glitched_lines, table.concat(chars))
							else
								table.insert(glitched_lines, line)
							end
						end

						vim.bo[buf].modifiable = true
						vim.api.nvim_buf_set_lines(buf, 0, -1, false, glitched_lines)
						vim.bo[buf].modifiable = false
					end)
				)
			end
		end)
	)
end

return M
