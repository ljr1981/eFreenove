# eFreenove
Eiffel RPi4 eFreenove Tutorial

The Freenove Raspberry Pi 4 electronics breadboard kit rendered in pure Eiffel with wrapped C API using the wiringPi C library.

The examples wrap both C and C++ as needed. For C++, many example targets depend on external object and header files. You can find these references in the target Advanced->Externals tree node, where you will see both Object and Include nodes. The object nodes are direct references to necessary object files, whereas the includes are referencing enclosing folders. This allows Eiffel to managage which header files are needed (see Eiffel code external "use <my_header.h>" references).

# Coming Soon
The limits of the standard GPIO are quickly apparent. The GPIO can only connect with and operate a limited number of external devices and sensors. What is needed and wanted is a means to extend or expand the number of controllable sensors and devices. One such device under examination at the moment is the UniPi 1.1. See: https://www.unipi.technology/unipi-1-1-p36

# So Far
What has been wrapped and coded so far?

## Dependency
This code is designed to be compiled directly on a RaspberryPi 4B using Raspian. This code has not been tested on a cross-compiler.

There are direct full-path dependecies in the ECF file that you will need to modify in order to get this code to work properly. You will also need the Freenove code and breadboarding kit in order to make the example projects code work as-is. However, you can use certain elements like {WP_BASE} (see below) for any RaspberryPi 4B GPIO solutions. Some of the C++ code can be reused as-is without needing the Freenove kit as well.

## WiringPi C API
For electronic components that can be controlled through the C API of the WiringPi library, the {WP_BASE} class contains a host of functionally wrapped C externals. The primary advantage of using (referencing) or inheriting from {WP_BASE} is that the `default_create` creation procedure automatically handles the required initialization and setup of the WiringPi system. The very act of creating an instance of {WP_BASE} (in any way—directly or through inheritance) will cause this job to be handled for you. There is no need for you to manually perform initialization and setup.

There are wrappers for many of the basic functions of the WiringPi library. You can utilize these as you have need. No further wrapping code or setup is required.

## Chapter 1 - LED Blink
Using the Freenove breadboard kit, cause an LED to blink on-and-off several times.

## Chapter 2 - Button & LED
Using the Freenove breadboard kit, cause an LED to blink on-and-off when a button is pressed.

## Chapter 16 - Stepper Motor
Using the Freenove breadboard kit, cause a stepper-motor to rotate in different directions for various degrees of rotation.

## Chapter 21 - DHT11 Temp/Humidity Sensor
Using the Freenove breadboard kit, cause a DHT11 to sense temperature and humidity. The sensor sends data in degrees-Celsius, but there is a conversion feature so you can get the readings in Fahrenheit as well.

## Chapter 24 - Ultrasonic Ranging Module
Using the Freenove breadboard kit, cause an HR-SC04 ultrasonic ranging sensor to take 1_000 range readings (about 60 seconds worth of readings). The sensor is good from 2-500 centimeters (about 16 feet) on a 15-degree angle with a resolution of about 3 mm.

## Chapter 25 - Attitude Sensor
Using the Freenove breadboard kit, cause an Attitude Sensor to give real-time readings of accelleration and gyroscopic angle in all three axes (X, Y, and Z). Accelleration will be measured in G-force and gyroscopic angles in degrees. Actually, you'll need to convert n/16,384 for percentage of 0-360 degrees.
