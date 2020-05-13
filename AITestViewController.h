#import "AICellDelegate.h"
#import "NeuralNet.h"
@class AIDrawCell;

@interface AITestViewController : UITableViewController <AICellDelegate>
@property (nonatomic, weak) AIDrawCell* drawCell;
-(void)submitDrawing;
-(Eigen::VectorXf)vectorFromImage:(UIImage*)img;
@end
