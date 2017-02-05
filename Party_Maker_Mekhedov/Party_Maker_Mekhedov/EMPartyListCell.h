//
//  EMPartyListCell.h
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 04.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMPartyListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageV;
@property (strong, nonatomic) IBOutlet UILabel *partyNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *startPartyLabel;

-(void)configureWithImage:(UIImage*)image partyName:(NSString*)partyName partyDate:(NSDate*)partyDate partyStartTime:(NSInteger)startTime;
-(void)prepareForReuse;

+(NSString*)reuseIdentifier;

@end
