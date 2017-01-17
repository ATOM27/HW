//
//  Song.h
//  HomeWork2
//
//  Created by Eugene Mekhedov on 17.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Artist.h"

@protocol SongProtocol <NSObject>

@optional
-(void) play;

@end

@interface Song : NSObject <SongProtocol>

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) Artist* artist;

- (instancetype)initWithName:(NSString*)name text:(NSString*)text andArtist:(Artist*) artist;

@end
