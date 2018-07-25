import RPi.GPIO as GPIO
import dht11
import time
import datetime

# initialize GPIO
LED1_GPIO_PIN = 18
GPIO.setmode(GPIO.BCM)

# read data using pin 14
instance = dht11.DHT11(pin=4)

#GPIO Setup
GPIO.setup(LED1_GPIO_PIN, GPIO.OUT)


while True:
    GPIO.output(LED1_GPIO_PIN, GPIO.HIGH)
    result = instance.read()
    if result.is_valid():
        print("Last valid input: " + str(datetime.datetime.now()))
        print("Temperature: %d C" % result.temperature)
        print("Temperature: %d F" % ((result.temperature * 9/5)+32))
        print("Humidity: %d %%" % result.humidity)
    GPIO.output(LED1_GPIO_PIN, GPIO.LOW)
    time.sleep(1)
