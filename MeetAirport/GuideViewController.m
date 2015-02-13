//
//  GuideViewController.m
//  MeetAirport
//
//  Created by YUKIKO on 2015/02/13.
//  Copyright (c) 2015年 YukikoTamiya. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height * 2);
    [[UILabel appearance] setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:18.0f]];
}

-(void)viewDidLayoutSubviews {
    [self.scrollView setContentSize: self.contentView.bounds.size];
    [self.scrollView flashScrollIndicators];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
