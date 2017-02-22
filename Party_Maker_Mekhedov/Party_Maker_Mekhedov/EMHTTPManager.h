//
//  HTTPManager.h
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 08.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMHTTPManager : NSObject

+ (EMHTTPManager *)sharedManager;

-(void)loginWithEmail:(NSString*)email password:(NSString*)password completion:(void(^)(NSDictionary* response, NSError* error))completion;
-(void)registerWithEmail:(NSString*)email password:(NSString*)password name:(NSString*)name completion:(void(^)(NSDictionary* response, NSError* error))completion;
-(void)partyWithCreatorID:(NSString*)creatorID completion:(void(^)(NSDictionary* response, NSError* error))completion;
-(void)addPartyWithID:(NSString*)partyID name:(NSString*)name startTime:(NSString*)startTime endTime:(NSString*)endTime logoID:(NSString*)logoID comment:(NSString*)comment creatorID:(NSString*)creatorID latitude:(NSString*)latitude longitude:(NSString*)longitude completion:(void(^)(NSDictionary* response, NSError* error))completion;
-(void)deletePartyWithID:(NSString*)partyID creatorID:(NSString*)creatorID completion:(void(^)(NSDictionary* response, NSError* error))completion;
-(void)getAllUsersWithCompletion:(void(^)(NSDictionary* response, NSError* error))completion;


@end
