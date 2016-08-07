//
//  FindCircle.h
//  BallTracker
//
//  Created by Aaron Hillegass on 7/10/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
#undef check
#include <opencv/cv.h>


// Returns an array of circles of the requested hue

cv::Mat findHue(unsigned char hue, cv::Mat& hsvImage);
