//
//  FindCircle.m
//  BallTracker
//
//  Created by Aaron Hillegass on 7/10/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import "findHue.h"
#import "Circle.h"
#import <stdlib.h>
#include <opencv2/imgproc.hpp>

#define CLOSE_ENOUGH (4)
#define SLOPE (35)
#define ENOUGH_SATURATION (80)
#define ENOUGH_VALUE (50)

using namespace cv;

unsigned char hotness(unsigned char *colorPtr, unsigned char hue) {
    int difference = abs(hue - colorPtr[0]);
    difference = MAX(0, difference - CLOSE_ENOUGH);
    difference = difference * SLOPE;
    int limited = MIN(255, difference);
    
    if (colorPtr[1] < ENOUGH_SATURATION) {
        limited = 255;
    }
    
    if (colorPtr[2] < ENOUGH_VALUE) {
        limited = 255;
    }

    return 255 - limited;
}

cv::Mat findHue(unsigned char hue, cv::Mat& hsvImage) {
    cv::Mat hueHotness(hsvImage.rows, hsvImage.cols, CV_8UC1);
    
    for (int currentRow = 0; currentRow < hsvImage.rows; currentRow++ ) {
        uchar *inPtr = hsvImage.ptr(currentRow);
        uchar *outPtr = hueHotness.ptr(currentRow);
        for (int currentColumn = 0; currentColumn < hsvImage.cols; currentColumn++) {
            *outPtr = hotness(inPtr, hue);
            outPtr++;
            inPtr += 3;
        }
    }
    return hueHotness;
}

