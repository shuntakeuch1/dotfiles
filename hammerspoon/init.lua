-- hs.window.animationDuration = 0
-- units = {
--   right30       = { x = 0.70, y = 0.00, w = 0.30, h = 1.00 },
--   right70       = { x = 0.30, y = 0.00, w = 0.70, h = 1.00 },
--   left70        = { x = 0.00, y = 0.00, w = 0.70, h = 1.00 },
--   left30        = { x = 0.00, y = 0.00, w = 0.30, h = 1.00 },
--   top50         = { x = 0.00, y = 0.00, w = 1.00, h = 0.50 },
--   bot50         = { x = 0.00, y = 0.50, w = 1.00, h = 0.50 },
--   upright30     = { x = 0.70, y = 0.00, w = 0.30, h = 0.50 },
--   botright30    = { x = 0.70, y = 0.50, w = 0.30, h = 0.50 },
--   upleft70      = { x = 0.00, y = 0.00, w = 0.70, h = 0.50 },
--   botleft70     = { x = 0.00, y = 0.50, w = 0.70, h = 0.50 },
--   maximum       = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 }
-- }

-- mash = { 'shift', 'ctrl', 'cmd' }
-- hs.hotkey.bind(mash, 'l', function() hs.window.focusedWindow():move(units.right30,    nil, true) end)
-- hs.hotkey.bind(mash, 'h', function() hs.window.focusedWindow():move(units.left70,     nil, true) end)
-- hs.hotkey.bind(mash, 'k', function() hs.window.focusedWindow():move(units.top50,      nil, true) end)
-- hs.hotkey.bind(mash, 'j', function() hs.window.focusedWindow():move(units.bot50,      nil, true) end)
-- hs.hotkey.bind(mash, ']', function() hs.window.focusedWindow():move(units.upright30,  nil, true) end)
-- hs.hotkey.bind(mash, '[', function() hs.window.focusedWindow():move(units.upleft70,   nil, true) end)
-- hs.hotkey.bind(mash, ';', function() hs.window.focusedWindow():move(units.botleft70,  nil, true) end)
-- hs.hotkey.bind(mash, "'", function() hs.window.focusedWindow():move(units.botright30, nil, true) end)
-- hs.hotkey.bind(mash, 'm', function() hs.window.focusedWindow():move(units.maximum,    nil, true) end)

-- hs.loadSpoon("SpoonInstall")

-- spoon.SpoonInstall.repos.ShiftIt = {
--    url = "https://github.com/peterklijn/hammerspoon-shiftit",
--    desc = "ShiftIt spoon repository",
--    branch = "master",
-- }

-- spoon.SpoonInstall:andUse("ShiftIt", { repo = "ShiftIt" })

hs.loadSpoon("ShiftIt")
spoon.ShiftIt:bindHotkeys({})

spoon.ShiftIt:bindHotkeys({
  left = {{ 'ctrl', 'alt' }, 'left' },
  right = {{ 'ctrl', 'alt' }, 'right' },
  maximum = {{ 'ctrl',  'cmd' }, 'up' },
  nextScreen = {{ 'ctrl', 'cmd' }, 'n' },
});
--  Default
-- {
--   left = {{ 'ctrl', 'alt', 'cmd' }, 'left' },
--   right = {{ 'ctrl', 'alt', 'cmd' }, 'right' },
--   up = {{ 'ctrl', 'alt', 'cmd' }, 'up' },
--   down = {{ 'ctrl', 'alt', 'cmd' }, 'down' },
--   upleft = {{ 'ctrl', 'alt', 'cmd' }, '1' },
--   upright = {{ 'ctrl', 'alt', 'cmd' }, '2' },
--   botleft = {{ 'ctrl', 'alt', 'cmd' }, '3' },
--   botright = {{ 'ctrl', 'alt', 'cmd' }, '4' },
--   maximum = {{ 'ctrl', 'alt', 'cmd' }, 'm' },
--   toggleFullScreen = {{ 'ctrl', 'alt', 'cmd' }, 'f' },
--   toggleZoom = {{ 'ctrl', 'alt', 'cmd' }, 'z' },
--   center = {{ 'ctrl', 'alt', 'cmd' }, 'c' },
--   nextScreen = {{ 'ctrl', 'alt', 'cmd' }, 'n' },
--   previousScreen = {{ 'ctrl', 'alt', 'cmd' }, 'p' },
--   resizeOut = {{ 'ctrl', 'alt', 'cmd' }, '=' },
--   resizeIn = {{ 'ctrl', 'alt', 'cmd' }, '-' }
-- }
