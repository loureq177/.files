-- Size and last change, the date as Nautilus writes it: 14:32, Yesterday, Wed, 12 Oct, 12 Oct 2024.
function Linemode:size_and_modified()
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		return ""
	end
	-- Noon, so that a day with a clock change still counts as one.
	local function noon(t)
		local d = os.date("*t", t)
		return os.time({ year = d.year, month = d.month, day = d.day, hour = 12 })
	end
	local days = math.floor((noon(os.time()) - noon(time)) / 86400 + 0.5)
	local day = os.date("*t", time).day
	local date
	if days == 0 then
		date = os.date("%H:%M", time)
	elseif days == 1 then
		date = "Yesterday"
	elseif days > 1 and days < 7 then
		date = os.date("%a", time)
	elseif os.date("%Y", time) == os.date("%Y") then
		date = day .. os.date(" %b", time)
	else
		date = day .. os.date(" %b %Y", time)
	end
	return string.format("%7s  %11s", Linemode.size(self), date)
end
