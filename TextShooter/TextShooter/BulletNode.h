//
//  BulletNode.h
//  TextShooter
//
//  Created by Joe on 11/29/16.
//  Copyright © 2016 Joe. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PhysicsCategories.h"
#import "Geometry.h"

@interface BulletNode : SKNode
@property (assign,nonatomic) CGVector thrust;

+ (instancetype)bulletFrom:(CGPoint)start toward:(CGPoint)destination;
- (void)applyRecurringForce;
@end
