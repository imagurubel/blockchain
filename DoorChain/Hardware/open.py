# External module imports
import RPi.GPIO as GPIO
import time
import sys

# Pin Definitons:
ledPin = int(sys.argv[1])

# Pin Setup:
GPIO.setmode(GPIO.BCM) # Broadcom pin-numbering scheme
GPIO.setup(ledPin, GPIO.OUT) # LED pin set as output

# Initial state for LEDs:
GPIO.output(ledPin, GPIO.LOW)
try:
   GPIO.output(ledPin, GPIO.HIGH)
   time.sleep(10)
   GPIO.cleanup() # cleanup all GPIO
except KeyboardInterrupt: # If CTRL+C is pressed, exit cleanly:
   GPIO.cleanup() # cleanup all GPIO

