//
//  Artist.h
//  HomeWork2
//
//  Created by Eugene Mekhedov on 17.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Artist : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSArray* listOfSongs;

- (instancetype)initWithName:(NSString*)name;


@end
