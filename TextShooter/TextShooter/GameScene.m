//
//  GameScene.m
//  TextShooter
//
//  Created by Joe on 11/24/16.
//  Copyright (c) 2016 Joe. All rights reserved.
//

#import "GameScene.h"
#import "PlayerNode.h"
#import "EnemyNode.h"
#import "BulletNode.h"
#import "SKNode+Extra.h"
#import "GameOverScene.h"

@interface GameScene() <SKPhysicsContactDelegate>

@end

@implementation GameScene

+ (instancetype)sceneWithSize:(CGSize)size levelNumber:(NSUInteger)levelNumber{
    return [[self alloc] initWithSize:size levelNumber:levelNumber];
}
- (instancetype)initWithSize:(CGSize)size{
    return [self initWithSize:size levelNumber:1];
}
- (instancetype)initWithSize:(CGSize)size levelNumber:(NSUInteger)levelNumber{
    if (self=[super initWithSize:size]) {
        _levelNumber=levelNumber;
        _playerLives=5;
        self.backgroundColor=[SKColor whiteColor];
        SKLabelNode *lives=[SKLabelNode labelNodeWithFontNamed:@"Courier"];
        lives.fontSize=16;
        lives.fontColor=[SKColor blackColor];
        lives.name=@"LivesLabel";
        lives.text=[NSString stringWithFormat:@"Lives:%lu",(unsigned long)_playerLives];
        lives.verticalAlignmentMode=SKLabelVerticalAlignmentModeTop;
        lives.horizontalAlignmentMode=SKLabelHorizontalAlignmentModeRight;
        lives.position=CGPointMake(self.frame.size.width, self.frame.size.height);
        [self addChild:lives];
        SKLabelNode *level=[SKLabelNode labelNodeWithFontNamed:@"Courier"];
        level.fontSize=16;
        level.fontColor=[SKColor blackColor];
        level.name=@"LevelLabel";
        level.text=[NSString stringWithFormat:@"Level:%lu",(unsigned long)_levelNumber];
        level.verticalAlignmentMode=SKLabelVerticalAlignmentModeTop;
        level.horizontalAlignmentMode=SKLabelHorizontalAlignmentModeLeft;
        level.position=CGPointMake(0, self.frame.size.height);
        [self addChild:level];
        _playerNode=[PlayerNode node];
        _playerNode.position=CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame)*0.1);
        [self addChild:_playerNode];
        _enemies=[SKNode node];
        [self addChild:_enemies];
        [self spawnEnemies];
        _playerBullets=[SKNode node];
        [self addChild:_playerBullets];
        
        _forceFields=[SKNode node];
        [self addChild:_forceFields];
        [self createForceFields];
        
        self.physicsWorld.gravity=CGVectorMake(0, -1);
        self.physicsWorld.contactDelegate=self;
    }
    return self;
}

- (void)didBeginContact:(SKPhysicsContact *)contact{
    if (contact.bodyA.categoryBitMask==contact.bodyB.categoryBitMask) {
        //两种物理对象都属于同一物理类别
        SKNode *nodeA=contact.bodyA.node;
        SKNode *nodeB=contact.bodyB.node;
        //这些节点能干什么
        [nodeA friendlyBumpFrom:nodeB];
        [nodeB friendlyBumpFrom:nodeA];
    }else{
        SKNode *attacker=nil;
        SKNode *attackee=nil;
        
        if (contact.bodyA.categoryBitMask>contact.bodyB.categoryBitMask) {
            //BodyA正在攻击BodyB
            attacker=contact.bodyA.node;
            attackee=contact.bodyB.node;
        }else{
            //BodyB正在攻击BodyA
            attacker=contact.bodyB.node;
            attackee=contact.bodyA.node;
        }
        if ([attackee isKindOfClass:[PlayerNode class]]) {
            self.playerLives--;
        }
        //应该怎么处理攻击者和受攻击者的逻辑机制
        [attackee receiveAttacker:attacker contact:contact];
        [self.playerBullets removeChildrenInArray:@[attacker]];
        [self.enemies removeChildrenInArray:@[attacker]];
    }
}

- (void)setPlayerLives:(NSUInteger)playerLives{
    _playerLives=playerLives;
    SKLabelNode *lives=(id)[self childNodeWithName:@"LivesLabel"];
    lives.text=[NSString stringWithFormat:@"Lives:%lu",(unsigned long)_playerLives];
}

//-(void)didMoveToView:(SKView *)view {
//    /* Setup your scene here */
//    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//    
//    myLabel.text = @"Hello, World!";
//    myLabel.fontSize = 45;
//    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
//                                   CGRectGetMidY(self.frame));
//    
//    [self addChild:myLabel];
//}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if (location.y<CGRectGetHeight(self.frame)*0.2) {
            CGPoint target=CGPointMake(location.x, self.playerNode.position.y);
            [self.playerNode moveToward:target];
        }else{
            BulletNode *bullet=[BulletNode
                                bulletFrom:self.playerNode.position toward:location];
            [self.playerBullets addChild:bullet];
        }
