//
//  LTTFilterEnumTVC.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 14/03/2017.
//  Copyright © 2017 LampTest. All rights reserved.
//

#import "LTTFilterEnumTVC.h"
#import "LTTFilterEnumTVCell.h"
#import "LTTFilter.h"

@interface LTTFilterEnumTVC ()

@property (nonatomic, strong) NSArray *sortedOptions;
@property (nonatomic, strong, readwrite) NSMutableSet *selectedOptions;

@end

@implementation LTTFilterEnumTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.sortedOptions = [self.filter.enumOptions.allObjects sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    if (self.filter.stringValue.length > 0) {
        NSMutableArray *strippedOptions = [NSMutableArray new];
        NSArray *options = [self.filter.stringValue componentsSeparatedByString:@","];
        for (NSString *option in options) {
            [strippedOptions addObject:[option stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"'"]]];
        }
        self.selectedOptions = [NSMutableSet setWithArray:strippedOptions];
    }
    else {
        self.selectedOptions = [NSMutableSet new];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sortedOptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LTTFilterEnumTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LTTFilterOptionCell" forIndexPath:indexPath];
    
    cell.filter = self.filter;
    cell.option = self.sortedOptions[indexPath.row];
    cell.checked = [self.selectedOptions containsObject:cell.option];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LTTFilterEnumTVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.checked) {
        cell.checked = NO;
        [self.selectedOptions removeObject:cell.option];
    }
    else {
        cell.checked = YES;
        [self.selectedOptions addObject:cell.option];
    }
}

@end
