//
//  ViewController.h
//  Test1
//
//  Created by Joe on 7/30/16.
//  Copyright © 2016 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (IBAction)buttonPressed:(UIButton *)sender;

@end

