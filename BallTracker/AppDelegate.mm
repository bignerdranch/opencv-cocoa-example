//
//  AppDelegate.m
//  BallTracker
//
//  Created by Aaron Hillegass on 7/10/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import "AppDelegate.h"
#import "ImageTrackingView.h"
#import "NSImage+OpenCV.h"
#import <opencv2/highgui.hpp>
#import <opencv2/imgproc.hpp>
#import "findHue.h"
#import "Circle.h"

using namespace cv;

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self changeColor:self.colorPopUp];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)showContours:(cv::Mat&)src
{
}

- (void)capture:(NSTimer *)t
{
    // Store image to matrix
    capture.read(cameraFeed);
    
    // Convert frame from BGR to HSV colorspace
    cvtColor(cameraFeed, hsvMatrix, COLOR_BGR2HSV);
    
    // Get a one-channel that finds pixels that are close to 'hue' in hue
    cv::Mat hotness = findHue(hue, hsvMatrix);
  
    /* If I wanted to smooth it a bit.
    cv::Mat kernel = getStructuringElement( MORPH_RECT,
                                           cv::Size(5,5),
                                           cv::Point(2, 2));
    cv::Mat smoothed;
    cv::erode(hotness, smoothed, kernel);
    cv::erode(smoothed, smoothed, kernel);
    cv::Mat smoothcopy = smoothed;
    */
    
    // Display it for fun and debugging
    NSImage *intermediateImage = [[NSImage alloc] initWithCVMat:hotness];
    // Creating the data is done lazily -- if you don't do this line, the buffer gets messed
    // up by findContours.
    [(NSBitmapImageRep *)[[intermediateImage representations] objectAtIndex:0] bitmapData];
    [self.intermediateView setImage:intermediateImage];
    
    // Find the top-level contours
    std::vector<std::vector<cv::Point> > contours;
    std::vector<Vec4i> hierarchy;
    findContours(hotness, contours, hierarchy,
                 RETR_EXTERNAL, CHAIN_APPROX_TC89_KCOS );
    
    
    
    /* If I wanted to iterate through all the top-level contours,
      drawomg each connected component with its own random color

     Mat contourMat = Mat::zeros(smoothed.rows, smoothed.cols, CV_8UC3);
     if (hierarchy.size() > 0) {
       for(int idx = 0; idx >= 0; idx = hierarchy[idx][0] ) {
         Scalar color(rand()&255, rand()&255, rand()&255 );
         drawContours(contourMat, contours, idx, color, FILLED, 8, hierarchy );
       }
     }
     
     NSImage *contourImage = [[NSImage alloc] initWithCVMat:contourMat];
     [self.contourView setImage:contourImage];
     */

    
    // Find the one with the largest area
    BOOL found = NO;
    double biggestArea = 50.0; // Ignore circles with area of less than 50 pixels
    std::vector<cv::Point> biggestContour;
    if (hierarchy.size() > 0) {
        for(int idx = 0; idx >= 0; idx = hierarchy[idx][0] ) {
            double area = contourArea(contours[idx]);
            if (area > biggestArea) {
                biggestContour = contours[idx];
                biggestArea = area;
                found = YES;
                //fprintf(stderr, "contour %d: area=%.2f, {%.2f, %.2f}", idx, )
            }
        }
    }
    
    // Find the smallest circle that contains the biggest contour
    cv::Point2f center;
    float radius;
    if (found) {
        minEnclosingCircle(biggestContour,
                           center, radius);
        Circle *circle = [[Circle alloc] init];
        NSPoint nCenter = NSMakePoint(center.x, center.y);
        circle.center = nCenter;
        circle.radius = radius;
        [self.imageView setCircles:@[circle]];
        fprintf(stderr, "Circle: %.2f, %.2f: %.2f\n", circle.center.x, circle.center.y, circle.radius);
    } else {
        [self.imageView setCircles:@[]];
    }
 
    
    // Make an NSImage
    cv::Mat colorFixed;
    cvtColor(cameraFeed, colorFixed, COLOR_BGR2RGB);
    
    NSImage *image = [[NSImage alloc] initWithCVMat:colorFixed];
    [self.imageView setImage:image];
}

- (IBAction)toggleCapturing:(NSButton *)sender {
    // Is it starting?
    if (sender.state == NSOnState) {
        capture.open(0);
        //capture.set(CV_CAP_PROP_FRAME_WIDTH,FRAME_WIDTH);
        //capture.set(CV_CAP_PROP_FRAME_HEIGHT,FRAME_HEIGHT);
        
        if (!capture.isOpened()) {
            NSLog(@"Camera open failed");
            sender.state = NSOffState;
            return;
        }
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                 target:self
                                               selector:@selector(capture:)
                                               userInfo:nil
                                                repeats:YES];
    } else {
        [timer invalidate];
        timer = nil;
        
        capture.release();
        NSLog(@"Capture stopped");
    }
}

- (void)updateInfoLabel
{
    [self.infoLabel setStringValue:[NSString stringWithFormat:@"hue = %d", hue]];
}

- (IBAction)changeHue:(id)sender
{
    int newHue = [self.hueSlider intValue];
    hue = newHue;
    [self updateInfoLabel];
}

- (IBAction)changeColor:(id)sender
{
    int newHue = (int)[self.colorPopUp selectedTag];
    [self.hueSlider setIntValue:newHue];
    hue = newHue;
    [self updateInfoLabel];
    
}


@end
