//
//  GraphViewController.h
//  CS193P-3
//
//  Created by Ed Sibbald on 10/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphViewController : UIViewController <GraphViewDelegate> {
	id expression;
	GraphView *graphView;
}

@property (retain) id expression;

- (IBAction)zoomInPressed;
- (IBAction)zoomOutPressed;

@end