//        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
//        sprite.xScale = 0.5;
//        sprite.yScale = 0.5;
//        sprite.position = location;
//        
//        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
//        
//        [sprite runAction:[SKAction repeatActionForever:action]];
//        
//        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (self.finished) {
        return;
    }
    
    [self updateBullets];
    [self updateEnemies];
    if (![self checkForGameOver]) {
        [self checkForNextLevel];
    }
}

- (void)checkForNextLevel{
    if ([self.enemies.children count]==0) {
        [self goToNextLevel];
    }
}

- (void)goToNextLevel{
    self.finished=YES;
    
    SKLabelNode *label=[SKLabelNode labelNodeWithFontNamed:@"Courier"];
    label.text=@"Level Complete!";
    label.fontColor=[SKColor blueColor];
    label.fontSize=32;
    label.position=CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
    [self addChild:label];
    GameScene *nextLevel=[[GameScene alloc]
                          initWithSize:self.frame.size levelNumber:self.levelNumber+1];
    nextLevel.playerLives=self.playerLives;
    [self.view presentScene:nextLevel
                 transition:[SKTransition flipHorizontalWithDuration:1.0]];
}
- (void)updateEnemies{
    NSMutableArray *enemiesToRemove=[NSMutableArray array];
    for (SKNode *node in self.enemies.children) {
        //清楚移动到屏幕外的敌人
        if (!CGRectContainsPoint(self.frame, node.position)) {
            //标记将予以清除的敌人
            [enemiesToRemove addObject:node];
            continue;
        }
    }
    if ([enemiesToRemove count]>0) {
        [self.enemies removeChildrenInArray:enemiesToRemove];
    }
}

- (void)updateBullets{
    NSMutableArray *bulletsToRemove=[NSMutableArray array];
    for (BulletNode *bullet in self.playerBullets.children) {
        //清除所有移动到屏幕外部的导弹
        if (!CGRectContainsPoint(self.frame, bullet.position)) {
            //标记将予以清除的导弹
            [bulletsToRemove addObject:bullet];
            continue;
        }
        //将推力作用于剩下的导弹
        [bullet applyRecurringForce];
    }
    [self.playerBullets removeChildrenInArray:bulletsToRemove];
}
- (void)spawnEnemies{
    NSUInteger count=log(self.levelNumber)+self.levelNumber;
    for (NSUInteger i=0; i<count; i++) {
        EnemyNode *enemy=[EnemyNode node];
        CGSize size=self.frame.size;
        CGFloat x=arc4random_uniform(size.width*0.8)+(size.width*0.1);
        CGFloat y=arc4random_uniform(size.height*0.5)+(size.height*0.5);
        enemy.position=CGPointMake(x, y);
        [self.enemies addChild:enemy];
    }
}

- (void)triggerGameOver{
    self.finished=YES;
    NSString *path=[[NSBundle mainBundle] pathForResource:@"EnemyExplosion" ofType:@"sks"];
    SKEmitterNode *explosion=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    explosion.numParticlesToEmit=200;
    explosion.position=_playerNode.position;
    [self addChild:explosion];
    [_playerNode removeFromParent];
    SKTransition *transition=[SKTransition doorsOpenVerticalWithDuration:1.0];
    SKScene *gameOver=[[GameOverScene alloc] initWithSize:self.frame.size];
    [self.view presentScene:gameOver transition:transition];
//    [self runAction:[SKAction playSoundFileNamed:@"gameOver.wav" waitForCompletion:NO]];
}

- (BOOL)checkForGameOver{
    if (self.playerLives==0) {
        [self triggerGameOver];
        return YES;
    }
    return NO;
}

- (void)createForceFields{
    static int fieldCount=3;
    CGSize size=self.frame.size;
    float sectionWidth=size.width/fieldCount;
    for (NSUInteger i=0; i<fieldCount; i++) {
        CGFloat x=i*sectionWidth+arc4random_uniform(sectionWidth);
        CGFloat y=arc4random_uniform(size.height*0.25)+(size.height*0.25);
        SKFieldNode *gravityField=[SKFieldNode radialGravityField];
        gravityField.position=CGPointMake(x, y);
        gravityField.categoryBitMask=GravityFieldCategory;
        gravityField.strength=4;
        gravityField.falloff=2;
        gravityField.region=[[SKRegion alloc] initWithSize:CGSizeMake(size.width*0.3, size.height*0.1)];
        [self.forceFields addChild:gravityField];
        SKLabelNode *fieldLocationNode=[SKLabelNode labelNodeWithFontNamed:@"Courier"];
        fieldLocationNode.fontSize=16;
        fieldLocationNode.fontColor=[SKColor redColor];
        fieldLocationNode.name=@"GravityField";
        fieldLocationNode.text=@"*";
        fieldLocationNode.position=CGPointMake(x, y);
        [self.forceFields addChild:fieldLocationNode];
    }

}
@end
