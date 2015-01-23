Snail heart rate monitor
========================

This protocol describes how to build an inexpensive and lightweight monitor of snail hear rate.
The principle is to send light from one side of the shell with red LED light, and reccord the "shadow" of the heart using a phototransistor, from the other side.
The monitor is very small and can be fixed onto the shell of the animal.


Parts needed
--------------------
All of the components are very inexpensive and can be ordered from RS.

* A bright red LED (http://my.rs-online.com/web/p/visible-leds/8106850/)
* A phototransistor (http://uk.rs-online.com/web/p/phototransistors/6548873/)
* A 68ohm resistor (or a 22ohm one for a 3V circuit)
* A 100kohm resistor
* PCB header (http://uk.rs-online.com/web/p/pcb-headers/6813026/)
* PCB Socket (http://uk.rs-online.com/web/p/pcb-sockets/6813048/)
* Some thin wire, solder, and a soldering iron.


The circuit
----------------------
The circuit in itself is really simple:




Soldering things together
----------------------
The goal is to build a sort of saddle that could rest on the shell.
Viewed from the top, the LED should be on the left side, the PCB header in the middle,
and the phototransistor on the right:


The LED
--------------

Do not forget that LEDs are polar. For this type of small LEDs, you can tell cathode and anode apart by looking at the part of the top of the LED.
You should see two compartments. **The anode is at the bottom of the largest** (see http://docs-asia.electrocomponents.com/webdocs/12d3/0900766b812d38d3.pdf).
We are going to power the LED with 5v, so we need to add a 68kohm resistor (or 22ohm for a 3V board).
We can solder directly the **leg of the resistor to the anode**, and a **thin wire on the cathode**.
The lenght of the wire depends on the size of the snailshell.
The result should look like this:



The Phototransistor
--------------

We are going to reccord how much the phototransistor lets current go though, which is function of light intensity.
To do this, we can wire one side to the power. On the other side, in parallel, the analog input and, through a 100k resistor, the ground.
This looks like this:




The PCB header
--------------

The idea is to be able to connect and disconect conveniently the circuit to the arduino by fixing the header on the shell and pluggin the wires, though the socket, on demand.
I suggest to cut the header in order to keep only three pins on each side (which is more than needed for our purpose).
So, A schematic from the bottom could look like that:

```
A ---   --- D
B ---   --- E
C ---   --- F
```

We are going to solder the LED anode and cathode to A and C, respecively.
Then, the + side of the phototransistor to D, the ground to F, and the analog output to E.
In addition, we will solder A and D (both +), as well as D and F (both ground), together.
The finished product should looks like this:

```
|--R1--- A --------- D ---PT---|
|        B ---   --- E --------|
|--LED-- C --------- F ---R2---|
```













 
 


