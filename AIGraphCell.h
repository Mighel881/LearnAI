#import "AITableCell.h"
#import <CorePlot/CorePlot.h>

@interface AIGraphCell : AITableCell
@property (nonatomic, strong) CPTGraphHostingView* graphView;
@property (nonatomic, strong) CPTXYGraph* graph;
@property (nonatomic, strong) CPTScatterPlot* plot;
-(void)setupGraphView;
-(void)createGraph;
@end
