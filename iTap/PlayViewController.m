//
//  PlayViewController.m
//  iTap
//
//  Created by Deepak on 6/13/14.
//  Copyright (c) 2014 Amvrin Systems Pvt .Ltd. All rights reserved.
//

#import "PlayViewController.h"

#import "KKProgressTimer.h"

@interface PlayViewController () <KKProgressTimerDelegate>
@property (weak, nonatomic) IBOutlet KKProgressTimer *timer1;
@property (strong, nonatomic) IBOutlet UILabel *lblTapCount;
@property (strong, nonatomic) IBOutlet UILabel *lblCountdown;
@property (strong, nonatomic) IBOutlet UIButton *btnShareOnFacebook;
@property (strong, nonatomic) IBOutlet UIButton *btnRestartGame;

@end

@implementation PlayViewController
@synthesize lblTapCount,timer1,btnShareOnFacebook,lblCountdown,btnRestartGame;

bool stop;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   
    UITapGestureRecognizer *recognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
    recognizer.cancelsTouchesInView=NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.view.userInteractionEnabled = NO;
    btnRestartGame.hidden = YES;
    lblCountdown.hidden = NO;
    lblTapCount.text = @"0";
    lblCountdown.text = @"5";
    [self performSelector:@selector(countDownTimer) withObject:nil afterDelay:1.0];
}

-(void)countDownTimer
{
    if ([lblCountdown.text intValue] == 0)
    {
        lblCountdown.hidden = YES;
        [self performSelector:@selector(StartGame) withObject:nil afterDelay:0.1];
    }
    else
    {
        lblCountdown.hidden = NO;
        lblCountdown.text = [NSString stringWithFormat:@"%i",[lblCountdown.text intValue]-1];
        [self performSelector:@selector(countDownTimer) withObject:nil afterDelay:1.0];
    }
    
}

-(IBAction)restartGame:(id)sender
{
    [self viewWillAppear:YES];
}
-(void)StartGame
{
    self.view.userInteractionEnabled = YES;
    stop = NO;
    self.timer1.delegate = self;
    self.timer1.tag = 1;
    
    __block CGFloat i1 = 0;
    [self.timer1 startWithBlock:^CGFloat {
        return i1++ / 600;
    }];
}

-(void)tap
{
    lblTapCount.text = [NSString stringWithFormat:@"%i",[lblTapCount.text intValue]+1];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // Disallow recognition of tap gestures in the segmented control.
    if ((touch.view == btnShareOnFacebook) || (touch.view == btnRestartGame) || stop)
    {
        return NO;
    }
    return YES;
}

#pragma mark KKProgressTimerDelegate Method
- (void)didUpdateProgressTimer:(KKProgressTimer *)progressTimer percentage:(CGFloat)percentage {
    switch (progressTimer.tag) {
        case 1:
            if (percentage >= 1) {
                stop = YES;
                btnRestartGame.hidden = NO;
                [progressTimer stop];
            }
            break;
        default:
            break;
    }
}

- (void)didStopProgressTimer:(KKProgressTimer *)progressTimer percentage:(CGFloat)percentage {
    NSLog(@"%s %f", __PRETTY_FUNCTION__, percentage);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
