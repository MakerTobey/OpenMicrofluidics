import piplates.MOTORplate as MOTOR
import RPi.GPIO as GPIO
import time
import os
import string
from Tkinter import *
import tkFont


MOTOR.RESET(0)
GPIO.cleanup()