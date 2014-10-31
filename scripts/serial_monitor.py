import serial
import os
import time
import argparse
import numpy as np
from scipy.interpolate import interp1d
from collections import deque
import pygame


_BAUD = 9600
_N_POINTS = 200

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('--port', help='port', type=str, default="/dev/ttyACM0")
    parser.add_argument('--vws', help='viewing window size (s)', type=int, default=10)
    parser.add_argument('--out', help='an optional output file', type=str, default=os.devnull)
    # parser.add_argument('--print', help='stdout?', type=bool, default=False)

    scale = True
    args = parser.parse_args()

    arg_dict = vars(args)


    window_size = arg_dict["vws"]

    serial_port = serial.Serial(arg_dict["port"], _BAUD, timeout=2)
    start = time.time()

    time_queue = deque()
    value_queue = deque()


    pygame.init()

    width, height = 1000, 500
    screen = pygame.display.set_mode((width, height))


    with open(arg_dict["out"], "w") as f:
        while True:

            line = serial_port.readline()
            print line
            try:
                int_value = int(line.rstrip())
            except ValueError as e:
                print e
                continue
            value = int_value  / float(2 ** 10)

            dt = time.time() -start

            time_queue.append(dt)
            value_queue.append(value)
            if len(time_queue) < 10:
                continue
            while time_queue[-1] - time_queue[0] > window_size:
                time_queue.popleft()
                value_queue.popleft()

            t = np.array(time_queue)
            y = np.array(value_queue)

            ifun = interp1d(t,y, "linear")
            new_t = np.linspace(t[0], t[-1], num=_N_POINTS)

            new_t = new_t
            new_y = ifun(new_t)



            if scale:
                new_y -= np.min(new_y)
                new_y /= np.max(new_y)

            new_y *= height
            new_y = height - new_y

            new_t -= new_t[0]
            new_t *= (width/float(window_size))
            pts = [(int(x),int(y)) for x,y in zip(new_t, new_y)]
            screen.fill((0,0,0))
            pygame.draw.lines(screen, (255,255,0),False, pts, 3)
            pygame.display.flip()
            f.write("%f, %f\n" % (dt,value))
            if True:
                print "%02f, %i" % (np.round(dt,2),int_value)


