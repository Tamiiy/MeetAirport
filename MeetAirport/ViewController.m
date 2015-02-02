//
//  ViewController.m
//  MeetAirport
//
//  Created by YUKIKO on 2015/01/07.
//  Copyright (c) 2015年 YukikoTamiya. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *whereLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIImage *backgroundImage  = [UIImage imageNamed:@"topImg01.jpg"];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    self.titleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:60.0f];
    self.whereLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:40.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
