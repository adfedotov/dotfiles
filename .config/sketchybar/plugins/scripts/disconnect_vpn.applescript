#!/usr/bin/osascript

tell application "System Events" to tell process "GlobalProtect"
  click menu bar item 1 of menu bar 2
  set frontmost to true
  tell window 1
    set endpointDropdown to pop up button 1

    click endpointDropdown

    click menu item "0.0.0.0" of menu 1 of endpointDropdown

    delay 0.5

    if exists (first UI element whose title is "Connect") then
      click button "Connect"
    end if
  end tell
end tell
