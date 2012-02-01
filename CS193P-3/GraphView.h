//
//  GraphView.h
//  CS193P-3
//
//  Created by Ed Sibbald on 10/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;

@protocol GraphViewDelegate
- (double)yGivenX:(double)xValue forGraphView:(GraphView *)requestor;
@end


@interface GraphView : UIView {
	id <GraphViewDelegate> delegate;
	double scale;
}
@property (assign) id <GraphViewDelegate> delegate;
@property double scale;
@end
