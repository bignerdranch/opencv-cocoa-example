//
//  ImageTrackingView.h
//  BallTracker
//
//  Created by Aaron Hillegass on 7/10/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ImageTrackingView : NSView
{
    NSImage *image;
    NSArray *circles;
}
- (void)setImage:(NSImage *)i;
- (void)setCircles:(NSArray *)a;

@end
