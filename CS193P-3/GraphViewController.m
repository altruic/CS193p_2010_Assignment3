//
//  GraphViewController.m
//  CS193P-3
//
//  Created by Ed Sibbald on 10/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"
#import "CalculatorBrain.h"

@interface GraphViewController()
@property (retain) IBOutlet GraphView *graphView;
@end

@implementation GraphViewController
@synthesize expression;
@synthesize graphView;

- (double)yGivenX:(double)xValue forGraphView:(GraphView *)requestor
{
	double yValue = 0.0;
	if (requestor == graphView) {
		NSNumber *xNumber = [NSNumber numberWithDouble:xValue];
		NSDictionary *varDict = [NSDictionary dictionaryWithObject:xNumber
															forKey:@"x"];
		yValue = [CalculatorBrain evaluateExpression:expression
								 usingVariableValues:varDict];
	}
	return yValue;
}

#pragma mark - Target actions

- (IBAction)zoomInPressed
{
	self.graphView.scale *= 1.5;
	[self.graphView setNeedsDisplay];
}

- (IBAction)zoomOutPressed
{
	self.graphView.scale /= 1.5;
	[self.graphView setNeedsDisplay];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.graphView.delegate = self;
	self.graphView.scale = 20;
	[self.graphView setNeedsDisplay];
	self.title = @"Graph";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	self.graphView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
