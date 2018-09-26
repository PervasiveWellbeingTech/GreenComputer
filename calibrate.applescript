tell application "System Preferences"
    if it is running then
        quit
    end if
end tell

delay 0.2

activate application "System Preferences"
tell application "System Events"
    tell process "System Preferences"
        click button "Displays" of scroll area 1 of window "System Preferences"
        delay 1
        click radio button "Color" of tab group 1 of window "Built-in Retina Display"
        delay 1
        click button 3 of tab group 1 of window "Built-in Retina Display"
        delay 3
        click button 0 of window 0 whose title is "Display Calibrator Assistant"
    end tell
    delay 1
    quit application "System Preferences"
end tell 




(*set value of value indicator 1 of slider 1 of group 1 of tab group 1 of window "Built-in Retina Display" to 0.5*)
