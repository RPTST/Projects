import RPi.GPIO as GPIO
import dht11
import time
from time import sleep
import datetime
from Adafruit_IO import *
import os

#from Adafruit_IO import Client
ADAFRUIT_IO_KEY = 'b3db5b83b37f4a1382202561b8f3842d'
aio = Client(ADAFRUIT_IO_KEY)

def setup():
    # initialize GPIO
    GPIO.setwarnings(False)
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(18,GPIO.OUT) # read data using pin 14

def gettmphum():
    instance = dht11.DHT11(pin=4)
    while True:
       result = instance.read()
       if result.is_valid():
          GPIO.output(18,GPIO.HIGH) #Set LED on
          print("Last valid input: " + str(datetime.datetime.now()))
          aio.send('temperature',result.temperature)
          print("Temperature: %d C" % result.temperature)
          print("Temperature: %d F" % ((result.temperature * 9/5)+32))
          print("Humidity: %d %%" % result.humidity)
          aio.send('Humidity', result.humidity)
          GPIO.output(18,GPIO.LOW) #Set LED off
          res = os.popen('vcgencmd measure_temp').readline()
          temp =(res.replace("temp=","").replace("'C\n",""))
          print("CPU temp is {0}".format(temp)) #Display temp reading
       time.sleep(60)

def destroy():
    GPIO.cleanup()                  # Release resource

if __name__ == '__main__':     # Program start from here
  setup()
  try:
    gettmphum()
  except KeyboardInterrupt:  # When 'Ctrl+C' is pressed, the child program destroy() will b$
    destroy()
