//
//  OpenCV.h
//  CVTest
//
//  Created by Aaron Hillegass on 6/28/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

// check() is a macro in the Apple stuff and a function
// declared in opencv/core/utilities.hpp
#undef check
#include <opencv/cv.h>
#import <AppKit/AppKit.h>

@interface NSImage (OpenCV) {
    
}

+ (NSImage *)imageWithCVMat:(const cv::Mat&)cvMat;
- (instancetype)initWithCVMat:(const cv::Mat&)cvMat;

@property(nonatomic, readonly) cv::Mat CVMat;
@property(nonatomic, readonly) cv::Mat CVGrayscaleMat;

@end