//
//  Group.h
//  HomeWork2
//
//  Created by Eugene Mekhedov on 17.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Artist.h"
#import "Song.h"

@interface Group : Artist

@property (strong, nonatomic) NSArray* listOfArtists;

-(void)printDescription;
@end
