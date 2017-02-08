//
//  EMEventObject.h
//  HomeWork3
//
//  Created by Eugene Mekhedov on 20.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMEventObject : NSObject <NSCoding>

@property (strong, nonatomic) NSString* eventName;
@property (strong, nonatomic) NSDate* eventDate;
@property (strong, nonatomic) NSString* eventID;

- (instancetype)initWithEventName:(NSString*)eventName date:(NSDate*)eventDate;

@end
