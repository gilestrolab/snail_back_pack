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
* Phototransistor that matches the wavelenght of the above LED.
* 68Ω resistor
* 100kΩ resistor
* Two rows strait PCB header
* One row PCB socket
* Thin wire
* Large garden snail
* Superglue
* Blu tack
* A large snail (An adult *Helix aspersa* should be perfect)

*The commercial references to the products I have been using can be found [here](./rs_numbers.md)*


Theory
-------------------
The heart of snails...

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

Fitting the circuit on the snail
--------------------------------------------------
This is probably the hardest part of the process.
An 5min online video demonstrates this part of the protocol step by step.

<iframe src="http://wl.figshare.com/articles/1294198/embed?show_title=1" width="568" height="502" frameborder="0">

</iframe>



Lead
--------------------------------------------------

1. Strip the tips of three long (>30cm) flexible and thin  wires.
2. Cut three columns of the PCB socket
3. Solder each wire to a different pin of the PCB header.
4. Plug the PCB socket on the pins D,E,F of the PCB header
5. Unsure you can tell which wire is for ground (pin D), and + (F).

Arduino
-------------------

1. Plug the + wire on digital pin 13.
2. Plug the ground wire on ground.
3. Plug the middle wire on analogue in 1.
4. Upload the code for this project to the Arduino
5. The LED light should start blinking quickly


