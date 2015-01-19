//
//  AddPostViewController.h
//  MeetAirport
//
//  Created by YUKIKO on 2015/01/19.
//  Copyright (c) 2015年 YukikoTamiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPostViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *inputName;

@property (weak, nonatomic) IBOutlet UIButton *inputNationality;
@property (weak, nonatomic) IBOutlet UILabel *outputNationality;

@property (weak, nonatomic) IBOutlet UITextField *inputTitle;

@property (weak, nonatomic) IBOutlet UIButton *inputTime;
@property (weak, nonatomic) IBOutlet UILabel *outputTime;

@property (weak, nonatomic) IBOutlet UITextView *inputContents;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)insertPost:(id)sender;

@end
