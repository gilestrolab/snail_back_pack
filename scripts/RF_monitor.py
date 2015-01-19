from __future__ import print_function
import serial
import os
import time
import argparse
import numpy as np
from scipy.interpolate import interp1d
from collections import deque
import pygame
import argparse




_BAUD = 9600
_N_POINTS = 200
colour_map = [
            (255,0,0),
            (0,255,0),
            (0,0,255),
            (0,255,255),
            (255,255,0),
            (255,0,255)
            ]

if __name__ == "__main__":


    serial_port = serial.Serial("/dev/ttyACM0", _BAUD, timeout=2)

    print("hello")
    while True:
        line = serial_port.readline().rstrip()

        print(line)
