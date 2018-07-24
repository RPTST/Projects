#!/usr/bin/python

import RPi.GPIO as GPIO
import time
import subprocess, os
import signal
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
RearView_Switch = 14  # pin 18
Brightness_Switch = 15 # pin 16
#Extra_Switch = 1  # pin 3
GPIO.setup(RearView_Switch,GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(Brightness_Switch,GPIO.IN, pull_up_down=GPIO.PUD_UP)

print "  Press Ctrl & C to Quit"

try:
    
   run = 0
   bright = 0
   while True :
      	time.sleep(0.1)
	#the next four blocks are used for toggeling between the camera views.
      	if GPIO.input(RearView_Switch)==0 and run == 0:
         	print "  Started Full Screen"
         	rpistr = "raspivid -t 0 -vf -h 480 -w 800"
         	p=subprocess.Popen(rpistr,shell=True, preexec_fn=os.setsid)
         	run = 1
         	while GPIO.input(RearView_Switch)==0:
             		time.sleep(0.1)

      	if GPIO.input(RearView_Switch)==0 and run == 1:
         	os.killpg(p.pid, signal.SIGTERM)
		print "  Started Full Screen Transparent"
         	rpistr = "raspivid -t 0 -vf -op 128 -h 480 -w 800"
         	p=subprocess.Popen(rpistr,shell=True, preexec_fn=os.setsid)
         	run = 2
         	while GPIO.input(RearView_Switch)==0:
             		time.sleep(0.1)

      	if GPIO.input(RearView_Switch)==0 and run == 2:
         	os.killpg(p.pid, signal.SIGTERM)
		print "  Started PIP Right side"
         	rpistr = "raspivid -t 0 -vf -p 350,1,480,320"
         	p=subprocess.Popen(rpistr,shell=True, preexec_fn=os.setsid)
         	run = 3
         	while GPIO.input(RearView_Switch)==0:
             		time.sleep(0.1)

      	if GPIO.input(RearView_Switch)==0 and run == 3:
         	print "  Stopped " 
         	run = 0
         	os.killpg(p.pid, signal.SIGTERM)
         	while GPIO.input(RearView_Switch)==0:
            		time.sleep(0.1)
	#These next three blocks toggle between the three brightness settings.
      	if GPIO.input(Brightness_Switch)==0 and bright == 0:
         	#os.killpg(p.pid, signal.SIGTERM)
		print "Setting Brightness to 255"
         	subprocess.call ("/usr/local/bin/backlight.sh 255", shell=True)
         	#p=subprocess.Popen(rpistr,shell=True, preexec_fn=os.setsid)
         	bright = 1
         	while GPIO.input(Brightness_Switch)==0:
             		time.sleep(0.1)

      	if GPIO.input(Brightness_Switch)==0 and bright == 1:
         	#os.killpg(p.pid, signal.SIGTERM)
		print "Setting Brightness to 128"
         	subprocess.call ("/usr/local/bin/backlight.sh 128", shell=True)
         	#p=subprocess.Popen(rpistr,shell=True, preexec_fn=os.setsid)
         	bright = 2
         	while GPIO.input(Brightness_Switch)==0:
             		time.sleep(0.1)

      	if GPIO.input(Brightness_Switch)==0 and bright == 2:
         	#os.killpg(p.pid, signal.SIGTERM)
		print "Setting Brightness to 20"
         	subprocess.call ("/usr/local/bin/backlight.sh 20", shell=True)
         	#p=subprocess.Popen(rpistr,shell=True, preexec_fn=os.setsid)
         	bright = 0
         	while GPIO.input(Brightness_Switch)==0:
             		time.sleep(0.1)

       
	
except KeyboardInterrupt:
  print "  Quit"
  GPIO.cleanup() 