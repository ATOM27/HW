//
//  EMParty.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 04.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMParty.h"

@implementation EMParty

- (instancetype)initWithDate:(NSDate*)date name:(NSString*)name startPartyTime:(NSInteger)startParty endPartyTime:(NSInteger)endParty logoPage:(NSInteger)logoPage logoImage:(UIImage*)logoImage descriptionText:(NSString*)descriptionText;
{
    self = [super init];
    if (self) {
        
        self.date = date;
        self.name = name;
        self.startParty = startParty;
        self.endParty = endParty;
        self.logoPage = logoPage;
        self.logoImage = logoImage;
        self.descriptionText = descriptionText;
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.startParty = [aDecoder decodeIntegerForKey:@"startParty"];
        self.endParty = [aDecoder decodeIntegerForKey:@"endParty"];
        self.logoPage = [aDecoder decodeIntegerForKey:@"logoPage"];
        self.logoImage = [UIImage imageWithData:[aDecoder decodeObjectForKey:@"logoImage"]];
        self.descriptionText = [aDecoder decodeObjectForKey:@"descriptionText"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.startParty forKey:@"startParty"];
    [aCoder encodeInteger:self.endParty forKey:@"endParty"];
    [aCoder encodeInteger:self.logoPage forKey:@"logoPage"];
    [aCoder encodeObject:UIImagePNGRepresentation(self.logoImage) forKey:@"logoImage"];
    [aCoder encodeObject:self.descriptionText forKey:@"descriptionText"];
    
}

@end
