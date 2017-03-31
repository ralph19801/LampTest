//
//  LTTRoundButton.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 06/03/2017.
//  Copyright © 2017 LampTest. All rights reserved.
//

#import "LTTRoundButton.h"

@implementation LTTRoundButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5f;
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 3.f;
}

@end
