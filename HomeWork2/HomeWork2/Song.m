//
//  Song.m
//  HomeWork2
//
//  Created by Eugene Mekhedov on 17.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "Song.h"

@implementation Song

- (instancetype)initWithName:(NSString*)name text:(NSString*)text andArtist:(Artist*) artist
{
    self = [super init];
    if (self) {
        
        self.name = name;
        self.text = text;
        self.artist = artist;
    }
    return self;
}

-(void)play{
    NSLog(@"Artist: %@", self.artist.name);
    NSLog(@"Song: %@", self.name);
    NSLog(@"Text: %@", self.text);
}

@end
