//
//  TableViewDataSource.h
//  CoreDataMagic
//

@import Foundation;
@import UIKit;
@import CoreData;

typedef void (^TableViewCellConfigureBlock)(UITableViewCell *cell, NSManagedObject *item);

@interface TableViewDataSource : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, getter=isPaused) BOOL paused;

- (instancetype)initWithTableView:(UITableView*)tableView
                          context:(NSManagedObjectContext*)context
                  reuseIdentifier:(NSString*)reuseIdentifier
           cellConfigurationBlock:(TableViewCellConfigureBlock)cellConfigurationBlock;

- (NSManagedObject*)objectAtIndex:(NSIndexPath*)indexPath;

@end
