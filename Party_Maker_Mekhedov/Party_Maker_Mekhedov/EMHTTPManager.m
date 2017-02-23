//
//  HTTPManager.m
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 08.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMHTTPManager.h"
#import "NSObject+ActivityIndicator.h"

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
    [self activityIndicatorIsVisible:YES];
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
        [self activityIndicatorIsVisible:NO];
    }] resume];
}

-(void)registerWithEmail:(NSString*)email password:(NSString*)password name:(NSString*)name completion:(void(^)(NSDictionary* response, NSError* error))completion{
    [self activityIndicatorIsVisible:YES];
    NSDictionary* params = @{@"email": email,
                             @"password": password,
                             @"name": name};
    
    NSDictionary* headers = @{@"Content-Type": @"application/json"};
    
    NSMutableURLRequest* request = [self getRequestWithType:@"POST" headers:headers method:@"user/signup" params:params];
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }else{
            completion([self getDictionaryFromData:data], nil);
        }
        [self activityIndicatorIsVisible:NO];
    }] resume];
}

-(void)getPartiesWithCompletion:(void(^)(NSDictionary* response, NSError* error))completion{
    [self activityIndicatorIsVisible:YES];
    NSDictionary* headers = @{@"accessToken":[[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]};
    
    NSMutableURLRequest* request = [self getRequestWithType:@"GET" headers:headers method:@"party" params:nil];
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }else{
            completion([self getDictionaryFromData:data], nil);
        }
        [self activityIndicatorIsVisible:NO];
    }] resume];
}

-(void)addPartyWithName:(NSString*)name startTime:(NSString*)startTime endTime:(NSString*)endTime logoID:(NSString*)logoID comment:(NSString*)comment latitude:(NSString*)latitude longitude:(NSString*)longitude completion:(void(^)(NSDictionary* response, NSError* error))completion{
    
    [self activityIndicatorIsVisible:YES];
    
    NSNumber* lLatitude = [self checkLatitude:latitude];
    NSNumber* lLongtitude = [self checkLongtitude:longitude];
    
    NSDictionary* params = @{@"name": name,
                             @"start_time":[NSNumber numberWithDouble:startTime.doubleValue],
                             @"end_time": [NSNumber numberWithDouble:endTime.doubleValue],
                             @"logo_id": [NSNumber numberWithInteger:logoID.integerValue],
                             @"comment": comment,
                             @"latitude": lLatitude,
                             @"longitude": lLongtitude};
    
    NSDictionary* headers = @{@"Content-Type": @"application/json",
                              @"accessToken":[[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"] };
    
    NSMutableURLRequest* request = [self getRequestWithType:@"POST" headers:headers method:@"party" params:params];
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }else{
            completion([self getDictionaryFromData:data], nil);
        }
        [self activityIndicatorIsVisible:NO];
    }] resume];
}

-(void)editPartyWithID:(NSString*)partyID name:(NSString*)name startTime:(NSString*)startTime endTime:(NSString*)endTime logoID:(NSString*)logoID comment:(NSString*)comment latitude:(NSString*)latitude longitude:(NSString*)longitude completion:(void(^)(NSDictionary* response, NSError* error))completion{
    
    [self activityIndicatorIsVisible:YES];
    
    NSNumber* lLatitude = [self checkLatitude:latitude];
    NSNumber* lLongtitude = [self checkLongtitude:longitude];
    
    NSDictionary* params = @{@"name": name,
                             @"start_time":[NSNumber numberWithDouble:startTime.doubleValue],
                             @"end_time": [NSNumber numberWithDouble:endTime.doubleValue],
                             @"logo_id": [NSNumber numberWithInteger:logoID.integerValue],
                             @"comment": comment,
                             @"latitude": lLatitude,
                             @"longitude": lLongtitude};
    
    NSDictionary* headers = @{@"Content-Type": @"application/json",
                              @"accessToken":[[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"] };
    NSString* method = [NSString stringWithFormat:@"party/%@",partyID];
    NSMutableURLRequest* request = [self getRequestWithType:@"PATCH" headers:headers method:method params:params];
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }else{
            completion([self getDictionaryFromData:data], nil);
        }
        [self activityIndicatorIsVisible:NO];
    }] resume];
}


-(void)deletePartyWithID:(NSString*)partyID completion:(void(^)(NSDictionary* response, NSError* error))completion{
    
    [self activityIndicatorIsVisible:YES];
    
    NSDictionary* params = @{@"party_id": partyID};
    
    NSDictionary* headers = @{@"Content-Type": @"application/json",
                              @"accessToken":[[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"] };

    NSMutableURLRequest* request = [self getRequestWithType:@"DELETE" headers:headers method:@"party" params:params];
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }else{
            completion([self getDictionaryFromData:data], nil);
        }
        [self activityIndicatorIsVisible:NO];
    }] resume];

}

-(void)getAllUsersWithCompletion:(void(^)(NSDictionary* response, NSError* error))completion{
    
    [self activityIndicatorIsVisible:YES];
    
    NSDictionary* headers = @{@"Content-Type": @"application/json",
                              @"accessToken":[[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"] };
    
    NSMutableURLRequest* request = [self getRequestWithType:@"GET" headers:headers method:@"user" params:nil];
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }else{
            completion([self getDictionaryFromData:data], nil);
        }
        [self activityIndicatorIsVisible:NO];
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
    } else if ([_type isEqualToString:@"GET"]) {
        NSMutableString *str = [NSMutableString stringWithFormat:@"%@?", _method];
        for (NSString *key in [_params allKeys]) {
            [str appendString:[NSString stringWithFormat:@"%@=%@&", key, [_params valueForKey:key]]];
        }
        req.URL = [NSURL URLWithString:[self GetBaseEncodedUrlWithPath:str]];
    }else if (_params && [_type isEqualToString:@"PATCH"]){
        req.HTTPBody = [NSJSONSerialization dataWithJSONObject:_params options:0 error:nil];
        NSMutableString *str = [NSMutableString stringWithFormat:@"%@?", _method];
         req.URL = [NSURL URLWithString:[self GetBaseEncodedUrlWithPath:str]];
    }else if ([_type isEqualToString:@"DELETE"]){
        NSMutableString *str = [NSMutableString stringWithFormat:@"%@", _method];
        for (NSString *key in [_params allKeys]) {
            str = [str stringByAppendingPathComponent:[_params valueForKey: key]];
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

-(NSNumber*)checkLatitude:(NSString*)latitude{
    NSNumber* lLatitude;
    if([latitude isEqualToString:@""]){
        lLatitude = [NSNumber numberWithDouble:0.0];
    }else{
        lLatitude = [NSNumber numberWithDouble:latitude.doubleValue];
    }
    return lLatitude;
}

-(NSNumber*)checkLongtitude:(NSString*)longtitude{
    NSNumber* lLongtitude;
    if([longtitude isEqualToString:@""]){
        lLongtitude = [NSNumber numberWithDouble:0.0];
    }else{
        lLongtitude = [NSNumber numberWithDouble:longtitude.doubleValue];
    }
    return lLongtitude;
}

@end
