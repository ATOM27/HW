//
//  EMPartyListViewController.h
//  Party_Maker_Mekhedov
//
//  Created by Eugene Mekhedov on 04.02.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMPartyListViewController : UIViewController

@property (strong, nonatomic) NSString* creatorID;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) NSArray* arrayWithParties;

-(void)updateTableViewWithParties;
@end
