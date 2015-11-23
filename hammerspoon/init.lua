-- Load extensions
local fnutils = require "hs.fnutils"
local grid = require "hs.grid"
local hotkey = require "hs.hotkey"
local screen = require "hs.screen"
local window = require "hs.window"

window.animationDuration = 0

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

local gridW = 6
local gridH = 8

local goleft = {x=0, y=0, w=gridW/2, h=gridH}
local goright = {x=gridW/2, y=0, w=gridW/2, h=gridH}
local gotop = {x=0, y=0, w=gridW, h=gridH/2}
local gobottom = {x=0, y=gridH/2, w=gridW, h=gridH/2}

grid.setGrid(hs.geometry.size(gridW, gridH))
   .setMargins(hs.geometry.point(0, 0))

local movements = {
   {mod={"ctrl", "cmd"}, key="Left", fn=gridset(goleft)},
   {mod={"ctrl", "cmd"}, key="Up", fn=gridset(gotop)},
   {mod={"ctrl", "cmd"}, key="Down", fn=gridset(gobottom)},
   {mod={"ctrl", "cmd"}, key="Right", fn=gridset(goright)},
   {mod={"ctrl", "cmd"}, key="m", fn=grid.maximizeWindow}
}

fnutils.each(movements, function(m)
  hotkey.bind(m.mod, m.key, m.fn)
end)

-- Application focus hotkeys

local hotkeys = {
   {key="J", name="Google Chrome"},
   {key="L", name="Emacs"},
   {key="K", name="iTerm"},
   {key="U", name="GitX"},
   {key="I", name="Adium"},
   {key="Y", name="Messages"},
   {key="O", name="Things"}
}

fnutils.each(hotkeys, function(k)
  hotkey.bind({"cmd", "ctrl"}, k.key, function()
    local app = hs.application.get(k.name)
    if app then app:activate() end
  end)
end)

hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
  hs.reload()
end)

hs.alert.show("Config loaded")
