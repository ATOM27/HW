//
//  EMPartyListCell.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 04.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMPartyListCell.h"
#import "ImagesManager.h"

@interface EMPartyListCell()

@property (strong, nonatomic) IBOutlet UIImageView *imageV;
@property (strong, nonatomic) IBOutlet UILabel *partyNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;


@end

@implementation EMPartyListCell

-(void)configureWithImageID:(NSString*)imageID partyName:(NSString*)partyName partyDate:(NSDate*)partyDate{
    
    NSArray* arrayWithImages  = [[ImagesManager sharedManager] arrayWithImages];

    
    self.imageV.image = [UIImage imageNamed:[arrayWithImages objectAtIndex:imageID.integerValue]];
    self.imageV.transform = CGAffineTransformMakeScale(0.7, 0.78);
    self.partyNameLabel.text = partyName;
    
    static NSDateFormatter* dateFormatter = nil;
    if (dateFormatter == nil){
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    }
    self.dateLabel.text = [dateFormatter stringFromDate:partyDate];
    
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
