//
//  CommentTableViewController.h
//  MeetAirport
//
//  Created by YUKIKO on 2015/01/26.
//  Copyright (c) 2015年 YukikoTamiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PFQuery.h"

@interface CommentTableViewController : UITableViewController

@property (nonatomic) NSString *selectedObjectId;
-(void)reload;

@end
