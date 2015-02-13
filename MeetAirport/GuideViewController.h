//
//  GuideViewController.h
//  MeetAirport
//
//  Created by YUKIKO on 2015/02/13.
//  Copyright (c) 2015年 YukikoTamiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
- (IBAction)cancel:(id)sender;

@end
