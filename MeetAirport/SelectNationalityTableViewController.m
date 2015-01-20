//
//  SelectNationalityTableViewController.m
//  MeetAirport
//
//  Created by YUKIKO on 2015/01/19.
//  Copyright (c) 2015年 YukikoTamiya. All rights reserved.
//

#import "SelectNationalityTableViewController.h"
#import "AddPostViewController.h"

@interface SelectNationalityTableViewController ()

@property NSArray *countries;

@end

@implementation SelectNationalityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 国表示のテストのための配列
    self.countries = [NSArray arrayWithObjects:@"Japan", @"Philippines", @"Korea", @"Thai", @"America", @"Brazil", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContriesCell" forIndexPath:indexPath];

    // 国名を取り出して一覧表示する(のちにAPI処理)
//    NSArray* names = (NSArray*)[_airportList valueForKey:@"name"];
//    NSArray* countries = (NSArray*)[_airportList valueForKey:@"country"];
    
    NSInteger row = indexPath.row;
    cell.textLabel.text = self.countries[row];
    
    return cell;
}


//-(void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger row = [[self.tableView indexPathForSelectedRow] row];
//    
//    AddPostViewController *postView = [self.storyboard instantiateViewControllerWithIdentifier:@"postView"];
//    postView.selectedNationality = self.countries[row];
//    NSLog(@"これが選択されたこくせき%@", postView.selectedNationality);
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSInteger selectedRow = [self.tableView indexPathForSelectedRow].row;
    AddPostViewController *postView = [segue destinationViewController];
    postView.selectedNationality = self.countries[selectedRow];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end