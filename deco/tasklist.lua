-- This module binds mouse keys for the tasklist.

-- {{{ Required libraries
local gears = require("gears")
local awful = require("awful")
-- }}}

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
  local tasklist_buttons = gears.table.join(
    awful.button({ }, 1, function (c) -- Left-click to (un)minimize focused client.
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
    awful.button({ }, 3, function() -- Right-click to list clients.
      awful.menu.client_list({ theme = { width = 250 } })
    end),
    -- Scroll up/down to switch between clients.
    awful.button({ }, 4, function ()
      awful.client.focus.byidx(1)
    end),
    awful.button({ }, 5, function ()
      awful.client.focus.byidx(-1)
    end)
  )

  return tasklist_buttons
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
