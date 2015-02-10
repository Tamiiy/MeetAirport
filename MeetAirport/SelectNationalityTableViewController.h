//
//  SelectNationalityTableViewController.h
//  MeetAirport
//
//  Created by YUKIKO on 2015/01/19.
//  Copyright (c) 2015年 YukikoTamiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectNationalityTableViewController : UITableViewController

@property (nonatomic) NSString *selectedCountry;

- (IBAction)cancel:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *searchBar;

@end
