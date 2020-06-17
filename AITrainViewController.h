#import "BinaryHelper.h"

@interface AITrainViewController : UIViewController
@property (nonatomic, assign) std::vector<std::pair<Eigen::VectorXf, Eigen::VectorXf>> trainingSet;
-(void)startTrain;
@end
