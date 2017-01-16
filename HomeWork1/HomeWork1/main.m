//
//  main.m
//  HomeWork1
//
//  Created by Eugene Mekhedov on 16.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        BOOL checker = NO;
        
        NSArray* arrayWithSongs = [[NSArray alloc] initWithObjects: @"Papaoutai",
                                                                    @"Summertime Sadness",
                                                                    @"Diamond",
                                                                    @"Stole the show",
                                                                    @"Ta Fete", nil];
        
        NSArray* arrayWithArtists = [[NSArray alloc] initWithObjects:@"Rihanna",
                                                                     @"Kygo",
                                                                     @"Stromae",
                                                                     @"Lana Del Ray", nil];
        
  
        NSArray* arrayWithSongsAndArtists = @[@"Papaoutai - Stromae",
                                            @"Diamond - Rihanna",
                                            @"Stole the show - Kygo",
                                            @"Summertime Sadness - Lana Del Ray",
                                            @"Ta Fete - Stromae"];

        for (NSString* currentSong in arrayWithSongs){
            
            for (NSString* songAndArtist in arrayWithSongsAndArtists){
                
                if ([songAndArtist containsString:currentSong]){
                    
                    checker = YES;
                    
                    NSArray* arrayWithComponents = [songAndArtist componentsSeparatedByString:@" - "];
                    
                    NSString* object = [arrayWithComponents objectAtIndex:1];
                    NSInteger index = [arrayWithArtists indexOfObject:object];
                    
                    NSString* currentArtist = [arrayWithArtists objectAtIndex:index];
                    
                    NSLog(@"The song \"%@\" by %@", currentSong, currentArtist);
                }
                if (checker){
                    checker = NO;
                    break;
                }
            }
        }
}
    return 0;
}
