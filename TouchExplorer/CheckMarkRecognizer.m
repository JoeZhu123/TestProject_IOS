//
//  CheckMarkRecognizer.m
//  TouchExplorer
//
//  Created by Joe on 11/24/16.
//  Copyright © 2016 Joe. All rights reserved.
//

#import "CheckMarkRecognizer.h"
//#import "CGPointUtils.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

static CGFloat const kMinimumCheckMarkAngle=50;
static CGFloat const kMaximumCheckMarkAngle=135;
static CGFloat const kMinimumCheckMarkLength=10;

@implementation CheckMarkRecognizer{
    CGPoint lastPreviousPoint;
    CGPoint lastCurrentPoint;
    CGPoint lineLengthSoFar;
}
@end
