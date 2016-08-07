//
//  AppDelegate.h
//  BallTracker
//
//  Created by Aaron Hillegass on 7/10/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#undef check
#include <opencv2/videoio.hpp>

@class ImageTrackingView;


@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    NSTimer *timer;
    cv::VideoCapture capture;
    
    // Matrix for webcam feed
    cv::Mat cameraFeed;
    
    // Matrix for HSV image
    cv::Mat hsvMatrix;

    // Matrix for hue mask
    cv::Mat hueMask;
    
    unsigned char hue;
    
}

@property (weak) IBOutlet ImageTrackingView *imageView;
@property (weak) IBOutlet NSImageView *intermediateView;
@property (weak) IBOutlet NSSlider *hueSlider;
@property (weak) IBOutlet NSTextField *infoLabel;
@property (weak) IBOutlet NSPopUpButton *colorPopUp;

- (IBAction)toggleCapturing:(id)sender;
- (IBAction)changeHue:(id)sender;
- (IBAction)changeColor:(id)sender;




@end

