//
//  EMParty.h
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 04.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

@interface EMParty : NSObject <NSCoding>

@property (strong, nonatomic) NSDate* date;
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) NSInteger startParty;
@property (assign, nonatomic) NSInteger endParty;
@property (assign, nonatomic) NSInteger logoPage;
@property (strong, nonatomic) UIImage* logoImage;
@property (strong, nonatomic) NSString* descriptionText;

- (instancetype)initWithDate:(NSDate*)date name:(NSString*)name startPartyTime:(NSInteger)startParty endPartyTime:(NSInteger)endParty logoPage:(NSInteger)logoPage logoImage:(UIImage*)logoImage descriptionText:(NSString*)descriptionText;

@end
