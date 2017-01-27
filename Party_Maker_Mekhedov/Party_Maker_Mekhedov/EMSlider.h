//
//  EMSlider.h
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 26.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMSlider : UISlider

@property(strong, nonatomic) UILabel* timeLabel;

- (instancetype)initWithFrame:(CGRect)frame inMainView:(UIView*)mainView timeLabelFrame:(CGRect)timeLabelFrame;


@end
