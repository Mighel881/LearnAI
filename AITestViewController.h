#import "AICellDelegate.h"
@class AIDrawCell;

@interface AITestViewController : UITableViewController <AICellDelegate>
@property (nonatomic, weak) AIDrawCell* drawCell;
@end
