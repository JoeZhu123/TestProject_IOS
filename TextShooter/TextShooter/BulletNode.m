//
//  BulletNode.m
//  TextShooter
//
//  Created by Joe on 11/29/16.
//  Copyright © 2016 Joe. All rights reserved.
//

#import "BulletNode.h"
#import "PhysicsCategories.h"
#import "Geometry.h"

@implementation BulletNode

- (instancetype)init{
    if (self=[super init]) {
        SKLabelNode *dot=[SKLabelNode labelNodeWithFontNamed:@"Courier"];
        dot.fontColor=[SKColor blackColor];
        dot.fontSize=40;
        dot.text=@".";
        [self addChild:dot];
        SKPhysicsBody *body=[SKPhysicsBody bodyWithCircleOfRadius:1];
        
        body.dynamic=YES;
        body.categoryBitMask=PlayerMissileCategory;
        body.contactTestBitMask=EnemyCategory;
        body.collisionBitMask=EnemyCategory;
        body.mass=0.01;
        body.fieldBitMask=GravityFieldCategory;
        self.physicsBody=body;
        self.name=[NSString stringWithFormat:@"Bullet %p",self];
    }
    return self;
}

+ (instancetype)bulletFrom:(CGPoint)start toward:(CGPoint)destination{
    BulletNode *bullet=[[self alloc] init];
    bullet.position=start;
    CGVector movement=VectorBetweenPoint(start, destination);
    CGFloat magnitude=VectorLength(movement);
    if (magnitude==0.0f) {
        return nil;
    }
    CGVector scaleMovement=VectorMultiply(movement, 1/magnitude);
    CGFloat thrustMagnitude=100.0;
    bullet.thrust=VectorMultiply(scaleMovement, thrustMagnitude);
//    [bullet runAction:[SKAction playSoundFileNamed:@"shoot.wav" waitForCompletion:NO]];
    return bullet;
}

- (void)applyRecurringForce{
    [self.physicsBody applyForce:self.thrust];
}

@end
