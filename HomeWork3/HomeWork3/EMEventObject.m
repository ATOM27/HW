//
//  EMEventObject.m
//  HomeWork3
//
//  Created by Eugene Mekhedov on 20.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMEventObject.h"

@implementation EMEventObject

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    self = [super init];
    if (self) {
        
        self.eventName = [aDecoder decodeObjectForKey:@"eventName"];
        self.eventDate = [aDecoder decodeObjectForKey:@"eventDate"];
        self.eventID = [aDecoder decodeObjectForKey:@"eventID"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder*)aCoder{
    
    [aCoder encodeObject:self.eventName forKey:@"eventName"];
    [aCoder encodeObject:self.eventDate forKey:@"eventDate"];
    [aCoder encodeObject:self.eventID forKey:@"eventID"];
}

- (instancetype)initWithEventName:(NSString*)eventName date:(NSDate*)eventDate
{
    self = [super init];
    if (self) {
        
        self.eventName = eventName;
        self.eventDate = eventDate;
        self.eventID = [[NSUUID UUID] UUIDString];

    }
    return self;
}
@end
