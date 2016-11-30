//
//  BallView.h
//  Test1
//
//  Created by Joe on 10/7/16.
//  Copyright © 2016 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface BallView : UIView
@property (assign,nonatomic) CMAcceleration acceleration;

- (void)update;

@end
