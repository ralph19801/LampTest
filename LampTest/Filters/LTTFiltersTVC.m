//
//  LTTFiltersTVC.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 08/03/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

typedef NS_ENUM(NSUInteger, LTTSort) {
    LTTSortUnknown = 0,
    LTTSortBrandModel,
    LTTSortRating
};

#import "LTTFiltersTVC.h"
#import "LTTFilterTVCell.h"

@interface LTTFiltersTVC ()

@property (nonatomic, strong) NSArray *sections;

@end

@implementation LTTFiltersTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sections = @[
                        @[
                            @(LTTSortBrandModel),
                            @(LTTSortRating)
                        ],
                        @[
                            @0,
                            @0,
                            @0,
                            @0,
                            @0,
                            @0,
                            @0,
                        ],
                        @[
                            @0,
                            @0,
                            @0,
                            @0,
                            @0,
                            @0,
                            @0,
                        ]
                    ];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sections[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        LTTSort sort = [self.sections[indexPath.section][indexPath.row] integerValue];
        return [self sortCellForSort:sort tableView:tableView indexPath:indexPath];
    }
    else {
        return [self filterCellForSort:0 tableView:tableView indexPath:indexPath];
    }
}

- (UITableViewCell *)sortCellForSort:(LTTSort)sort tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    LTTFilterTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LTTFilterTVCell" forIndexPath:indexPath];
    
    switch (sort) {
        case LTTSortUnknown:
            break;
            
        case LTTSortBrandModel:
            cell.nameLabel.text = @"По бренду, потом по модели";
            break;
            
        case LTTSortRating:
            cell.nameLabel.text = @"По рейтингу";
            break;
    }

    return cell;
}

- (UITableViewCell *)filterCellForSort:(LTTSort)sort tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    LTTFilterTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LTTFilterTVCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 34.f;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Сортировка";
    }
    else if (section == 1) {
        return @"Фильтры";
    }
    
    return @"";
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


@end
