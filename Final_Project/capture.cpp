/*
CEC 495A Computer Vision Img Process
Final Project - Blurs License Plates

Authors: Bruce Nelson, Josh, Blake

Input Files:
capture.cpp
Makefile
plate_cascade.xml

Description:
    The purpose of this program is to blur license plates in either a 
video file or a live-video feed. The program works currently only for "Russian"
license plates due to the uniqueness of the license plates that consist of the
Russian flag, making it easy to detect the license plate along with it dimensions.
Once a license plate is detected, a bounding box is create around the coordinates
encompassing the license plate inside the rectangle. Then a gaussian blur is
applied to blur the license plate and make it unreadable. This will work for 
detecting/blurring one license plate at a time or multiple license plates at a 
time.
    The program uses C++ as the core programming language along iwth OpenCV and
incoporates the standard video and image libraries along with object detection.
The detection uses Haar Cascades for object detection. This works by creating a
cascade file that stores the information for the partiular object. In the example
of license plates, the cascade file consist of data identifying positives of a 
license plate and negatives of what is not a license plate. The data within these
sets work off of edge-like features that determine which edges closely resembles
the object and which edges don't. The combination of these data are stored in the
casecade.xml file that stores the data set. The next step consist of detecting the
object in frame and identifying any objects that match the positive set. Any that
matcht he set will be stored in a vector and will be identified on screen with a 
rectangle around it. The next part consist of a gaussian blur to blur our the 
license plate to make it unreadable.
*/

// Inlucde the standard and opencv libraries
#include<opencv2/objdetect/objdetect.hpp> // object-detection
#include<opencv2/highgui/highgui.hpp>     // UI interface
#include<opencv2/imgproc/imgproc.hpp>     // Image processing
#include<iostream>                        // standard library


using namespace cv;

// Creates and store the cascade dataset for the license plates
std::string plate_cascade_file = "plate_cascade.xml";
CascadeClassifier plate_cascade;

// stores current frame
Mat frame;

// Detects and recognizes the object from the cascade file
void detection(Mat frame)
{
    std::vector<Rect> plates; // Creates a vector for license plates
    Mat gray, blurPlate;

    cvtColor(frame, gray, COLOR_BGR2GRAY); // converts current frame to grayscale
    equalizeHist(gray, gray); // equalizes the histogram of the grayscale image

    // detects object of different sizes and returns as rectangles
    plate_cascade.detectMultiScale(gray, plates, 1.5, 5);

    // Iterates through all detected objects
    for( size_t i = 0; i< plates.size(); i++ ) 
    {
        // creates the rectangle box in the frame
        rectangle(frame, plates[i], Scalar( 0, 255, 0 ), 3, 1 );
        // blurs the rectangle box region in the current frame
        GaussianBlur(frame(plates[i]), frame(plates[i]), Size(0,0), 20);
    }

    imshow("LicensePlateBlur", frame); // Display the current frame
}


// Main - handles the video processing and capturing of frames
int main()
{
    
    // Loads the cascade file. If not read, then exit program
    if(!plate_cascade.load(plate_cascade_file))
    {
        std::cout << "Error! Could not load cascade file!" << std::endl;
        return -1;
    }

    VideoCapture cap;
    //cap.open(1);     // opens a live video on the selected video device
    cap.open("plate001.avi");
    std::string VideoFileName = ""; // used if reading an a video file
    // cap.open("VideoFileName"); // Uncomment to insert video file

    // Opens the video file or feed. If not opened, then exit program
    if(!cap.isOpened())
    {
        std::cout << "ERROR! No video found!" << std::endl;
        return -1;
    }

    // Creates a window for the video
    namedWindow("LicensePlateBlur", WINDOW_AUTOSIZE);

    double fps = cap.get(CAP_PROP_FPS); // gets frames per second

    Size size( // gets size of video capture device
        cap.get(CAP_PROP_FRAME_WIDTH),
        cap.get(CAP_PROP_FRAME_HEIGHT)
    );

    VideoWriter writer;
    writer.open("plate_detector.avi", CV_FOURCC('M','J','P','G'), fps, size);

    Mat gray;
    char quitProg; // handles user input for exiting the program

    while(1) // loops through the video until it ends or the user exits
    {
        cap >> frame; // stores the frame from the video 
        if(frame.empty()) break; // if no frame received, exit program

        detection(frame); // detects objects in the current frame

        writer.write(frame);

        // If user enters a 'q' or ESC key, then exit the video
        quitProg = waitKey(33);
        if(quitProg == 'q' || quitProg == 27)
            break;
    }

    cap.release();       // closes the video file or capturing device
    destroyAllWindows(); // destroy current windows

    return 0;
}