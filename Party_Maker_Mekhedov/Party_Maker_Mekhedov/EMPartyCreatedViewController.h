//
//  EMPartyCreatedViewController.h
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 01.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMPartyCreatedViewController : UIViewController

@property (strong, nonatomic) UINavigationController* navCont;
@property (strong, nonatomic) IBOutlet UILabel *partyStatusLabel;
@property (strong, nonatomic) NSString* partyStatus;
@end
