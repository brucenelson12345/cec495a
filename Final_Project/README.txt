
Created 12/6/2017
Updated 12/6/2017


Authors: Bruce Nelson, Joshua Van Deren, Blake Thacker


Input Files (make sure you have these):
detector.cpp
detector.py
Makefile
car_cascade.xml (optional)
gmon.out
plate_cascade.xml
plate001.avi
plate_detector.avi


Purpose:
  The purpose of this document is to explain our project scope and how to execute the project. The project is focused on
blurring license plates. This works by using a Haar Cascade Classifier to detect the license plates by making a bounding
box around the detected object, then applies a gaussian blur filter to make the license plate unreadeable. Both files are
automatically set to run the listed .avi files. However, these will work with any .avi video file and even single still
frames as well as live video. 

Execution:

C++: 
make clean
make
./detector

Python:
python detector.py
