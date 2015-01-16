//
//  ViewController.m
//  MeetAirport
//
//  Created by YUKIKO on 2015/01/07.
//  Copyright (c) 2015年 YukikoTamiya. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //------------------------------------------
    //  検証テスト(のちに削除する)
    //------------------------------------------
    
    // DB書き込みテスト - SUCCESS!
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    testObject[@"foo"] = @"bar";
//    [testObject saveInBackground];

    // DB読み込みテスト - SUCCESS!
//    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
//    [query getObjectInBackgroundWithId:@"Oj6tj81LrS" block:^(PFObject *object, NSError *error) {
//        _testLabel.text = object[@"Name"];
//    }];
    
    //空港一覧取得のAPIテスト - SUCCESS!
//    NSURL *url = [NSURL URLWithString:@"https://gist.githubusercontent.com/tdreyno/4278655/raw/755b1cfc5ded72d7b45f97b9c7295d525be18780/airports.json"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSData *json_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingAllowFragments error:nil];
//    // AirPort名だけ取り出して一覧表示する
//    NSArray* names = (NSArray*)[jsonObject valueForKey:@"name"];
//    for (NSDictionary* name in names) {
//        NSLog(@"%@",name);
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
