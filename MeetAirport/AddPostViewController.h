//
//  AddPostViewController.h
//  MeetAirport
//
//  Created by YUKIKO on 2015/01/19.
//  Copyright (c) 2015年 YukikoTamiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPostViewController : UIViewController <UIActionSheetDelegate> {
    UIActionSheet *basicSheet;
}

@property (weak, nonatomic) IBOutlet UITextField *inputName;

@property (weak, nonatomic) IBOutlet UIButton *inputNationality;
//- (void)setNationality:(NSString *)selectedNationality;
@property (weak, nonatomic) NSString *selectedNationality;
@property (weak, nonatomic) IBOutlet UILabel *outputNationality;


@property (weak, nonatomic) IBOutlet UIImageView *userImage;
- (IBAction)changePhoto:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *inputTitle;

@property (weak, nonatomic) IBOutlet UIButton *inputTime;
- (IBAction)actionDatePicker:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *outputTime;

@property (weak, nonatomic) IBOutlet UITextView *inputContents;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)insertPost:(id)sender;

@end
