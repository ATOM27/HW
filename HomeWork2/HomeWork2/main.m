//
//  main.m
//  HomeWork2
//
//  Created by Eugene Mekhedov on 17.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Artist.h"
#import "Group.h"
#import "Song.h"
#import "NSArray+ArrayCategory.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        Artist* artist1 = [[Artist alloc] initWithName:@"Stromae"];

        Song* song1 = [[Song alloc] initWithName:@"Papoutai" text:@"Dites-moi d'où il vient,\n"
                                                               "Enfin je saurais où je vais,\n"
                                                               "Maman dit que lorsqu'on cherche bien,\n"
                                                               "On finit toujours par trouver,\n"
                                                               
                                                               "Elle dit qu'il n'est jamais très loin,\n"
                                                               "Qu'il part très souvent travaillerp,p\n"
                                                               "Maman dit travailler c'est bienp\n"
                                                               "Bien mieux qu'être mal accompagné, pas vrai ?...p\n"
                                       andArtist:artist1];
        
        Song* song2 = [[Song alloc] initWithName:@"Ta Fete" text:@"Il est l'heure, fini l'heure de danserp\n"
                                                               "Danse, t'inquiète pas tu vas danserp\n"
                                                               "Balance-toi, mais tu vas te faire balancerp\n"
                                                               "Défonce-toi, mais tu vas te faire défoncerp\n"
                                                               
                                                               "Tu aimerais faire ta fêtep\n"
                                                               "Ta mère veut te la faire aussi, ta fêtep\n"
                                                               "Le juge voudrait te faire ta fêtep\n"
                                                               "Tout le monde te fera aussi ta fêtep\n"
                                       andArtist:artist1];
        
        artist1.listOfSongs = @[song1, song2];
        
        
        
        
        Artist* artist2 = [[Artist alloc] initWithName:@"Rihanna"];
        
        Song* song3 = [[Song alloc] initWithName:@"Diamond" text:@"Shine bright like a diamondp\n"
                                                               "Shine bright like a diamondp\n"
                                                               
                                                               "Find light in the beautiful seap\n"
                                                               "I choose to be happyp\n"
                                                               "You and I, you and Ip\n"
                                                               "We’re like diamonds in the skyp\n"
                                                               
                                                               "You’re a shooting star I seep\n"
                                                               "A vision of ecstasyp\n"
                                                               "When you hold me, I’m alivep\n"
                                                               "We’re like diamonds in the skyp\n"
                                       andArtist:artist2];
        
        Song* song4 = [[Song alloc] initWithName:@"Pon De Replay" text:@"Come Mr. DJ song pon de replay\n"
                                                                       "Come Mr. DJ won't you turn the music up\n"
                                                                       "All the gyal pon the dancefloor wantin some more whatp\n"
                                                                       "Come Mr. DJ won't you turn the music upp\n"
                                                                       
                                                                       "It goes 1 by 1 even 2 by 2p\n"
                                                                       "Everybody on the floor let me show you how we dop\n"
                                                                       "Let's go dip it low then you bring it up slowp\n"
                                                                       "Wind it up 1 time wind it back once morep\n"
                                       andArtist:artist2];
        
        artist2.listOfSongs = @[song3, song4];
        
        Group* group = [[Group alloc] init];
        
        group.name = @"Group1";
        group.listOfArtists = @[artist1, artist2];
        group.listOfSongs = @[song4, song3, song2, song1];
        
        Group* group2 = [[Group alloc] init];
        
        group2.name = @"Group2";
        group2.listOfArtists = @[artist2, artist1];
        group2.listOfSongs = @[song1, song2, song3, song4];
        
        [group printDescription];
        [group2 printDescription];
        
    return 0;
    }
}
