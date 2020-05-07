@class AICanvasView;

@interface AIDrawCell : UITableViewCell
@property (nonatomic, strong) AICanvasView* canvasView;
-(void)setupCanvas;
@end
