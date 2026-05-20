-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

local programs = require("conf.programs")

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("awww img " .. programs.wallpaper)
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("mako --default-timeout 5000")
	hl.exec_cmd("nm-applet")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("waybar")
	hl.exec_cmd("swayosd-server")
	hl.exec_cmd("hyprctl setcursor default 24")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'")
	hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
	hl.exec_cmd("systemctl --user stop xdg-desktop-portal-gnome")
	hl.exec_cmd("systemctl --user stop xdg-desktop-portal")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)
