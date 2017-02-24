//
//  PMRParty+initWithDictionary.m
//  PartyMaker
//
//  Copyright © 2017 Softheme. All rights reserved.
//

#import "PMRParty+initWithDictionary.h"

@implementation PMRParty (initWithDictionary)

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    
    NSString* latitude = [dictionary[@"latitude"] stringValue];
    NSString* longitude = [dictionary[@"longitude"] stringValue];
    
    if(([dictionary[@"latitude"] doubleValue] <= 0.00002) && ([dictionary[@"latitude"] doubleValue] > 0)){
        latitude = @"";
    }
    
    if(([dictionary[@"longitude"] doubleValue] <= 0.00002) && ([dictionary[@"longitude"] doubleValue] > 0)){
        longitude = @"";
    }
    
    
    return [self initWithPartyID:[dictionary[@"id"] stringValue]
                            name:dictionary[@"name"]
                       startDate:[NSDate dateWithTimeIntervalSince1970:([dictionary[@"start_time"] doubleValue])]
                         endDate:[NSDate dateWithTimeIntervalSince1970:([dictionary[@"end_time"] doubleValue])]
                          logoID:[dictionary[@"logo_id"] stringValue]
                 descriptionText:dictionary[@"comment"]
                    creationDate:[NSDate date]//dictionary[@"creationDate"]
                modificationDate:[NSDate date]//dictionary[@"modificationDate"]
                       creatorID:[dictionary[@"creator_id"] stringValue]
                        latitude:latitude
                      longtitude:longitude];
}

@end
