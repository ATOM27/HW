//
//  EMPartyInfoViewController.h
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 19.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMRParty.h"

@interface EMPartyInfoViewController : UIViewController

@property(strong, nonatomic) NSString* creatorID;
@property(strong, nonatomic) PMRParty* currentParty;

@end
