//
//  EnemyNode.m
//  TextShooter
//
//  Created by Joe on 11/29/16.
//  Copyright © 2016 Joe. All rights reserved.
//

#import "EnemyNode.h"
#import "PhysicsCategories.h"
#import "Geometry.h"

@implementation EnemyNode

- (void)friendlyBumpfrom:(SKNode *)node{
    self.physicsBody.affectedByGravity=YES;
}

- (void)receiveAttacker:(SKNode *)attacker contact:(SKPhysicsContact *)contact{
    self.physicsBody.affectedByGravity=YES;
    CGVector force=VectorMultiply(attacker.physicsBody.velocity, contact.collisionImpulse);
    CGPoint myContact=[self.scene convertPoint:contact.contactPoint toNode:self];
    [self.physicsBody applyForce:force
                         atPoint:myContact];
    
    NSString *path=[[NSBundle mainBundle]
                    pathForResource:@"MissileExplosion" ofType:@"sks"];
    SKEmitterNode *explosion=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    explosion.numParticlesToEmit=20;
    explosion.position=contact.contactPoint;
    [self.scene addChild:explosion];
//    [self runAction:[SKAction playSoundFileNamed:enemyHit.wav waitForCompletion:NO]];
}

- (instancetype)init {
    if (self=[super init]) {
        self.name=[NSString stringWithFormat:@"Enemy %p",self];
        [self initNodeGraph];
        [self initPhysicsBody];
    }
    return self;
}

- (void)initPhysicsBody{
    SKPhysicsBody *body=[SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(40, 40)];
    body.affectedByGravity=NO;
    body.categoryBitMask=EnemyCategory;
    body.contactTestBitMask=PlayerCategory|EnemyCategory;
    body.mass=0.2;
    body.angularDamping=0.0f;
    body.linearDamping=0.0f;
    body.fieldBitMask=0;
    self.physicsBody=body;
}

- (void)initNodeGraph{
    SKLabelNode *topRow=[SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
    topRow.fontColor=[SKColor brownColor];
    topRow.fontSize=20;
    topRow.text=@"x x";
    topRow.position=CGPointMake(0, 15);
    [self addChild:topRow];
    
    SKLabelNode *middleRow=[SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
    middleRow.fontColor=[SKColor brownColor];
    middleRow.fontSize=20;
    middleRow.text=@"x";
    [self addChild:middleRow];
    
    SKLabelNode *bottomRow=[SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
    bottomRow.fontColor=[SKColor brownColor];
    bottomRow.fontSize=20;
    bottomRow.text=@"x";
    [self addChild:bottomRow];
}
@end
