//
//  QuartzFunView.h
//  QuartzFun
//
//  Created by Joe on 12/4/16.
//  Copyright © 2016 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
@interface QuartzFunView : UIView

@property (assign,nonatomic) ShapeType shapeType;
@property (assign,nonatomic) BOOL useRandomColor;
@property (strong,nonatomic) UIColor *currentColor;
@property (assign,nonatomic) CGPoint firstTouchLocation;
@property (assign,nonatomic) CGPoint lastTouchLocation;
@property (strong,nonatomic) UIImage *image;
@property (readonly,nonatomic) CGRect currentRect;
@property (assign,nonatomic) CGRect redrawRect;
@end
