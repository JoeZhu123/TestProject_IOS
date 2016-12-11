//
//  SKNode+Extra.h
//  TextShooter
//
//  Created by Joe on 11/30/16.
//  Copyright © 2016 Joe. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKNode (Extra)
- (void)receiveAttacker:(SKNode *)attacker contact:(SKPhysicsContact *)contact;
- (void)friendlyBumpFrom:(SKNode *)node;
@end
