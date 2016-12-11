//
//  ViewController.m
//  QuartzFun
//
//  Created by Joe on 12/4/16.
//  Copyright © 2016 Joe. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"
#import "QuartzFunView.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UISegmentedControl *colorControl;
- (IBAction)changeColor:(UISegmentedControl *)sender;
- (IBAction)changeShape:(UISegmentedControl *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeColor:(UISegmentedControl *)sender {
    QuartzFunView *funView=(QuartzFunView *)self.view;
    ColorTabIndex index=[sender selectedSegmentIndex];
    switch (index) {
        case kRedColorTab:
            funView.currentColor=[UIColor redColor];
            funView.useRandomColor=NO;
            break;
        case kBlueColorTab:
            funView.currentColor=[UIColor blueColor];
            funView.useRandomColor=NO;
            break;
        case kYellowColorTab:
            funView.currentColor=[UIColor yellowColor];
            funView.useRandomColor=NO;
            break;
        case kGreenColorTab:
            funView.currentColor=[UIColor greenColor];
            funView.useRandomColor=NO;
            break;
        case kRandomColorTab:
            funView.useRandomColor=YES;
            break;
        default:
            break;
    }
}

- (IBAction)changeShape:(UISegmentedControl *)sender {
    [(QuartzFunView *)self.view setShapeType:[sender
                                              selectedSegmentIndex]];
    self.colorControl.hidden=[sender selectedSegmentIndex]==kImageShape;
}
@end
