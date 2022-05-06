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

local markup = RC.lain.util.markup

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Widgets
-- TODO: Move to separate module
local volumecfg = deco.volumectl({device="pulse"})
local cpu = RC.lain.widget.cpu {
  settings = function()
    widget:set_markup(markup("#E72D2D", " CPU " .. cpu_now.usage .. "% "))
  end
}
local batt = RC.lain.widget.bat {
  settings = function()
    local perc = bat_now.perc ~= "N/A" and bat_now.perc .. "%" or bat_now.perc
    if bat_now.ac_status == 1 then
      perc = perc .. " plug"
    end
    widget:set_markup(markup("#F0EA29", " 🔋 " .. perc))
  end
}
local weather = RC.lain.widget.weather {
  APPID = RC.vars.api_key,
  city_id = RC.vars.city_id,
  timeout = 300,
  weather_na_markup = markup.fontfg("Terminus 10", "#eca4c4", "N/A "),
  settings = function()
    descr = weather_now["weather"][1]["description"]:lower()
    units = math.floor(weather_now["main"]["temp"])
    widget:set_markup(markup.fontfg("Terminus 10", "#eca4c4", descr .. " @ " .. units .. "°C "))
  end
}

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- {{{ Wibar
-- Create a textclock widget (customized to show seconds)
-- mytextclock = wibox.widget.textclock()
local mytextclock = wibox.widget {
  format  = '%F %H:%M:%S',
  widget  = wibox.widget.textclock,
  refresh = 1,
  align   = "center"
}

local mycalendar = awful.widget.calendar_popup.month()
mycalendar:attach(mytextclock, "br")
mycalendar:toggle()

-- TODO: Do not have certain stuff here show up on all screens
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
    buttons = taglist_buttons,
    style   = {
      shape = gears.shape.rounded_rect,
      bg_focus = "#F7F7F7",
      fg_focus = "#AD0808"
    },
    layout  = { -- Separators
      spacing = 5,
      spacing_widget = {
        color = "#222222",
        widget = wibox.widget.separator
      },
      layout = wibox.layout.fixed.horizontal
    }
  }

  -- Create the tasklist (bottom of the screen)
  s.mytasklist = awful.widget.tasklist {
    screen  = s,
    filter  = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons,
    style = {
      shape = gears.shape.rounded_rect,
    },
    layout = { -- Separators
      spacing = 10,
      spacing_widget = {
        {
          forced_width = 5,
          shape        = gears.shape.circle,
          widget       = wibox.widget.separator
        },
        valign = "center",
        halign = "center",
        widget = wibox.container.place,
      },
      layout = wibox.layout.flex.horizontal
    }
  }

  -- Create the wibox
  s.mywibox = awful.wibar({ position = "top", screen = s })

  -- Bottom wibox for tasklist
  s.bottomwibox = awful.wibar({
    position = "bottom",
    screen = s
  })

  -- Add widgets to the wibox
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      RC.launcher,
      s.mytaglist,
      s.mypromptbox,
    },
    nil,
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      wibox.widget.systray(),
      batt.widget,
      cpu.widget,
      volumecfg.widget,
      weather.widget,
    },
  }

  s.bottomwibox:setup {
    layout = wibox.layout.align.horizontal,
    s.mytasklist,
    nil,
    {
      layout = wibox.layout.fixed.horizontal,
      mytextclock,
      s.mylayoutbox,
    }
  }
end)
-- }}}
