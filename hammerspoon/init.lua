-- Load extensions
local fnutils = require "hs.fnutils"
local grid = require "hs.grid"
local hotkey = require "hs.hotkey"
local screen = require "hs.screen"
local window = require "hs.window"
local layout = require "hs.layout"

amphetamine = require "amphetamine"

hs.loadSpoon("WindowHalfsAndThirds")

local log = hs.logger.new("init", "debug")

hs.crash.crashLogToNSLog = true

-- The window move animations are annoying
window.animationDuration = 0

local mash      = {"ctrl", "cmd"}
local mashAlt   = {"ctrl", "cmd", "alt"}
local mashShift = {"ctrl", "cmd", "shift"}
local mashAll   = {"ctrl", "cmd", "alt", "shift"}

-- Reload hammerspoon config

hotkey.bind(mashAlt, "R", function() hs.reload() end)
hotkey.bind(mashAlt, "C", function() hs.console.clearConsole() end)


-- local windowSplitHotkeys = {
--   third_left  = { mash, "H" },
--   third_right = { mash, "L" },
--   center      = { mash, "," },
--   larger = { mash, "M" },
-- }

-- spoon.WindowHalfsAndThirds:bindHotkeys(windowSplitHotkeys)


-- -- Load all screens and sort them from left to right

-- local getSortedScreens = function()
--   local screens = hs.screen.allScreens()
--   table.sort(screens, function(screen1, screen2)
--     x1, y1 = screen1:position()
--     x2, y2 = screen2:position()
--     return x1 < x2
--   end)

--   for i, s in ipairs(screens) do
--     log.d(i)
--   end

--   return screens
-- end

-- Window movements

local gridset = function(frame)
   return function()
      local win = window.focusedWindow()
      if win then
         grid.set(win, frame, win:screen())
      else
         alert.show("No focused window.")
      end
   end
end

-- Set up grid

local gridW = 12
local gridH = 8

grid.setGrid(hs.geometry.size(gridW, gridH))
    .setMargins(hs.geometry.point(0, 0))

-- Move windows to discrete positions

local left_third = {x=0, y=0, w=gridW/3, h=gridH}
local center_third = {x=gridW/3, y=0, w=gridW/3, h=gridH}
local right_third = {x=(gridW/3)*2, y=0, w=gridW/3, h=gridH}
local center_large = {x=2, y=0, w=8, h=gridH}
local left_half = {x=0, y=0, w=gridW/2, h=gridH}
local right_half = {x=gridW/2, y=0, w=gridW/2, h=gridH}

-- local goleft = {x=0, y=0, w=gridW/2, h=gridH}
-- local goright = {x=gridW/2, y=0, w=gridW/2, h=gridH}
-- local gotop = {x=0, y=0, w=gridW, h=gridH/2}
-- local gobottom = {x=0, y=gridH/2, w=gridW, h=gridH/2}
-- local gocenter = {x=1, y=0, w=4, h=gridH}

-- local goupleft = {x=0, y=0, w=gridW/2, h=gridH/2}
-- local goupright = {x=gridW/2, y=0, w=gridW/2, h=gridH/2}
-- local godownleft = {x=0, y=gridH/2, w=gridW/2, h=gridH/2}
-- local godownright = {x=gridW/2, y=gridH/2, w=gridW/2, h=gridH/2}

-- function gridToFrame(screen, grid)
--   local screenFrame = screen:frame()
--   local cellW = screenFrame.w / gridW
--   local cellH = screenFrame.h / gridH
--   return hs.geometry.rect(cellW * grid.x, cellH * grid.y, cellW * grid.w, cellH * grid.h)
-- end

local movements = {
   {mod=mashShift, key="J", fn=gridset(left_third)},
   {mod=mashShift, key="K", fn=gridset(center_third)},
   {mod=mashShift, key="L", fn=gridset(right_third)},
   {mod=mashShift, key="I", fn=gridset(center_large)},
   {mod=mashShift, key="H", fn=gridset(left_half)},
   {mod=mashShift, key=";", fn=gridset(right_half)},
--    {mod=mashShift, key=",", fn=gridset(gocenter)},
   {mod=mashShift, key="M", fn=grid.maximizeWindow},
}

fnutils.each(movements, function(m)
  hotkey.bind(m.mod, m.key, m.fn)
end)

-- hotkey.bind(mashAll, 'u', gridset(goupleft))
-- hotkey.bind(mashAll, 'i', gridset(goupright))
-- hotkey.bind(mashAll, 'j', gridset(godownleft))
-- hotkey.bind(mashAll, 'k', gridset(godownright))

-- -- move windows
-- hotkey.bind(mashShift, "Left", hs.grid.pushWindowLeft)
-- hotkey.bind(mashShift, "Down", hs.grid.pushWindowDown)
-- hotkey.bind(mashShift, "Up", hs.grid.pushWindowUp)
-- hotkey.bind(mashShift, "Right", hs.grid.pushWindowRight)

-- -- resize windows
-- hotkey.bind(mashShift, "Y", hs.grid.resizeWindowThinner)
-- hotkey.bind(mashShift, "U", hs.grid.resizeWindowTaller)
-- hotkey.bind(mashShift, "I", hs.grid.resizeWindowShorter)
-- hotkey.bind(mashShift, "O", hs.grid.resizeWindowWider)

-- -- multi monitor
hotkey.bind(mashShift, "P", hs.grid.pushWindowPrevScreen)
hotkey.bind(mashShift, "N", hs.grid.pushWindowNextScreen)

-- Application focus hotkeys
local appShortcuts = {
   j = "Chrome",
   l = "Emacs",
   k = "iTerm",
   u = "Slack",
   i = "OmniFocus",
   o = "GoLand",
}

for key, appName in pairs(appShortcuts) do
  hotkey.bind(mash, key, function()
    local app = hs.application.get(appName)
    if app then app:activate() end
  end)
end

-- -- Work layout

-- function layoutForWork()
--   local screens = getSortedScreens()
--   local workLayout = {
--     {"Google Chrome", nil, screens[1], {x=0, y=0, w=1, h=1}, nil, nil},

--     {"Emacs", nil, screens[2], {x=0, y=0, w=1, h=1}, nil, nil},

--     {"Slack", nil, screens[3], {x=0, y=0, w=1, h=0.5}, nil, nil},
--     -- {"iTerm2", nil, screens[3], {x=0, y=0.5, w=1, h=0.5}, nil, nil},
--     {"Ghostty", nil, screens[3], {x=0, y=0.5, w=1, h=0.5}, nil, nil},
--     {"Messages", nil, screens[3], {x=0, y=0.5, w=1, h=0.5}, nil, nil},
--   }

--   hs.layout.apply(workLayout)
-- end

-- hotkey.bind(mashAll,"w", layoutForWork)

hs.alert.show("Config loaded")
