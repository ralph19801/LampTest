//
//  LTTLampDetailsParameterTVCell.h
//  LampTest
//
//  Created by Garafutdinov Ravil on 05/03/2017.
//  Copyright © 2017 VMB. All rights reserved.
//

#import "LTTLamp.h"

@interface LTTLampDetailsParameterTVCell : UITableViewCell

@property (nonatomic, copy) NSString *parameterName;

@property (nonatomic, strong) IBOutlet UIButton *photoButton;
@property (nonatomic, strong) IBOutlet UIButton *graphButton;
@property (nonatomic, strong) IBOutlet UIButton *colorButton;

- (void)setParameterValue:(id)value type:(LTTLampParameterTypes)type color:(UIColor *)color;

@end
