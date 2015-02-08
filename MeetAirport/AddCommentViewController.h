//
//  AddCommentViewController.h
//  MeetAirport
//
//  Created by YUKIKO on 2015/01/27.
//  Copyright (c) 2015年 YukikoTamiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddCommentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *inputName;

@property (weak, nonatomic) IBOutlet UIButton *inputNationality;
@property (weak, nonatomic) IBOutlet UILabel *outputNationality;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
- (IBAction)changePhoto:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *inputContents;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)insertPost:(id)sender;

@property (nonatomic) NSString *selectedObjectId;


- (IBAction)cancel:(id)sender;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


@end
