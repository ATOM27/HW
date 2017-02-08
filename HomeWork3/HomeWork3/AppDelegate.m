//
//  AppDelegate.m
//  HomeWork3
//
//  Created by Eugene Mekhedov on 20.01.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "AppDelegate.h"
#import "EMEventObject.h"

@interface AppDelegate ()

@property (strong, nonatomic) NSMutableArray* arrayForObjects;

@end

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSString* funcName = [NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__];
    
    [self createEventObjectWithEventName:funcName date:[NSDate date]];
    [self createPlist];
    [self readInfoPlist];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.arrayForObjects = [[NSMutableArray alloc] init];
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"data"];
    if (data) {
        self.arrayForObjects = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    

    [self readInfoPlist];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSString* funcName = [NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__];
    
    [self createEventObjectWithEventName:funcName date:[NSDate date]];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSString* funcName = [NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__];
    [self readInfoPlist];
    [self createEventObjectWithEventName:funcName date:[NSDate date]];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self readInfoPlist];
    
    NSString* funcName = [NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__];
    
    [self createEventObjectWithEventName:funcName date:[NSDate date]];
    
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self.arrayForObjects];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"data"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    documentsPath = [documentsPath stringByAppendingPathComponent:@"logs.plist"];
    [data writeToFile:documentsPath atomically:YES];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self readInfoPlist];
    NSString* funcName = [NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__];
    
    [self createEventObjectWithEventName:funcName date:[NSDate date]];

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self readInfoPlist];
    NSString* funcName = [NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__];
    
    [self createEventObjectWithEventName:funcName date:[NSDate date]];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self readInfoPlist];
    NSString* funcName = [NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__];
    
    [self createEventObjectWithEventName:funcName date:[NSDate date]];
}

#pragma mark - EMEventObject help

-(void) createEventObjectWithEventName:(NSString*)eventName date:(NSDate*)eventDate{
    
    EMEventObject* obj = [[EMEventObject alloc] initWithEventName:eventName date:eventDate];
    [self.arrayForObjects addObject:obj];
    
}

-(void)createPlist{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString* bundleString = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"logs.plist"];
    
    
    //NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:@"/Users/eugenemekhedov/Documents/logs.plist"];
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:bundleString];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    documentsPath = [documentsPath stringByAppendingPathComponent:@"logs.plist"];
    BOOL writtenSuccessfully;
    
    if(![fileManager fileExistsAtPath:documentsPath]){
        writtenSuccessfully = [plistDictionary writeToFile:documentsPath atomically:YES];
    }
    
    NSLog(@"Written:%d",writtenSuccessfully);
}

-(void)readInfoPlist{
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];

    NSLog(@"%%%@%%(%%%@%%)", [infoDict objectForKey:(__bridge NSString*)kCFBundleVersionKey], [infoDict objectForKey:@"CFBundleShortVersionString"]);
}

- (void)resetDefaults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}

@end
