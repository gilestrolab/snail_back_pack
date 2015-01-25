import serial
import os
import time
import argparse
import numpy as np
from collections import deque
import pygame


_BAUD = 57600
_N_POINTS = 200
DISPLAY_WIDTH, DISPLAY_HEIGHT = 1200, 520


def plot(screen, time_queue, value_queue, scale=True):
    
    t = np.array(list(time_queue))
    values = np.array(list(value_queue), dtype=np.float32)
    
    
    # we scale the signal so that all vallue lie between 0 and 1 
    new_y =  values - np.min(values,0)
    
    mmax = np.max(new_y,0)
    
    # we ensure no division by 0 will happen
    if mmax == 0:
        return
        
    new_y /= np.max(new_y,0)
    
    
    new_y *= DISPLAY_HEIGHT
    new_y = DISPLAY_HEIGHT - new_y
    
    #we express time as a proportion of the window size
    
    new_t = t - t[0]
    new_t *= (DISPLAY_WIDTH/float(window_size))

    screen.fill((0,0,0))
    pts = [(int(x),int(y)) for x,y in zip(new_t, new_y )]
    pygame.draw.lines(screen, (255, 255, 0),False, pts, 3)
    pygame.display.flip()
    
     
if __name__ == "__main__":
    
    
    # parsing command line arguments
    parser = argparse.ArgumentParser()
    # TODO windows compat default port !
    parser.add_argument('--port', help='port', type=str, default="/dev/ttyACM0")
    parser.add_argument('--vws', help='The duration of the viewing window (s)', type=int, default=20)
    parser.add_argument('--out', help='An optional output file', type=str, default=os.devnull)

    args = parser.parse_args()
    arg_dict = vars(args)
    window_size = arg_dict["vws"]
    out_file = arg_dict["out"]
    
    # Here we open the serial port
    serial_port = serial.Serial(arg_dict["port"], _BAUD, timeout=2)
    
    # We start a timer using the real time from the operating system
    start = time.time()
    
    # Then we make two queues (FIFO containers); one for the values and one for the time stamps.
    time_queue, value_queue = deque(), deque()

    # We need to initialise pygame
    pygame.init()
    # We build the pygame window before we can start painting inside 
    
    display = pygame.display.set_mode((DISPLAY_WIDTH, DISPLAY_HEIGHT))
    
    # The `with statement` will ensure the file is closed if an exception happens
    
    with open(out_file, "w") as f:
        # infinite loop
        while True:
            # we read a line from serial port and remove any `\r` and `\n` character
            line = serial_port.readline().rstrip()
            # just after, we get a time stamp
            now = time.time()
            # we try to convert the line to an integer value
            try:
                value =  int(line)
            # if something goes wrong, we do not stop, but we print the error message
            except ValueError as e:
                print e
                continue
            
            # the relative time from the start of the program is `dt`
            dt =  now - start
            
            # We append relative  time and value to their respective queues
            time_queue.append(dt)
            value_queue.append(value)
            
            # we wait to have at least five points AND three seconds of data
            if time_queue[-1] < 3 or len(time_queue) < 5:
                continue

            # Now, we remove/forget from the queues any value older than the window size
            # this way we will only plot the last n (default 20) seconds of data
            while time_queue[-1] - time_queue[0] > window_size:
                time_queue.popleft()
                value_queue.popleft()
                
            # Now we plot the values
            plot(display, time_queue, value_queue)
            
            # So that the program stops if we close the window
            for et in pygame.event.get():
                if et.type == pygame.QUIT:
                    raise KeyboardInterrupt
            

