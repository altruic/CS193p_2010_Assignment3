//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Ed Sibbald on 10/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#include <stdlib.h>
#import "GraphViewController.h"


@implementation CalculatorViewController

@synthesize display;


- (void)viewDidLoad
{
	[super viewDidLoad];
	brain = [[CalculatorBrain alloc] init];
	self.title = @"Calculator";
}


- (IBAction)digitPressed:(UIButton *)sender
{
	NSString* digit = sender.titleLabel.text;
	
	if (userIsTypingANumber)
		display.text = [display.text stringByAppendingString:digit];
	else {
		display.text = digit;
		userIsTypingANumber = YES;
	}
}


- (IBAction)operationPressed:(UIButton *)sender
{
	if (userIsTypingANumber) {
		brain.operand = [display.text doubleValue];
		userIsTypingANumber = NO;
	}
	NSString *operation = sender.titleLabel.text;
	double result = [brain performOperation:operation];
	id expression = brain.expression;
	if ([CalculatorBrain variablesInExpression:expression])
		display.text = [CalculatorBrain descriptionOfExpression:expression];
	else
		display.text = [NSString stringWithFormat:@"%g", result];
}


- (IBAction)variablePressed:(UIButton *)sender
{
	// it doesn't make any sense to type a variable right after a number, but our brain should handle it gracefully.
	if (userIsTypingANumber) {
		brain.operand = [display.text doubleValue];
		userIsTypingANumber = NO;
	}
	[brain setVariableAsOperand:sender.titleLabel.text];
	display.text = [CalculatorBrain descriptionOfExpression:brain.expression];
}


- (IBAction)decimalPointPressed
{
	if (userIsTypingANumber) {
		NSRange range = [display.text rangeOfString:@"."];
		if (range.location == NSNotFound)
			display.text = [display.text stringByAppendingString:@"."];
	}
	else {
		display.text = @"0.";
		userIsTypingANumber = YES;
	}
}


- (void)graphPressedImpl
{
	GraphViewController *graphVC = [[GraphViewController alloc] init];
	graphVC.expression = brain.expression;
	[self.navigationController pushViewController:graphVC animated:YES];
	[graphVC release];
}


- (IBAction)graphPressed
{
	if (!userIsTypingANumber) {
		[self graphPressedImpl];
		return;
	}

	NSString *msgText = [NSString stringWithFormat:@"Would you like to include the current operand (%@)?", display.text];
	UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Use Operand?"
														 message:msgText
														delegate:self
											   cancelButtonTitle:@"Ignore"
											   otherButtonTitles:@"Include", nil]
								autorelease];
	[alertView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != alertView.cancelButtonIndex) {
		brain.operand = [display.text doubleValue];
		userIsTypingANumber = NO;
	}
	[self graphPressedImpl];
}


- (void)releaseOutlets
{
	self.display = nil;
}


- (void)viewDidUnload
{
	[self viewDidUnload];
	[self releaseOutlets];
}


- (void)dealloc
{
	[brain release];
	[self releaseOutlets];
	[super dealloc];
}


@end
