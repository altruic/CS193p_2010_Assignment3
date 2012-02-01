//
//  GraphView.m
//  CS193P-3
//
//  Created by Ed Sibbald on 10/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize delegate;
@synthesize scale;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (double)horizontalPixelForPoint:(double)pt
{ return pt * self.contentScaleFactor; }

- (double)horizontalPointForPixel:(double)px
{ return px / self.contentScaleFactor; }

- (double)xValueForHorizontalPixel:(double)px
{
	double absPt = [self horizontalPointForPixel:px];
	double ptWRTOrigin = absPt - (CGRectGetWidth(self.bounds) / 2.0);
	return ptWRTOrigin / scale;
}

- (double)verticalPixelForPoint:(double)pt
{ return pt * self.contentScaleFactor; }

- (double)verticalPointForPixel:(double)px
{ return px / self.contentScaleFactor; }

- (double)verticalPointForYValue:(double)y
{
	//-y = (absPt - (CGRectGetHeight(self.bounds) / 2.0)) / scale
	//-y * scale = absPt - (CGRectGetHeight(self.bounds) / 2.0)
	//(-y * scale) + (CGRectGetHeight(self.bounds) / 2.0) = absPt
	
	double ptWRTOrigin = -y * scale;
	return ptWRTOrigin + (CGRectGetHeight(self.bounds) / 2.0);
	
}

- (void)drawRect:(CGRect)rect
{
	CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.bounds),
									  CGRectGetMidY(self.bounds));
	[[UIColor blueColor] set];
    [AxesDrawer drawAxesInRect:self.bounds
				 originAtPoint:centerPoint
						 scale:scale];

	int minXPixel = [self horizontalPixelForPoint:self.bounds.origin.x];
	int maxXPixel = [self horizontalPixelForPoint:
					 self.bounds.origin.x + CGRectGetWidth(self.bounds)];

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextBeginPath(context);
	double x = [self xValueForHorizontalPixel:minXPixel];
	double y = [delegate yGivenX:x forGraphView:self];
	double vertPt = [self verticalPointForYValue:y];
	CGContextMoveToPoint(context,
						 [self horizontalPointForPixel:minXPixel],
						 vertPt);
	++minXPixel;
	for (int px = minXPixel; px < maxXPixel; ++px) {
		double horzPt = [self horizontalPointForPixel:px];
		double x = [self xValueForHorizontalPixel:px];
		double y = [delegate yGivenX:x forGraphView:self];
		double vertPt = [self verticalPointForYValue:y];
		CGContextAddLineToPoint(context, horzPt, vertPt);
	}

	[[UIColor redColor] set];
	CGContextDrawPath(context, kCGPathStroke);
}


@end
