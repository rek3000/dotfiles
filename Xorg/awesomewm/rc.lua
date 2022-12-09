-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

require("main.error-handling")
require("main.signals")

RC = {}
RC.vars = require("main.user-variables")

modkey = RC.vars.modkey
terminal = RC.vars.terminal
editor = RC.vars.editor
editor_cmd = terminal .. " -e " .. editor


-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/rek/.config/awesome/theme.lua")

local main = {
	layouts = require("main.layouts"),
	tags    = require("main.tags"),
	menu    = require("main.menu"),
	rules   = require("main.rules"),
}

local binding = {
	globalbuttons = require("binding.globalbuttons"),
	clientbuttons = require("binding.clientbuttons"),
	globalkeys    = require("binding.globalkeys"),
	bindtotags    = require("binding.bindtotags"),
	clientkeys    = require("binding.clientkeys")
}

RC.layouts = main.layouts()
RC.tags = main.tags()

-- Menu
RC.mainmenu = awful.menu({ items = main.menu() })
RC.launcher = awful.widget.launcher({ image = "/home/rek/.config/awesome/assets/icon/bleach.jpg",
	menu = RC.mainmenu })
menubar.utils.terminal = RC.vars.terminal

awful.rules.rules = main.rules(
	binding.clientkeys(), 
	binding.clientbuttons()
)

RC.globalkeys = binding.globalkeys()
RC.globalkeys = binding.bindtotags(RC.globalkeys)
root.buttons(binding.globalbuttons())
root.keys(RC.globalkeys)


-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock ()

-- CUSTOM WIDGET --

--local cal = function(wibox.widget.calendar.month(os.date('*t')))


--------------------

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({ }, 1, function(t) t:view_only() end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({ }, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
	awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
	awful.button({ }, 1, function (c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal(
				"request::activate",
				"tasklist",
				{raise = true}
			)
		end
	end),
	awful.button({ }, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({ }, 4, function ()
		awful.client.focus.byidx(1)
	end),
	awful.button({ }, 5, function ()
		awful.client.focus.byidx(-1)
	end))

local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	set_wallpaper(s)

	-- Create a promptbox for each screen
	--
	s.mypromptbox = awful.widget.prompt()
	-- Create an iconfigmagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({ }, 1, function () awful.layout.inc( 1) end),
		awful.button({ }, 3, function () awful.layout.inc(-1) end),
		awful.button({ }, 4, function () awful.layout.inc( 1) end),
		awful.button({ }, 5, function () awful.layout.inc(-1) end)))
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist {
		screen  = s,
		filter  = awful.widget.taglist.filter.all,
		buttons = taglist_buttons
	}

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist {
		screen  = s,
		filter  = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons
	}

	-- Create the wibox
	s.mywibox = awful.wibar({ position = "top", screen = s, height = 25})
	s.imageicon = wibox.widget {
		image  = "/home/rek/.config/awesome/assets/icon/bleach.jpg",
		resize = true,
		widget = wibox.widget.imagebox,
	}
	---s.imageicon:connect_signal("button:press", wibox.widget.calendar.month(os.date('*t')))

	-- Add widgets to the wibox
	s.mywibox:setup {
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			RC.launcher,
			s.mytaglist,
			--s.imageicon,
		},
		--s.mytasklist, -- Middle widget
		{
			s.mypromptbox,
			layout = wibox.layout.fixed.horizontal,
		},
		layout = wibox.layout.fixed.horizontal,
		mytextclock,
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			--wibox.widget.systray(),
			s.mylayoutbox,
		},
	}
end)
-- }}}



-- {{{ Signals

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	-- buttons for the titlebar


	awful.titlebar(c) : setup {
		{ -- Left
			--awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout  = wibox.layout.fixed.horizontal
		},
		{ -- Middle
			{ -- Title
				align  = "center",
				widget = awful.titlebar.widget.titlewidget(c)
			},
			buttons = buttons,
			layout  = wibox.layout.flex.horizontal
		},
		{ -- Right
			awful.titlebar.widget.floatingbutton (c),
			--awful.titlebar.widget.maximizedbutton(c),
			--awful.titlebar.widget.stickybutton   (c),
			--awful.titlebar.widget.ontopbutton    (c),
			--awful.titlebar.widget.closebutton    (c),
			layout = wibox.layout.fixed.horizontal()
		},
		layout = wibox.layout.align.horizontal
	}
end)

-- Enable sloppy focus, so that focus follows mouse.

awful.spawn.with_shell("~/.config/awesome/autostart.sh")

-- }}}
