//
//  LTTLampListTVCell.m
//  LampTest
//
//  Created by Garafutdinov Ravil on 24/02/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTLampListTVCell.h"
#import "LTTLamp.h"

@interface LTTLampListTVCell()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *ratingLabel;

@end

@implementation LTTLampListTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setLamp:(LTTLamp *)lamp
{
    _lamp = lamp;
    
    self.titleLabel.text = lamp.model;
    self.subtitleLabel.text = lamp.brand;
    self.ratingLabel.text = [NSString stringWithFormat:@"%.1f", lamp.rating];
}

@end
