//
//  UIViewController+LTTMultilineTitle.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 18/03/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "UIViewController+LTTMultilineTitle.h"
#import "UIFont+LTTFonts.h"

@implementation UIViewController (LTTMultilineTitle)

- (void)ltt_setupTitle:(NSString *)title
{
    if ( ! self.navigationItem ) {
        self.title = title;
        return;
    }
    
    CGSize textSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont ltt_singleLineNavigationBarTitleFont]}];
    CGSize screenSize = self.view.frame.size;
    
    if (textSize.width + 120 > screenSize.width) {
        [self setupDoubleLineTitle:title];
    }
    else {
        [self setupSingleLineTitle:title];
    }
}

#pragma mark Private
- (void)setupSingleLineTitle:(NSString *)title
{
    self.navigationItem.title = title;
}

- (void)setupDoubleLineTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:self.navigationController.navigationBar.bounds];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.font = [UIFont ltt_doubleLineNavigationBarTitleFont];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = title;
    
    self.navigationItem.titleView = label;
}

@end
