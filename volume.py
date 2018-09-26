
# Tested on Mac OS X.

import os

INTERVENTION_SPEED = 1
INTERVENTION_INTENSITY = 0.1

# Script for brightness.
curr_volume = 0.0
increasing_volume = False
while True:
	delta = 0.0
	if curr_volume < 1:
		increasing_volume = True
	if curr_volume > 6.5:
		increasing_volume = False
	if increasing_volume:
		delta = INTERVENTION_INTENSITY
	else:
		delta = -1.0 * INTERVENTION_INTENSITY
	curr_volume += delta
	os.system("osascript -e 'set volume " + str(curr_volume) + "'")
	os.system("sleep " + str(INTERVENTION_SPEED))
