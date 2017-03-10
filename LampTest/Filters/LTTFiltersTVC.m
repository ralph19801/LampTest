//
//  LTTFiltersTVC.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 08/03/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTFiltersTVC.h"
#import "LTTFilterManager.h"

#import "LTTFilterTVCell.h"
#import "LTTSortEnum.h"

typedef NS_ENUM(NSUInteger, LTTFiltersSection) {
    LTTFiltersSectionUnknown = -1,
    LTTFiltersSectionSort = 0,
    LTTFiltersSectionActive = 1,
    LTTFiltersSectionPool
};

@interface LTTFiltersTVC ()

@property (nonatomic, strong) NSArray *sections;

@end

@implementation LTTFiltersTVC

- (void)viewDidLoad
{
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

#pragma mark - Cell creation
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
    NSString *identifier = nil;
    if (self.filterManager.sort == sort) {
        identifier = @"LTTSortOn";
    }
    else {
        identifier = @"LTTSortOff";
    }
    
    LTTFilterTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
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

#pragma mark - Selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == LTTFiltersSectionSort) {
        [self didSelectSortForTableView:tableView indexPath:indexPath];
    }
}

- (void)didSelectSortForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    LTTSort sort = [self.sections[indexPath.section][indexPath.row] integerValue];
    if (sort == self.filterManager.sort) {
        return;
    }
    
    self.filterManager.sort = sort;
    [tableView reloadData];
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
