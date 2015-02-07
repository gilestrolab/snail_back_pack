Optical snail heart rate monitor
==================================

Monitoring physiological variables is...
This project describes an inexpensive and non-invasive device to monitor hear rate of snails.


Project aim
--------------------
The aim of this project is to build a small device that can be carried by a garden snail *Helix aspersa* and would monitor its heart rate.
When sending red light though the bottom of the shell, the moving heart of the snail can be observed.
From this observation, the goal is to fit a low power to red LED on one side of the shell whilst recording the intensity of the transmitted light, using a phototransistor, from the other side.

In order to keep the device lightweight, thin wires will be used to convey analogue signal to an Arduino Uno. Then, the serial port will be used to communicate data to a computer which will diplay the signal in real time using an `python` script.

In order to save energy and reduce the heat genreated by the LED, this project will be power by a digital pin.
This way, the circuit can be powered only shortly before reading from the analogue pin and turned off immediately after.

Technique used
-----------------------

* Reading a phototransistor
* Using a digital pin to drive power
* Oversampling signal to improve resolution of A/D conversion.
* Real time data visualisation using `python` and `pyserial` and `pygame`

Materials
--------------------

* Arduino Uno
* Computer
* Low voltage (3V) bright red LED. Ideally, a small surface mounted one with a flat lense and a wide (>100°) angle.
* Phototransistor (PT) that matches the wavelenght of the above LED.
* 68Ω resistor
* 100kΩ resistor
* Two rows strait PCB header
* One row PCB socket
* Thin wire
* Large garden snail
* Superglue
* Blu tack
* A large snail (An adult *Helix aspersa* should be perfect)

@edbaker -> you will probably want to change the links to your cloned/reorganised version here

*The commercial references to the products I have been using can be found at (https://github.com/gilestrolab/snail_back_pack/blob/master/protocols/rs_numbers.md)*

Code Download
-------------------------------

@edbaker same here
* Arduino code ([https://github.com/gilestrolab/snail_back_pack/blob/master/arduino_prototypes/sparse_phototransistor/sparse_phototransistor.ino])
* Python code ([https://github.com/gilestrolab/snail_back_pack/blob/master/scripts/serial_monitor.py])

Supporting Materials
-----------------------

* Video of the protocol ([http://dx.doi.org/10.6084/m9.figshare.1294198])


Theory
-------------------
TODO 
About the heart of snails...
The fact that it can be recorded through ECG (refs?)

We are going to power the LED with 5v, so we need to add a 68Ω resistor (or 22Ω for a 3V board).
Simultaneously, we will record how much current leaks from the phototransistor, which is function of light intensity.
To do this, we can wire one side to the power. On the other side, in parallel, the analog input and, through a 100kΩ resistor, the ground.


The circuit
----------------------
The circuit in itself is really simple:
![circuit schematic](./img/circuit.png)

Note that the **digital pin 13 is used instead of the 5v pin**. 
This way, we can turn the circuit on and off from the arduino.


Putting it together
----------------------
The end goal is to build a sort of saddle that can be glued onto the shell, and then plugged to a wire for recording purposes.
View from the bottom, the final product could look like this:

![Saddle, bottom view](./img/fig1.jpg)

And from the top:
![Saddle, top view](./img/fig2.jpg)

In both figures, '`AN`' is for the analogue pin.
General instruction
-----------------------
 
We will use the leads of the resistors, and some wire, as a skeleton for our device.
Therefore, we will wait until the end to cut them.
Soldering the LED and the phototransistor can reveal challenging as both parts are very small.
So, it is recommended to hold them firmly, for instance, using "helping hands".
It is easy to forget that the **LED and PT should both face downward** as the light will be transmitted through the shell. 


The LED
--------------

1. Before starting, ensure you can tell cathode and anode of the LED apart. Most surface mounted LEDs will have an indication such as a small chip on the `+` side.
2. Solder directly one leg of the 68Ω resistor to the anode of the LED.
3. Cut a short wire (1cm), strip and twist its tip.
4. Solder one extremity of the wire to the cathode.

The result should look like this:



The Phototransistor
---------------------------

1. As for the LED, ensure you know the polarity of your component.
2. Cut two short wires (1cm), strip and twist there tips.
3. Solder one extremity of a wire to the anode.
4. Solder directly one leg of the 68ohm resistor to the cathode. Leve some space between the anode and the resistor to solder the second wire.
5. Solder the tip of the second wire onto the leg of the resistor, between the resistor and the phototransistor.


Assembling on the PCB header
--------------------------------------------------

1. We cut the PCB headed to leave only tree columns (i.e. 6pins). From a bottom-up view, let us label the pins:

```
A ---   --- D
B ---   --- E
C ---   --- F
```


2. Solder the wire connected to the LED light on A
3. Solder the leg of the resistor connected to the LED on C **and F**.
4. Solder the wire connected the anode of the phototransistor to F
5. Solder the leg of the resistor connected to the phototransistor on A **and D**.
6. Solder the second wire of the phototransistor on E.

Lead
--------------------------------------------------

1. Strip the tips of three long (>30cm) flexible and thin  wires.
2. Cut three columns of the PCB socket.
3. Solder each wire to a different pin of the PCB header.
4. Plug the PCB socket on the pins D,E,F of the PCB header.
5. Unsure you can tell which wire is for ground (pin D), and + (F).



Arduino
-------------------

1. Plug the + wire on digital pin 13 — or 5v if you want constant light (see 'Fitting the Circuit' section below).
2. Plug the ground wire on ground.
3. Plug the middle wire on analogue in 1.
4. Upload the code for this project to the Arduino.
5. The LED light should start blinking quickly.




Fitting the Circuit
--------------------------------------------------
This is probably the hardest part of the process.
For this reason, a 4min online video demonstrates this part of the protocol step by step (see 'Supporting Material' section above).

The main steps are:

1. Protect the animal by putting tissue paper on the opening of the shell.
2. Plug the Arduino to the USB port of your computer.
3. Run the `python` program (see 'Code Download' section above). A window should appear and plot the signal in real time (see section '???' below).
4. Plug the circuit on. *Use the 5v pin* instead of the digital pin as it will allow you to see the heart beat much better.
5. At this stage, you should be able to test the circuit by moving objects between PT and LED, and observe variation in the data displayed by the `python` program. 
4. Move the LED on the shell until you see the beating heart.
5. Use blu tac to maintain the circuit on the shell and assess the quality of the signal displayed on your screen.
6. When the signal is satisfying (sharp oscillations of large amplitude), glue PT and LED to the shell.
7. Unplug the circuit, interrupt the `python` program, and wait for the glue to dry.
8. Plug the circuit. This time, **use the analogue pin** as opposed to the 5v.
9. Run the `python` program. In addition to simply disply heart rate, the data can be saved to a text file using the `--out` option  (see section '???' below).  

**Important Notes:**

* Use as little glue as possible and avoid touching the foot of the animal with any glue. If you have concerns about toxicity, you may consider alternatives such as dental cement. 
* In the video, the PT is close to the heart whilst the LED is on the opposite side. However, the invert setting also works, and may give more reliable result for long term monitoring. 


