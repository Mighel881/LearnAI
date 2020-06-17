#import "AICellDelegate.h"
#import "NeuralNet.h"
@class AIDrawCell;

@interface AITestViewController : UITableViewController <AICellDelegate>
@property (nonatomic, weak) AIDrawCell* drawCell;
@property (nonatomic, assign) NeuralNet* network;
-(void)loadNetworkWithWeights:(NSString*)weightPath;
-(void)submitDrawing;
-(Eigen::VectorXf)vectorFromImage:(UIImage*)img;
@end
