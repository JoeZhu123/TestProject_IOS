//
//  QuartzFunView.m
//  QuartzFun
//
//  Created by Joe on 12/4/16.
//  Copyright © 2016 Joe. All rights reserved.
//

#import "QuartzFunView.h"
#import "UIColor+Random.h"

@implementation QuartzFunView

- (id)initWithCoder:(NSCoder*)coder{
    if (self=[super initWithCoder:coder]) {
        _currentColor=[UIColor redColor];
        _useRandomColor=NO;
        _image=[UIImage imageNamed:@"iphone"];
    }
    return self;
}

- (CGRect)currentRect{
    return CGRectMake(self.firstTouchLocation.x, self.firstTouchLocation.y, self.lastTouchLocation.x-self.firstTouchLocation.x, self.lastTouchLocation.y-self.firstTouchLocation.y);
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, self.currentColor.CGColor);
//    CGRect currentRect=CGRectMake(self.firstTouchLocation.x, self.firstTouchLocation.y, self.lastTouchLocation.x-self.firstTouchLocation.x, self.lastTouchLocation.y-self.firstTouchLocation.y);
    switch (self.shapeType) {
        case kLineShape:
            CGContextMoveToPoint(context, self.firstTouchLocation.x, self.firstTouchLocation.y);
            CGContextAddLineToPoint(context, self.lastTouchLocation.x, self.lastTouchLocation.y);
            CGContextStrokePath(context);
            break;
        case kRectShape:
            CGContextAddRect(context, self.currentRect);
            CGContextDrawPath(context, kCGPathFillStroke);
            break;
        case kEllipseShape:
            CGContextAddEllipseInRect(context, self.currentRect);
            CGContextDrawPath(context, kCGPathFillStroke);
            break;
        case kImageShape:{
            CGFloat horizontalOffset=self.image.size.width/2;
            CGFloat verticalOffset=self.image.size.height/2;
            CGPoint drawPoint=CGPointMake(self.lastTouchLocation.x-horizontalOffset, self.lastTouchLocation.y-verticalOffset);
            [self.image drawAtPoint:drawPoint];
            break;
        }
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.useRandomColor) {
        self.currentColor=[UIColor randomColor];
    }
    UITouch *touch=[touches anyObject];
    self.firstTouchLocation=[touch locationInView:self];
    self.lastTouchLocation=[touch locationInView:self];
    
    self.redrawRect=CGRectZero;
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    self.lastTouchLocation=[touch locationInView:self];
    if (self.shapeType==kImageShape) {
        CGFloat horizontalOffset=self.image.size.width/2;
        CGFloat verticalOffset=self.image.size.height/2;
        self.redrawRect=CGRectUnion(self.redrawRect, CGRectMake(self.lastTouchLocation.x-horizontalOffset, self.lastTouchLocation.y-verticalOffset, self.image.size.width, self.image.size.height));
    }else{
        self.redrawRect=CGRectUnion(self.redrawRect, self.currentRect);
    }
    self.redrawRect=CGRectInset(self.redrawRect, -2.0, -2.0);
    [self setNeedsDisplayInRect:self.redrawRect];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    self.lastTouchLocation=[touch locationInView:self];
    if (self.shapeType==kImageShape) {
        CGFloat horizontalOffset=self.image.size.width/2;
        CGFloat verticalOffset=self.image.size.height/2;
        self.redrawRect=CGRectUnion(self.redrawRect, CGRectMake(self.lastTouchLocation.x-horizontalOffset,self.lastTouchLocation.y-verticalOffset, self.image.size.width, self.image.size.height));
    }else{
        self.redrawRect=CGRectUnion(_redrawRect, self.currentRect);
    }
    [self setNeedsDisplayInRect:self.redrawRect];
}
@end
