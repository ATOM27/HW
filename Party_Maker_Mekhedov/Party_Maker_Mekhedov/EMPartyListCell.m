//
//  EMPartyListCell.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 04.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMPartyListCell.h"

@implementation EMPartyListCell

-(void)configureWithImageName:(NSString*)imageName partyName:(NSString*)partyName partyDate:(NSDate*)partyDate{
    
    self.imageV.image = [UIImage imageNamed:imageName];
    self.imageV.transform = CGAffineTransformMakeScale(0.7, 0.78);
    self.partyNameLabel.text = partyName;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    self.dateLabel.text = [dateFormatter stringFromDate:partyDate];
    
//    NSInteger hours = startTime/60.f;
//    NSInteger minutse = startTime - hours*60;
//    
//    NSString* resultStartTime = nil;
//    
//    if(hours >= 10){
//        resultStartTime = [NSString stringWithFormat:@"%ld:", (long)hours];
//    }else{
//        resultStartTime = [NSString stringWithFormat:@"0%ld:", (long)hours];
//    }
//    
//    if (minutse >= 10){
//        resultStartTime = [resultStartTime stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)minutse]];
//    }else{
//        resultStartTime = [resultStartTime stringByAppendingString:[NSString stringWithFormat:@"0%ld", (long)minutse]];
//    }
}

-(void)prepareForReuse{
    [super prepareForReuse];
    
    self.imageV.image = nil;
    self.partyNameLabel.text = nil;
    self.dateLabel.text = nil;
}

+(NSString*)reuseIdentifier{
    return @"Cell";
}

@end
