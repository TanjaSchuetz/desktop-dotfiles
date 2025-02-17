local log = require('utilities.debug').log
local dump = require('utilities.debug').dump
log('Enter Module => ' .. ...)

local client, screen, tag = client, screen, tag

local awful = require('awful')
local beautiful = require('beautiful')

local top_panel = require('layout.top-panel')
local bottom_panel = require('layout.bottom-panel')
local left_panel = require('layout.left-panel')
local right_panel = require('layout.right-panel')

-- Create a wibox panel for each screen and add it
screen.connect_signal('request::desktop_decoration',
  function(s)
    s.top_panel = top_panel(s)
    s.bottom_panel = bottom_panel(s)
    s.left_panel = left_panel(s)
    s.right_panel = right_panel(s)
    s.right_panel_show_again = false
  end
)

-- Hide bars when app go fullscreen
local function update_bars_visibility()
  for s in screen do
    if s.selected_tag then
      local fullscreen = s.selected_tag.fullscreen_mode

      -- Order matter here for shadow
      s.top_panel.visible = not fullscreen
      s.bottom_panel.visible = not fullscreen
      s.left_panel.visible = not fullscreen

      if s.right_panel then
        if fullscreen and s.right_panel.visible then
          s.right_panel:toggle()
          s.right_panel_show_again = true
        elseif not fullscreen and not s.right_panel.visible and s.right_panel_show_again then
          s.right_panel:toggle()
          s.right_panel_show_again = false
        end
      end
    end
  end
end

tag.connect_signal('property::selected', function(t)
  update_bars_visibility()
end)

client.connect_signal('property::fullscreen',
  function(c)
    if c.first_tag then
      c.first_tag.fullscreen_mode = c.fullscreen
    end
    update_bars_visibility()
  end
)

client.connect_signal('unmanage',
  function(c)
    if c.fullscreen then
      c.screen.selected_tag.fullscreen_mode = false
      update_bars_visibility()
    end
  end
)
