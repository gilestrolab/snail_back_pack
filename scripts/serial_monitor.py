import serial
import os
import time
import argparse
import numpy as np
from scipy.interpolate import interp1d
from collections import deque
import pygame


_BAUD = 57600
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
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('--port', help='port', type=str, default="/dev/ttyACM0")
    parser.add_argument('--vws', help='viewing window size (s)', type=int, default=20)
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

    width, height = 1500, 900
    screen = pygame.display.set_mode((width, height))


    with open(arg_dict["out"], "w") as f:
        while True:
            line = serial_port.readline().rstrip()

            if line == "":
                continue
            try:
                values =  [int(c) for c in line.split(",") if c]
                #~ int_value = int(line.rstrip())
                values = np.array(values, dtype=np.float32)
                
            except ValueError as e:
                print e
                continue
            try:
                now = time.time()
                dt =  now - start
#~ 
                time_queue.append(dt)
                value_queue.append(values)
            
                if time_queue[-1] < 3 or len(time_queue) < 10:
                    continue

                while time_queue[-1] - time_queue[0] > window_size:
                    time_queue.popleft()
                    value_queue.popleft()
                
            
            
                t = np.array(list(time_queue))
                y = np.array(list(value_queue))
            
                if y.dtype == object:
                    time_queue = deque()
                    value_queue = deque()
                    continue
            
                new_t = t
                new_y = np.copy(y)

                if scale:
                
                
                    new_y -= np.min(new_y,0)
                    mmax = np.max(new_y,0)
                    if np.any(mmax == 0):
                        continue
                    new_y /= np.max(new_y,0)
            
            
                new_y *= height
            
                new_y = height - new_y

                new_t -= new_t[0]
                new_t *= (width/float(window_size))
            
            
                screen.fill((0,0,0))
            
                n_series = y.shape[1]
                for k in range(n_series):
                    y_coords = new_y[:,k]

                    y_coords /= float(n_series)
                    y_coords += (k * height / float(n_series))
                
                    pts = [(int(x),int(y)) for x,y in zip(new_t, y_coords )]
            
                    pygame.draw.lines(screen, colour_map[k],False, pts, 3)
                    hline =[
                        (0,(k * height / float(n_series))),
                        (width,(k * height / float(n_series)))]
                
                
                    pygame.draw.lines(screen, colour_map[k],False, pts, 3)
                    pygame.draw.aalines(screen, (255,255,255),False, hline, 3)
            
                pygame.display.flip()
            except:            
                continue
            out_line = "%f, %s\n" % (now,line)
            f.write(out_line)
            print out_line





            

