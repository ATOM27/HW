//
//  Group.m
//  HomeWork2
//
//  Created by Eugene Mekhedov on 17.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "Group.h"

@implementation Group

-(void)printDescription{
    
    NSLog(@"Group name: %@", self.name);
    NSLog(@"List of artists: ");
    
    for (Artist* art in self.listOfArtists){
        NSLog(@"           %@", art.name);
    }
    
    NSLog(@"List of songs: ");
    for (Song* song in self.listOfSongs){
        NSLog(@"          %@", song.name);
    }
    
    Song* s = [self.listOfSongs firstObject];
    [s play];
    
}
@end
