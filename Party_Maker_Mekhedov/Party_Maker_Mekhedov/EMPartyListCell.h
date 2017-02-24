//
//  EMPartyListCell.h
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 04.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMPartyListCell : UITableViewCell


-(void)configureWithImageID:(NSString*)imageID partyName:(NSString*)partyName partyDate:(NSDate*)partyDate;
-(void)prepareForReuse;

+(NSString*)reuseIdentifier;

@end
