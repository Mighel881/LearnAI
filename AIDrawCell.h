#import "AITableCell.h"
#import "AICanvasView.h"

@interface AIDrawCell : AITableCell
@property (nonatomic, strong) AICanvasView* canvasView;
-(void)setupCanvas;
@end
