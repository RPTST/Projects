import RPi.GPIO as GPIO
import dht11
import time
from time import sleep
import datetime
from Adafruit_IO import *
import os

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
          print("Last valid input: " + str(datetime.datetime.now())) # Display date and time
          aio.send('temperature',result.temperature) # Send temp info to adifruit IO
          print("Temperature: %d C" % result.temperature) # Display temp to C from DHT11
          print("Temperature: %d F" % ((result.temperature * 9/5)+32)) # Display temp to F from DHT11
          print("Humidity: %d %%" % result.humidity) # Display humidity from DHT11
          aio.send('Humidity', result.humidity) # Send humidity info to adifruit IO
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


def destroy():
    GPIO.cleanup()                  # Release resource

if __name__ == '__main__':     # Program start from here
  setup()
  try:
    gettmphum()
    tempalert()
  except KeyboardInterrupt:  # When 'Ctrl+C' is pressed the child program destroy() will run and do a cleanup of resources
    destroy()
