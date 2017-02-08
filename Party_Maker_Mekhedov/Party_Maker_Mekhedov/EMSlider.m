//
//  EMSlider.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 26.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMSlider.h"
#import "UIView+CircleProperty.h"

@implementation EMSlider

- (instancetype)initWithFrame:(CGRect)frame inMainView:(UIView*) mainView timeLabelFrame:(CGRect)timeLabelFrame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.minimumValue = 0;
        self.maximumValue = 1440;
        
        self.minimumTrackTintColor = [UIColor colorWithRed:236.f/255.f green:177.f/255.f blue:29.f/255.f alpha:1.f];
        self.maximumTrackTintColor = [UIColor colorWithRed:28.f/255.f green:29.f/255.f blue:35.f/255.f alpha:1.f];
        
        UILabel* timeLabel = [[UILabel alloc] initWithFrame:timeLabelFrame];
        
        timeLabel.backgroundColor = [UIColor colorWithRed:36.f/255.f green:36.f/255.f blue:44.f/255.f alpha:1.f];
        timeLabel.text = @"00:00";
        timeLabel.font = [UIFont systemFontOfSize:11];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.layer.masksToBounds = YES;
        timeLabel.layer.cornerRadius = 5.f;
        [mainView addSubview:timeLabel];
        
        self.timeLabel = timeLabel;
        
        [self addTarget:self action:@selector(actionValueChanged:) forControlEvents:UIControlEventValueChanged];
        
    }
    return self;
}

#pragma mark - Actions

-(void)actionValueChanged:(EMSlider*) sender{
    [self showCircle];
    NSInteger hours = sender.value/60.f;
    NSInteger minutse = sender.value - hours*60;
    
    NSString* resultString = nil;
    
    if(hours >= 10){
        resultString = [NSString stringWithFormat:@"%ld:", (long)hours];
    }else{
        resultString = [NSString stringWithFormat:@"%02ld:", (long)hours];
    }
    
    if (minutse >= 10){
        resultString = [resultString stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)minutse]];
    }else{
        resultString = [resultString stringByAppendingString:[NSString stringWithFormat:@"%02ld", (long)minutse]];
    }
    
    self.timeLabel.text = resultString;

}

@end
