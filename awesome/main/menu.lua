-- This module is for the main menu.

-- Standard awesome library
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Theme handling library
local beautiful = require("beautiful") -- for awesome.icon

local M = {}  -- menu
local _M = {} -- module

-- reading
-- https://awesomewm.org/apidoc/popups%20and%20bars/awful.menu.html

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- This is used later as the default terminal and editor to run.
-- local terminal = "xfce4-terminal"
local terminal = RC.vars.terminal

-- Variable definitions
-- This is used later as the default terminal and editor to run.
local editor = os.getenv("EDITOR") or "nano"
local editor_cmd = terminal .. " -e " .. editor

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

M.awesome = {
  { "Hotkeys", function() 
      hotkeys_popup.show_help(nil, awful.screen.focused()) 
    end },
  { "Manual", terminal .. " -e man awesome" },
  { "Edit config", editor_cmd .. " " .. awesome.conffile },
  { "Restart", awesome.restart },
  { "Quit", function() awesome.quit() end }
}

M.applications = {
  { "Discord", "discord" },
--  { "firefox", "firefox", awful.util.getdir("config") .. "/firefox.png" },
  { "Google Chrome", "google-chrome-stable" },
--  { "&firefox", "firefox" },
  { "Thunderbird", "thunderbird" },
  { "Telegram", "telegram-desktop" },
  { "LibreOffice", "libreoffice" },
  { "Transmission", "transmission-gtk" },
  { "Volume Control", "pavucontrol" },
  { "Visual Studio Code", "code"}
}

M.power = {
  { "Shutdown", "systemctl poweroff" },
  { "Suspend", "systemctl suspend" },
  { "Reboot", "systemctl reboot" }
}

--M.network_main = {
--  { "wicd-curses", "wicd-curses" },
--  { "wicd-gtk", "wicd-gtk" }
--}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()

  -- Main Menu
  local menu_items = {
    { "awesome", M.awesome, beautiful.awesome_subicon },
    { "Open terminal", terminal },
--    { "network", M.network_main },
    { "Applications", M.applications },
    { "Power", M.power }
  }

  return menu_items
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
