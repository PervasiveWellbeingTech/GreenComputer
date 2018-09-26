
import os

INTERVENTION_SPEED = 0.001
INTERVENTION_INTENSITY = 100

curr_temperature = 5700
increasing_temperature = False

time = 0

while True:
	#print 'Curr time: ', time

	time += 1

	if time % 80000000 == 0:
		print 'sh flux_changer.sh 750'
		os.system('sh flux_changer.sh 750')
		#os.system('sleep ' + str(INTERVENTION_SPEED))

	if time % 80000000 == 70000000:
		print 'sh flux_changer.sh 6000'
		os.system('sh flux_changer.sh 6000')
		#os.system('sleep ' + str(INTERVENTION_SPEED))

	# delta = 0.0
	# if curr_temperature < 2800:
	# 	increasing_temperature = True
	# if curr_temperature > 6400:
	# 	increasing_temperature = False
	# if increasing_temperature:
	# 	delta = INTERVENTION_INTENSITY
	# else:
	# 	delta = -1.0 * INTERVENTION_INTENSITY
	# curr_temperature += delta
	# curr_temperature = int(curr_temperature)

	# os.system('sh flux_changer.sh ' + str(curr_temperature))
	# os.system('sleep ' + str(INTERVENTION_SPEED))
