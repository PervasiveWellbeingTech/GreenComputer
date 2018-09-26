
# Tested on Mac OS X.
# Dependency: "brew install brightness"

import os

INTERVENTION_SPEED = 1
INTERVENTION_INTENSITY = 0.001

# Script for brightness.
curr_brightness = 0.99
increasing_brightness = False
while True:
	delta = 0.0
	if curr_brightness < 0.3:
		increasing_brightness = True
	if curr_brightness > 0.97:
		increasing_brightness = False
	if increasing_brightness:
		delta = INTERVENTION_INTENSITY
	else:
		delta = -1.0 * INTERVENTION_INTENSITY
	curr_brightness += delta
	print curr_brightness
	os.system("brightness " + str(curr_brightness))
	os.system("sleep " + str(INTERVENTION_SPEED))
