#import "BinaryHelper.h"
#import "AIGraphCell.h"

@interface AITrainViewController : UITableViewController<AICellDelegate, CPTScatterPlotDataSource>
@property (nonatomic, weak) AIGraphCell* graphCell;
@property (nonatomic, assign) std::vector<std::pair<Eigen::VectorXf, Eigen::VectorXf>> trainingSet;
-(void)startTrain;
-(void)epochCompletedWithCost:(float)cost;
@end
