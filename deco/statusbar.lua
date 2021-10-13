-- This module is for the status bar at the top of the screen.

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Wibox handling library
local wibox = require("wibox")

-- Custom Local Library: Common Functional Decoration
local deco = {
  wallpaper = require("deco.wallpaper"),
  taglist   = require("deco.taglist"),
  tasklist  = require("deco.tasklist"),
  volumectl = require("deco.volumewidget")
}

local taglist_buttons  = deco.taglist()
local tasklist_buttons = deco.tasklist()

-- Widgets
local volumecfg = deco.volumectl({device="pulse"})
local cpu = RC.lain.widget.cpu {
  settings = function()
    widget:set_markup("CPU " .. cpu_now.usage)
  end
}

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- {{{ Wibar
-- Create a textclock widget (customized to show seconds)
-- mytextclock = wibox.widget.textclock()
mytextclock = wibox.widget {
  format = '%F %H:%M:%S',
  widget = wibox.widget.textclock,
  refresh = 1
}

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  set_wallpaper(s)

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()

  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({ }, 1, function () awful.layout.inc( 1) end), -- Left click
    awful.button({ }, 3, function () awful.layout.inc(-1) end), -- Right click
    awful.button({ }, 4, function () awful.layout.inc( 1) end), -- Scroll up
    awful.button({ }, 5, function () awful.layout.inc(-1) end)  -- Scroll down
  ))

  -- Create a taglist widget (upper left)
  s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = taglist_buttons
  }

  -- Create a tasklist widget (center)
  s.mytasklist = awful.widget.tasklist {
    screen  = s,
    filter  = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons
  }

  -- Create the wibox
  s.mywibox = awful.wibar({ position = "top", screen = s })

  -- Add widgets to the wibox
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      RC.launcher,
      s.mytaglist,
      s.mypromptbox,
    },
    s.mytasklist, -- Middle widget
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      mykeyboardlayout,
      wibox.widget.systray(),
      cpu.widget,
      volumecfg.widget,
      mytextclock,
      s.mylayoutbox,
    },
  }
end)
-- }}}
