//
//  LTTSettingsViewController.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 02/01/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTSettingsViewController.h"
#import "LTTLamp.h"
#import "LTTParser.h"

@interface LTTSettingsViewController ()

@property (nonatomic, strong) LTTLamp *lamp;
@property (nonatomic, assign) NSStringEncoding encoding;

@end

@implementation LTTSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (IBAction)onBtnTouch:(id)sender
{
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]
//                                              initWithBaseURL:[NSURL URLWithString:@"http://lamptest.ru/"]];
//    
//    [manager HEAD:@"led.csv" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation) {
//        NSLog(@"headers: %@", operation.response.allHeaderFields);
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        NSLog(@"error: %@", error);
//    }];
    
    LTTParser *parser = [[LTTParser alloc] init];
    [parser parse:^(NSArray *results){
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm deleteAllObjects];
            [realm addObjects:results];
        }];
    }];
}


@end
