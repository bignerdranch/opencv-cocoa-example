# An example of using OpenCV in a Cocoa application

This is an example of using OpenCV in a Cocoa application. It is written in Objective-C++.

## To build this project

To run this example, you will need to install OpenCV. You can build it from the source, but you must have [CMake](https://cmake.org/download/).

Then clone the repo:

	git clone git@github.com:opencv/opencv.git
	
I built it in another directory which I named `OpenCVBuild`. And I had CMake configure/generate makefiles with the option WITH_OPENCL on (so that it will use hardware acceleration via OpenCL when possible.) Then:
	
	cd OpenCVBuild
	make
	sudo make install

Then the project should build and run.

## What does it do?

Click the button that says "Start Capture".  Ten times per second, the web cam will capture an image. That will be converted to a one-channel image that indicates where pixels are of a certain hue. (What hue? The hues on the balls in the 6-pack of Assorted Colors Franklin Wiffle Ball Softball. Where do you get these? I bought them at Target a couple of weeks ago, but no one seems to know anything about this particular product suddenly.)

Then, the system finds contours in the one-channel image.  Then it finds the smallest circle that will contain the largest contour.

Then, it draws the image and draws that minimal circle on it.




