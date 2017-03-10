//
//  AppDelegate.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 02/01/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "AppDelegate.h"
#import "LTTMainAssembly.h"
#import "UIColor+LTTColors.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    TyphoonComponentFactory *factory = [[TyphoonBlockComponentFactory alloc] initWithAssembly:[LTTMainAssembly assembly]];
    [factory makeDefault];
    
    [self setupDatabase];
    [self setupAppearance];
    
    return YES;
}

- (void)setupDatabase
{
    BOOL notFirstLaunch = [[[NSUserDefaults standardUserDefaults] valueForKey:@"notFirstLaunch"] boolValue];
    if ( ! notFirstLaunch ) {
        NSError *error = nil;
        NSString *pathToDb = [[NSBundle mainBundle] pathForResource:@"default" ofType:@"db"];
        NSURL *base = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSString *newDbPath = [NSURL URLWithString:@"default.realm" relativeToURL:base].path;
        [[NSFileManager defaultManager] copyItemAtPath:pathToDb toPath:newDbPath error:&error];
        
        if ( ! error ) {
            NSLog(@"Database prefilled successfully");
        }
        else {
            NSLog(@"Error while prefilling database: %@", error);
        }
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"notFirstLaunch"];
    }
    
    [RLMRealmConfiguration defaultConfiguration].deleteRealmIfMigrationNeeded = YES;
    
    NSLog(@"Realm database at: %@", [RLMRealmConfiguration defaultConfiguration].fileURL);
}

- (void)setupAppearance
{
    // UINavigationBar
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                                                           NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Regular" size:17.0]}];
    
    [[UINavigationBar appearance] setTintColor:[UIColor ltt_orangeColor]];
    
    // UITabBar
    [[UITabBar appearance] setTintColor:[UIColor ltt_orangeColor]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
