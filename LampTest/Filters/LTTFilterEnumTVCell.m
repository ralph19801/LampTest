//
//  LTTFilterEnumTVCell.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 14/03/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTFilterEnumTVCell.h"

@interface LTTFilterEnumTVCell()

@property (nonatomic, strong) IBOutlet UILabel *optionNameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *checkImageView;

@end

@implementation LTTFilterEnumTVCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setOption:(id)option
{
    _option = option;
    
    if ([option isKindOfClass:[NSString class]]) {
        self.optionNameLabel.text = self.option;
    }
    else if ([option isKindOfClass:[NSNumber class]]) {
        self.optionNameLabel.text = [NSString stringWithFormat:@"%li", (long)[self.option integerValue]];
    }
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    
    self.checkImageView.hidden = ( ! self.checked );
}

@end
