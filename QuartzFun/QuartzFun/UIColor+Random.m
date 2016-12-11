//
//  UIColor+Random.m
//  QuartzFun
//
//  Created by Joe on 12/4/16.
//  Copyright © 2016 Joe. All rights reserved.
//

#import "UIColor+Random.h"

@implementation UIColor (Random)

+ (UIColor *)randomColor{
    CGFloat red=(CGFloat)(arc4random()%256)/255;
    CGFloat blue=(CGFloat)(arc4random()%256)/255;
    CGFloat green=(CGFloat)(arc4random()%256)/255;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

@end
