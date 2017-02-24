//
//  EMPartyViewController.h
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 01.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMRParty.h"

static NSString* kParties = @"parties";

@interface EMAddPartyViewController : UIViewController

@property (strong, nonatomic) PMRParty* currentParty;

// Only for map. Don't use for another controllers
@property (strong, nonatomic) NSString* latitude;
@property (strong, nonatomic) NSString* longitude;
@property (strong, nonatomic) IBOutlet UIButton *locationButton;



@end
