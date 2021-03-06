//
//  GameViewController.m
//  TextShooter
//
//  Created by Joe on 11/24/16.
//  Copyright (c) 2016 Joe. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "StartScene.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.
//    GameScene *scene = [GameScene nodeWithFileNamed:@"GameScene"];
//    scene.scaleMode = SKSceneScaleModeAspectFill;
//    GameScene *scene=[GameScene sceneWithSize:self.view.frame.size levelNumber:1];
    SKScene *scene=[StartScene sceneWithSize:skView.bounds.size];
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
