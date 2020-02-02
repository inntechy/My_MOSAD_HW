//
//  learningTableViewController.m
//  HW3
//
//  Created by student5 on 2019/9/24.
//  Copyright © 2019 inntechy. All rights reserved.
//

#import "LearningTableViewController.h"

@interface LearningTableViewController ()

@end

@implementation LearningTableViewController

- (instancetype) initWithLanguage:(NSString*) language{
    if(self = [super initWithStyle:UITableViewStyleGrouped]){
        //设置tab的标题及图片
        _lang = language;
        self.tabBarItem.title = @"学习";
        UIImage *img1 = [[UIImage imageNamed:@"learn1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *img2 = [[UIImage imageNamed:@"learn2"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.image = img1;
        self.tabBarItem.selectedImage = img2;
        //TableView会自动生成一个tableView
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置navTitle
    [self.parentViewController.navigationItem setTitle:[NSString stringWithFormat:@"学习%@", _lang]];
}

#pragma mark - Table view data source
// tableView 中 Section 的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 8;
}
// 每个 Section 中的 Cell 个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 4;
}

// 设置每个 Cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建一个cellID，用于cell的重用
    NSString *cellID = @"cellID";
    // 从tableview的重用池里通过cellID取一个cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        // 如果tableview的重用池中没有取到，就创建一个新的cell，style为Value2，并用cellID对其进行标记。
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    // 设置 cell 的标题
    cell.textLabel.text = [NSString stringWithFormat:@"unit %ld", (long)indexPath.row + 1];
    // 设置 cell 的副标题
    //cell.detailTextLabel.text = [NSString stringWithFormat: @"section%li",(long)indexPath.section];
    return cell;
}

// 设置 section 的 header 文字
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"TOUR %li", (long)section + 1];
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
