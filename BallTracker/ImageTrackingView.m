//
//  ImageTrackingView.m
//  BallTracker
//
//  Created by Aaron Hillegass on 7/10/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import "ImageTrackingView.h"
#import "Circle.h"

NSPoint convertPointFromImageCoordinates(NSPoint toConvert, NSPoint imageOrigin, float scale)
{
    NSPoint result;
    result.x = imageOrigin.x + toConvert.x * scale;
    result.y = imageOrigin.y + toConvert.y * scale;
    return result;
}

NSRect maximalRectWithoutChangingAspect(NSRect boundary, NSSize shape)
{
    float innerAspect, outerAspect;
    BOOL squatterThanBoundary;
    float scale;
    NSRect result;
    
    innerAspect = shape.width / shape.height;
    outerAspect = boundary.size.width / boundary.size.height;
    
    squatterThanBoundary = (innerAspect > outerAspect);
    
    if (squatterThanBoundary)
        scale = boundary.size.width / shape.width;
    else
        scale = boundary.size.height / shape.height;
    
    result.size.width = shape.width * scale;
    result.size.height = shape.height * scale;
    
    if (squatterThanBoundary) {
        result.origin.x = boundary.origin.x;
        result.origin.y = boundary.origin.y + (boundary.size.height - result.size.height)/ 2.0;
    } else {
        result.origin.y = boundary.origin.y;
        result.origin.x = boundary.origin.x + (boundary.size.width - result.size.width)/ 2.0;
    }
    return result;
}

@implementation ImageTrackingView

- (void)setImage:(NSImage *)i
{
    image = i;
    [self setNeedsDisplay:YES];
}

- (void)setCircles:(NSArray *)a
{
    circles = a;
    [self setNeedsDisplay:YES];
}

- (BOOL)isFlipped
{
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSRect bounds = [self bounds];
    [[NSColor darkGrayColor] setFill];
    [NSBezierPath fillRect:bounds];
    if (!image)
        return;
    
    NSRect displayRect = maximalRectWithoutChangingAspect(bounds, image.size);
    float scale = displayRect.size.width / image.size.width;
    
    [image drawInRect:displayRect];

    [[NSColor blackColor] setStroke];
    for (Circle *c in circles) {
        NSPoint origin = NSMakePoint(c.center.x - c.radius,c.center.y - c.radius);
        NSRect r;
        r.origin = convertPointFromImageCoordinates(origin, displayRect.origin, scale);
        r.size.width = r.size.height = c.radius * scale * 2.0;
        //fprintf(stderr, "Scale is %.2f: %.2f, %.2f, %.2f, %.2f\n",scale, r.origin.x, r.origin.y, r.size.width, r.size.height);
        NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:r];
        float centerX = r.origin.x + r.size.width/2.0;
        float centerY = r.origin.y + r.size.height/2.0;
        
        [path moveToPoint:NSMakePoint(centerX, r.origin.y)];
        [path lineToPoint:NSMakePoint(centerX, r.origin.y + r.size.height)];
        
        [path moveToPoint:NSMakePoint(r.origin.x, centerY)];
        [path lineToPoint:NSMakePoint(r.origin.x + r.size.width, centerY)];
        
        [path setLineWidth:4];
        [path stroke];

    }
}



@end
