#import <CorePlot/CorePlot.h>
#import "BinaryHelper.h"

@interface AITrainViewController : UITableViewController
@property (nonatomic, assign) std::vector<std::pair<Eigen::VectorXf, Eigen::VectorXf>> trainingSet;
-(void)startTrain;
@end
