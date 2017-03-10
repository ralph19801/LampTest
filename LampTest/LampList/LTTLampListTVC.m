//
//  LTTLampListTVC.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 24/02/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTLampListTVC.h"
#import "LTTLampListTVCell.h"

@interface LTTLampListTVC ()

@property (nonatomic, strong) RLMNotificationToken *notificationToken;

@end

@implementation LTTLampListTVC

- (void)setViewModel:(LTTLampListViewModel *)viewModel
{
    _viewModel = viewModel;
    
    @weakify(self);
//    self.notificationToken = [self.viewModel.lamps addNotificationBlock:^(RLMResults<LTTLamp *> *results, RLMCollectionChange *changes, NSError *error) {
//        @strongify(self);
//        if (error) {
//            NSLog(@"Failed to open Realm on background worker: %@", error);
//            return;
//        }
//        
//        UITableView *tableView = self.tableView;
//        // Initial run of the query will pass nil for the change information
//        if ( ! changes ) {
//            [tableView reloadData];
//            return;
//        }
//        
//        // Query results have changed, so apply them to the UITableView
//        [tableView beginUpdates];
//        [tableView deleteRowsAtIndexPaths:[changes deletionsInSection:0]
//                         withRowAnimation:UITableViewRowAnimationAutomatic];
//        [tableView insertRowsAtIndexPaths:[changes insertionsInSection:0]
//                         withRowAnimation:UITableViewRowAnimationAutomatic];
//        [tableView reloadRowsAtIndexPaths:[changes modificationsInSection:0]
//                         withRowAnimation:UITableViewRowAnimationAutomatic];
//        [tableView endUpdates];
//    }];
    
    [[RACObserve(self.viewModel, lamps) deliverOnMainThread]
     subscribeNext:^(id x) {
         @strongify(self);
         [self.tableView reloadData];
         [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.lamps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LTTLampListTVCell *cell = (LTTLampListTVCell *)[tableView dequeueReusableCellWithIdentifier:@"LTTLampListCell" forIndexPath:indexPath];
    
    LTTLamp *lamp = self.viewModel.lamps[indexPath.row];
    cell.lamp = lamp;
    
    return cell;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SAFE_RUN(self.onRowSelected, indexPath.row);
}

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
