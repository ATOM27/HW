//
//  EMMapAnnotationFriendInfo.h
//  Party_Maker_Mekhedov
//
//  Created by intern on 2/20/17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
#import "PMRParty.h"

@interface EMMapFriendInfoAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;
@property (strong, nonatomic, nullable) PMRParty* party;

@end
