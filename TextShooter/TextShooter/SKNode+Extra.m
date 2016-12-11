//
//  SKNode+Extra.m
//  TextShooter
//
//  Created by Joe on 11/30/16.
//  Copyright © 2016 Joe. All rights reserved.
//

#import "SKNode+Extra.h"

@implementation SKNode (Extra)

- (void)receiveAttacker:(SKNode *)attacker contact:(SKPhysicsContact *)contact{
    //默认的实现不执行任何操作
}
- (void)friendlyBumpFrom:(SKNode *)node{
    //默认的实现不执行任何操作
}
@end
