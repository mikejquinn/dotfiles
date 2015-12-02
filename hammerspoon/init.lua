-- Load extensions
local fnutils = require "hs.fnutils"
local grid = require "hs.grid"
local hotkey = require "hs.hotkey"
local screen = require "hs.screen"
local window = require "hs.window"

-- the window move animations are annoying
window.animationDuration = 0

local mash      = {"ctrl", "cmd"}
local mashAlt   = {"ctrl", "cmd", "alt"}
local mashShift = {"ctrl", "cmd", "shift"}
local mashAll   = {"ctrl", "cmd", "alt", "shift"}

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

local gridW = 6
local gridH = 8

grid.setGrid(hs.geometry.size(gridW, gridH))
   .setMargins(hs.geometry.point(0, 0))

-- move windows to discrete positions

local goleft = {x=0, y=0, w=gridW/2, h=gridH}
local goright = {x=gridW/2, y=0, w=gridW/2, h=gridH}
local gotop = {x=0, y=0, w=gridW, h=gridH/2}
local gobottom = {x=0, y=gridH/2, w=gridW, h=gridH/2}

local goupleft = {x=0, y=0, w=gridW/2, h=gridH/2}
local goupright = {x=gridW/2, y=0, w=gridW/2, h=gridH/2}
local godownleft = {x=0, y=gridH/2, w=gridW/2, h=gridH/2}
local godownright = {x=gridW/2, y=gridH/2, w=gridW/2, h=gridH/2}

local movements = {
   {mod=mashShift, key="H", fn=gridset(goleft)},
   {mod=mashShift, key="K", fn=gridset(gotop)},
   {mod=mashShift, key="J", fn=gridset(gobottom)},
   {mod=mashShift, key="L", fn=gridset(goright)},
   {mod=mashAll, key="U", fn=gridset(goupleft)},
   {mod=mashAll, key="I", fn=gridset(goupright)},
   {mod=mashAll, key="J", fn=gridset(godownleft)},
   {mod=mashAll, key="K", fn=gridset(godownright)},
   {mod=mashShift, key="M", fn=grid.maximizeWindow}
}

fnutils.each(movements, function(m)
  hotkey.bind(m.mod, m.key, m.fn)
end)

-- move windows
hotkey.bind(mashShift, "Left", hs.grid.pushWindowLeft)
hotkey.bind(mashShift, "Down", hs.grid.pushWindowDown)
hotkey.bind(mashShift, "Up", hs.grid.pushWindowUp)
hotkey.bind(mashShift, "Right", hs.grid.pushWindowRight)

-- resize windows
hotkey.bind(mashShift, "Y", hs.grid.resizeWindowThinner)
hotkey.bind(mashShift, "U", hs.grid.resizeWindowTaller)
hotkey.bind(mashShift, "I", hs.grid.resizeWindowShorter)
hotkey.bind(mashShift, "O", hs.grid.resizeWindowWider)

-- multi monitor
hotkey.bind(mashShift, "N", hs.grid.pushWindowNextScreen)
hotkey.bind(mashShift, "P", hs.grid.pushWindowPrevScreen)

-- Application focus hotkeys
local appShortcuts = {
   j = "Google Chrome",
   l = "Emacs",
   k = "iTerm",
   u = "GitX",
   i = "Adium",
   y = "Messages",
   o = "Things"
}

for key, appName in pairs(appShortcuts) do
  hotkey.bind(mash, key, function()
    local app = hs.application.get(appName)
    if app then app:activate() end
  end)
end

-- Reload hammerspoon config
hotkey.bind(mashAlt, "R", function()
  hs.reload()
end)

hs.alert.show("Config loaded")
