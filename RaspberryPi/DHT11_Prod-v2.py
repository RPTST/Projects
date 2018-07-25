import RPi.GPIO as GPIO
import dht11
import time
from time import sleep
import datetime
import pygame
import sys
from time import strftime
from Adafruit_IO import *
import os

#Set the framebuffer device to be the TFT
os.environ["SDL_FBDEV"] = "/dev/fb1"

#from Adafruit_IO import Client
ADAFRUIT_IO_KEY = 'key'
aio = Client(ADAFRUIT_IO_KEY)

def setup():
    # initialize GPIO and board
    GPIO.setwarnings(False)
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(18,GPIO.OUT) # Sets the LED for pin 18

def gettmphum():
    instance = dht11.DHT11(pin=4) # Read data using pin 4
    while True:
       result = instance.read()
       if result.is_valid():
          print("\033[1;37;40m Time  \n")
          print("Last valid input: " + str(datetime.datetime.now())) # Display date and time
          print("\033[1;32;40m Temp  \n")
          aio.send(' temperature', result.temperature) # Send temp info to adifruit IO
          print("Temperature: %d C" % result.temperature) # Display temp to C from DHT11
          print("Temperature: %d F" % ((result.temperature * 9/5)+32)) # Display temp to F from DHT11
          print("\033[1;33;40m Humidity  \n")
          print("Humidity: %d %%" % result.humidity) # Display humidity from DHT11
          aio.send('Humidity', result.humidity) # Send humidity info to adifruit IO
          print("\034[1;33;40m CPU  \n")
          res = os.popen('vcgencmd measure_temp').readline() # Read the temp info from the RPI OS
          temp =(res.replace("temp=","").replace("'C\n","")) # Set the variable for temp
          print("CPU temp is {0}".format(temp)) #Display CPU temp reading
       time.sleep(120)

def tempalert():
    instance = dht11.DHT11(pin=4) # Read data using pin 4
    while True:
       result = instance.read()
       if result.temperature > 40:
          GPIO.output(18,GPIO.HIGH) # Set LED on
       else
          GPIO.output(18,GPIO.LOW) # Set LED off
       time.sleep(60)

def tftRPIInfo():
    #Set the framebuffer device to be the TFT
    os.environ["SDL_FBDEV"] = "/dev/fb1"

    #Setup pygame display
    pygame.init()
    pygame.mouse.set_visible(0)
    screen = pygame.display.set_mode(size)

#    """Used to display date and time on the TFT"""
    screen.fill((0,0,0))
    font = pygame.font.Font(None, 50)
    now=time.localtime()
 
    for setting in [("%H:%M:%S",60),("%d  %b",10)] :
         timeformat,dim=setting
         currentTimeLine = strftime(timeformat, now)
         text = font.render(currentTimeLine, 0, (0,250,150))
         Surf = pygame.transform.rotate(text, -90)
         screen.blit(Surf,(dim,20))

    displayText('Temp', 30, 1, (200,200,1), True )
    displayText(getFeedVal("71") + "C", 50, 2, (150,150,255), False )
    pygame.display.flip()
    time.sleep(10)
 
    displayText('Out. Humidity', 30, 1, (200,200,1), True )
    displayText(getFeedVal("70") + "%", 50, 2, (150,150,255), False )
    pygame.display.flip()
    time.sleep(10)

def destroy():
    GPIO.cleanup()                  # Release resource

if __name__ == '__main__':     # Program start from here
  setup()
  try:
    gettmphum()
    tempalert()
    tftRPIInfo()
  except KeyboardInterrupt:  # When 'Ctrl+C' is pressed the child program destroy() will run and do a cleanup of resources
    destroy()
