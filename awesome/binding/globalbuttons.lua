-- This module sets mouse buttons for toggling tags.

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
  local globalbuttons = gears.table.join(
    awful.button({ }, 3, function () RC.mainmenu:toggle() end), -- Right click
    awful.button({ }, 4, awful.tag.viewnext), -- Scroll up
    awful.button({ }, 5, awful.tag.viewprev) -- Scroll down
  )

  return globalbuttons
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
