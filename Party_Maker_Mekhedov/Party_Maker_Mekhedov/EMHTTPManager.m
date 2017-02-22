//
//  HTTPManager.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 08.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMHTTPManager.h"

NSString* APIURLLink;

@interface EMHTTPManager()

@property (strong, nonatomic) NSURLSession* session;

@end

@implementation EMHTTPManager

+ (EMHTTPManager *)sharedManager {
    static EMHTTPManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[EMHTTPManager alloc] init];
        if (manager) {
            APIURLLink = @"https://partymaker-softheme.herokuapp.com";//@"http://itworks.in.ua/party";
            manager.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        }
    });
    return manager;
}

#pragma mark - API

-(void)loginWithEmail:(NSString*)email password:(NSString*)password completion:(void(^)(NSDictionary* response, NSError* error))completion{
    
    NSDictionary* params = @{@"email":email,
                             @"password":password};
    
    NSDictionary* headers = @{@"Content-Type": @"application/json"};
    
    NSMutableURLRequest* request = [self getRequestWithType:@"POST" headers:headers method:@"user/login" params:params];
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }else{
            completion([self getDictionaryFromData:data], nil);
        }
    }] resume];
}

-(void)registerWithEmail:(NSString*)email password:(NSString*)password name:(NSString*)name completion:(void(^)(NSDictionary* response, NSError* error))completion{
    
    NSDictionary* params = @{@"email": email,
                             @"password": password,
                             @"name": name};
    
    NSDictionary* headers = @{@"Content-Type": @"application/json"};
    
    NSMutableURLRequest* request = [self getRequestWithType:@"POST" headers:nil method:@"user/signup" params:params];
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }else{
            completion([self getDictionaryFromData:data], nil);
        }
    }] resume];
}

-(void)partyWithCreatorID:(NSString*)creatorID completion:(void(^)(NSDictionary* response, NSError* error))completion{
    
    NSDictionary* params = @{@"creator_id":creatorID};
    NSMutableURLRequest* request = [self getRequestWithType:@"GET" headers:nil method:@"party" params:params];
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }else{
            completion([self getDictionaryFromData:data], nil);
        }
    }] resume];
}

-(void)addPartyWithID:(NSString*)partyID name:(NSString*)name startTime:(NSString*)startTime endTime:(NSString*)endTime logoID:(NSString*)logoID comment:(NSString*)comment creatorID:(NSString*)creatorID latitude:(NSString*)latitude longitude:(NSString*)longitude completion:(void(^)(NSDictionary* response, NSError* error))completion{
    
    NSDictionary* params = @{@"party_id": partyID,
                             @"name": name,
                             @"start_time": startTime,
                             @"end_time": endTime,
                             @"logo_id": logoID,
                             @"comment": comment,
                             @"creator_id":creatorID,
                             @"latitude": latitude,
                             @"longitude": longitude};
    NSMutableURLRequest* request = [self getRequestWithType:@"POST" headers:nil method:@"addParty" params:params];
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }else{
            completion([self getDictionaryFromData:data], nil);
        }
    }] resume];
}

-(void)deletePartyWithID:(NSString*)partyID creatorID:(NSString*)creatorID completion:(void(^)(NSDictionary* response, NSError* error))completion{
    
    NSDictionary* params = @{@"party_id": partyID,
                             @"creator_id": creatorID};
    
    NSMutableURLRequest* request = [self getRequestWithType:@"GET" headers:nil method:@"deleteParty" params:params];
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }else{
            completion([self getDictionaryFromData:data], nil);
        }
    }] resume];

}

-(void)getAllUsersWithCompletion:(void(^)(NSDictionary* response, NSError* error))completion{
    
    NSMutableURLRequest* request = [self getRequestWithType:@"GET" headers:nil method:@"allUsers" params:nil];
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }else{
            completion([self getDictionaryFromData:data], nil);
        }
    }] resume];
}

#pragma mark - Help methods

-(NSDictionary*)getDictionaryFromData:(NSData*) data{
    
    NSError* error;
    id dataFromServer = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if(error){
        NSLog(@"%@",[error localizedDescription]);
    }
    
    if ([dataFromServer isKindOfClass:[NSDictionary class]]){
        return dataFromServer;
    }
    NSDictionary* dict = [[NSDictionary alloc] init];
    if (dataFromServer){
        dict = @{@"response":dataFromServer};
        return dict;
    }
    
    return dict;
}


- (NSMutableURLRequest *) getRequestWithType:(NSString *) _type headers:(NSDictionary *) _headers method:(NSString *) _method params:(NSDictionary *) _params {
    NSURL *url = [NSURL URLWithString:[self GetBaseEncodedUrlWithPath:_method]];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    [req setHTTPMethod:_type];
    for (NSString *key in [_headers allKeys]) {
        [req addValue:[_headers valueForKey:key] forHTTPHeaderField:key];
    }
    
    if (_params && [_type isEqualToString:@"POST"]) {
//        for (NSString *key in [_params allKeys]) {
//            [str appendString:[NSString stringWithFormat:@"%@=%@&", key, [_params valueForKey:key]]];
//        }
//        NSData *reqData = [str dataUsingEncoding:NSUTF8StringEncoding];
        
//        NSError *error;
//        [req setHTTPBody:(error)?nil:reqData];
        req.HTTPBody = [NSJSONSerialization dataWithJSONObject:_params options:0 error:nil];
    } else if (_params) {
        NSMutableString *str = [NSMutableString stringWithFormat:@"%@?", _method];
        for (NSString *key in [_params allKeys]) {
            [str appendString:[NSString stringWithFormat:@"%@=%@&", key, [_params valueForKey:key]]];
        }
        req.URL = [NSURL URLWithString:[self GetBaseEncodedUrlWithPath:str]];
    }
    return req;
}

- (NSString *) makeDateRepresentationForAPICall:(NSDate *) _date {
    NSString *ret = [NSString stringWithFormat:@"%f", [_date timeIntervalSince1970]];
    if (ret) return ret;
    return @"";
}

-(NSString*) GetBaseEncodedUrlWithPath:(NSString*)path {
    if (!APIURLLink) {
        [NSException raise:NSInternalInconsistencyException format:@"API url link not set"];
    }
    NSString *notEncoded = [NSString stringWithFormat:@"%@/%@", APIURLLink, path];
    notEncoded = [notEncoded stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [notEncoded stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
}

@end
