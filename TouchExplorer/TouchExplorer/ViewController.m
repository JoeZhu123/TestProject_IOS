//
//  ViewController.m
//  TouchExplorer
//
//  Created by Joe on 11/18/16.
//  Copyright © 2016 Joe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *tapsLabel;
@property (weak, nonatomic) IBOutlet UILabel *touchesLabel;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic) CGPoint gestureStartPoint;
@property (weak, nonatomic) IBOutlet UILabel *singleLabel;
@property (weak, nonatomic) IBOutlet UILabel *doubleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tripleLabel;
@property (weak, nonatomic) IBOutlet UILabel *quadrupleLabel;
@property (strong, nonatomic) UIImageView *imageView;

@end

static CGFloat const kMinimumGestureLength=25;
static CGFloat const kMaximumVariance=5;

@implementation ViewController
CGFloat scale,previousScale;
CGFloat rotation,previousRotation;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    previousScale=1;
    UIImage *image=[UIImage imageNamed:@"myphoto"];
    self.imageView=[[UIImageView alloc] initWithImage:image];
    self.imageView.userInteractionEnabled=YES;
    self.imageView.center=self.view.center;
    [self.view addSubview:self.imageView];
    UIPinchGestureRecognizer *pinchGesture=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(doPinch:)];
    pinchGesture.delegate=self;
    [self.imageView addGestureRecognizer:pinchGesture];
    UIRotationGestureRecognizer *rotationGesture=[[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(doRotate:)];
    rotationGesture.delegate=self;
    [self.imageView addGestureRecognizer:rotationGesture];
    
    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    singleTap.numberOfTapsRequired=1;
    singleTap.numberOfTouchesRequired=1;
    [self.view addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
    doubleTap.numberOfTapsRequired=2;
    doubleTap.numberOfTouchesRequired=1;
    [self.view addGestureRecognizer:doubleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    UITapGestureRecognizer *tripleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripleTap)];
    tripleTap.numberOfTapsRequired=3;
    tripleTap.numberOfTouchesRequired=1;
    [self.view addGestureRecognizer:tripleTap];
    [doubleTap requireGestureRecognizerToFail:tripleTap];
    
    UITapGestureRecognizer *quadrupleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quadrupleTap)];
    quadrupleTap.numberOfTapsRequired=4;
    quadrupleTap.numberOfTouchesRequired=1;
    [self.view addGestureRecognizer:quadrupleTap];
    [tripleTap requireGestureRecognizerToFail:quadrupleTap];
    
    for (NSUInteger touchCount=1; touchCount<=5; touchCount++) {
        
        UISwipeGestureRecognizer *vertical=[[UISwipeGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(reportVerticalSwipe:)];
        vertical.direction=UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
        vertical.numberOfTouchesRequired=touchCount;
        [self.view addGestureRecognizer:vertical];
        
        UISwipeGestureRecognizer *horizontal=[[UISwipeGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(reportHorizontalSwipe:)];
        horizontal.direction=UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
        horizontal.numberOfTouchesRequired=touchCount;
        [self.view addGestureRecognizer:horizontal];
    }
}

- (void)updateLabelsFromTouches:(NSSet *)touches{
    NSUInteger numTaps=[[touches anyObject] tapCount];
    NSString *tapsMessage=[[NSString alloc]initWithFormat:@"%ld taps detected",(unsigned long)numTaps];
    self.tapsLabel.text=tapsMessage;
    
    NSUInteger numTouches=[touches count];
    NSString *touchMsg=[[NSString alloc] initWithFormat:@"%ld touches detected",(unsigned long)numTouches];
    self.touchesLabel.text=touchMsg;
}

#pragma mark-Touch Event Methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.messageLabel.text=@"Touches Began";
    [self updateLabelsFromTouches:event.allTouches];
    
    UITouch *touch=[touches anyObject];
    self.gestureStartPoint=[touch locationInView:self.view];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    self.messageLabel.text=@"Touches Cancelled";
    [self updateLabelsFromTouches:event.allTouches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.messageLabel.text=@"Touches Ended";
    [self updateLabelsFromTouches:event.allTouches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    self.messageLabel.text=@"Drag Detected";
    [self updateLabelsFromTouches:event.allTouches];
    
    UITouch *touch=[touches anyObject];
    CGPoint currentPosition=[touch locationInView:self.view];
    CGFloat deltaX=fabsf(self.gestureStartPoint.x-currentPosition.x);
    CGFloat deltaY=fabsf(self.gestureStartPoint.y-currentPosition.y);
    if (deltaX>=kMinimumGestureLength && deltaY<=kMaximumVariance) {
        self.label.text=@"Horizontal swipe detected";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{self.label.text=@"";
        });
    }else if (deltaY>=kMinimumGestureLength && deltaX<=kMaximumVariance){
        self.label.text=@"Vertical swipe detected";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{self.label.text=@"";
        });
    }
}

- (void)reportHorizontalSwipe:(UIGestureRecognizer *)recognizer{
//    self.label.text=@"Horizontal swipe detected";
    self.label.text=[NSString stringWithFormat:@"%@ Horizontal swipe detected",[self descriptionForTouchCount:[recognizer numberOfTouches]]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{self.label.text=@"";
    });
}

- (void)reportVerticalSwipe:(UIGestureRecognizer *)recognizer{
//    self.label.text=@"Vertical swipe detected";
    self.label.text=[NSString stringWithFormat:@"%@ Vertical swipe detected",[self descriptionForTouchCount:[recognizer numberOfTouches]]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{self.label.text=@"";
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)descriptionForTouchCount:(NSUInteger)touchCount{
    switch (touchCount) {
        case 1:
            return @"Single";
            break;
        case 2:
            return @"Double";
            break;
        case 3:
            return @"Triple";
            break;
        case 4:
            return @"Quadruple";
            break;
        case 5:
            return @"Quintuple";
            break;
        default:
            return @"";
            break;
    }
}

- (void)singleTap{
    self.singleLabel.text=@"Single Tap Detected";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{self.singleLabel.text=@"";
    });
}

- (void)doubleTap{
    self.doubleLabel.text=@"Double Tap Detected";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{self.doubleLabel.text=@"";
    });
}

- (void)tripleTap{
    self.tripleLabel.text=@"Triple Tap Detected";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{self.tripleLabel.text=@"";
    });
}

- (void)quadrupleTap{
    self.quadrupleLabel.text=@"Quadruple Tap Detected";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{self.quadrupleLabel.text=@"";
    });
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:( UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)transformImageView{
    CGAffineTransform t=CGAffineTransformMakeScale(scale * previousScale, scale * previousScale);
    t=CGAffineTransformRotate(t, rotation+previousRotation);
    self.imageView.transform=t;
}

- (void)doPinch:(UIPinchGestureRecognizer *)gesture{
    scale=gesture.scale;
    [self transformImageView];
    if (gesture.state==UIGestureRecognizerStateEnded) {
        previousScale=scale*previousScale;
        scale=1;
    }
}

- (void)doRotate:(UIRotationGestureRecognizer *)gesture{
    rotation=gesture.rotation;
    [self transformImageView];
    if (gesture.state==UIGestureRecognizerStateEnded) {
        previousRotation=rotation+previousRotation;
        rotation=0;
    }
}
@end
