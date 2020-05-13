#import "AICellDelegate.h"

@interface AITableCell : UITableViewCell
@property (nonatomic, weak) id<AICellDelegate> delegate;
@end
