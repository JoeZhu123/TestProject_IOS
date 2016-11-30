//
//  ViewController.m
//  Test1
//
//  Created by Joe on 7/30/16.
//  Copyright © 2016 Joe. All rights reserved.
//

#import "ViewController.h"

#import <CoreMotion/CoreMotion.h>



@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *numberField;
@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;
@property (weak, nonatomic) IBOutlet UISwitch *leftSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *rightSwitch;
@property (weak, nonatomic) IBOutlet UIButton *dosomethingButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet UILabel *gyroscopeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accelerometerLabel;
@property (weak, nonatomic) IBOutlet UILabel *attituteLabel;
@property (retain,nonatomic) CMMotionManager *motionManager;
@property (retain,nonatomic) NSOperationQueue *queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.sliderLabel.text=@"50";
    
    self.motionManager=[[CMMotionManager alloc] init];
    self.queue=[[NSOperationQueue alloc] init];
    if (self.motionManager.deviceMotionAvailable) {
        self.motionManager.deviceMotionUpdateInterval=0.1;
        [self.motionManager startDeviceMotionUpdatesToQueue:self.queue withHandler:^(CMDeviceMotion *motion,NSError *error){
            CMRotationRate rotationRate=motion.rotationRate;
            CMAcceleration gravity=motion.gravity;
            CMAcceleration userAcc=motion.userAcceleration;
            CMAttitude *attitude=motion.attitude;
            
            NSString *gyroscopeText=[NSString stringWithFormat:@"Rotation Rate:\n------\n"
                                                                "x:%+.2f\ny:%+.2f\nz:%+.2f\n",
                                     rotationRate.x,rotationRate.y,rotationRate.z];
            NSString *acceleratorText=[NSString stringWithFormat:@"Acceleration:\n------\n"
                                     "Gravity x:%+.2f\t\tUser x:%+.2f\n"
                                     "Gravity y:%+.2f\t\tUser y:%+.2f\n"
                                     "Gravity z:%+.2f\t\tUser z:%+.2f\n",
                                     gravity.x,userAcc.x,gravity.y,userAcc.y,gravity.z,userAcc.z];
            NSString *attitudeText=[NSString stringWithFormat:@"Attitude:\n------\n"
                                     "Roll:%+.2f\nPitch:%+.2f\nYaw:%+.2f\n",
                                     attitude.roll,attitude.pitch,attitude.yaw];
            dispatch_async(dispatch_get_main_queue(), ^{self.gyroscopeLabel.text=gyroscopeText;
                                                        self.accelerometerLabel.text=acceleratorText;
                                                        self.attituteLabel.text=attitudeText;});
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(UIButton *)sender {
    NSString *title=[sender titleForState:UIControlStateNormal];
    NSString *plainText=[NSString stringWithFormat:@"%@ button pressed.",title];
    _statusLabel.text=plainText;
}

-(IBAction)textFieldDoneEditing:(id)sender{
    [sender resignFirstResponder];
}

-(IBAction)backgroundTap:(id)sender {
    [self.nameField resignFirstResponder];
    [self.numberField resignFirstResponder];
}
- (IBAction)sliderChanged:(UISlider *)sender {
    int progress = (int)lroundf(sender.value);
    self.sliderLabel.text=[NSString stringWithFormat:@"%d",progress];
}
- (IBAction)switchChanged:(UISwitch *)sender {
    BOOL setting=sender.isOn;
    [self.leftSwitch setOn:setting animated:YES];
    [self.rightSwitch setOn:setting animated:YES];
}
- (IBAction)toggleControls:(UISegmentedControl *)sender {
    if(sender.selectedSegmentIndex==0){
        self.leftSwitch.hidden=NO;
        self.rightSwitch.hidden=NO;
        self.dosomethingButton.hidden=YES;
    }
    else{
        self.leftSwitch.hidden=YES;
        self.rightSwitch.hidden=YES;
        self.dosomethingButton.hidden=NO;
    }
}
- (IBAction)ButtonPressed:(UIButton *)sender {
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"Are You Sure?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *yesAction=[UIAlertAction actionWithTitle:@"Yes,I'm sure!"
                                                      style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
                                                          NSString *msg;
                                                          if(self.nameField.text.length>0) {
                                                              msg=[NSString stringWithFormat:@"You can breathe easy,%@,everything went OK.",self.nameField.text];
                                                          } else {
                                                              msg=@"You can breathe easy,everything went OK.";
                                                          }
    UIAlertController *controller2=[UIAlertController alertControllerWithTitle:@"Something Was Done" message:msg preferredStyle:UIAlertControllerStyleAlert];
                                                          UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"Phew!" style:UIAlertActionStyleCancel handler:nil];
                                                      }];
    UIAlertAction *noAction=[UIAlertAction actionWithTitle:@"No way!" style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:yesAction];
    [controller addAction:noAction];
    
    UIPopoverPresentationController *ppc=controller.popoverPresentationController;
    if (ppc!=nil) {
        ppc.sourceView=sender;
        ppc.sourceRect=sender.bounds;
    }
    [self presentViewController:controller animated:YES completion:nil];
}

@end
