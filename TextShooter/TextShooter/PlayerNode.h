//
//  PlayerNode.h
//  TextShooter
//
//  Created by Joe on 11/29/16.
//  Copyright © 2016 Joe. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PlayerNode : SKNode

//返回将来移动所用的时间
- (void)moveToward:(CGPoint)location;
@end
