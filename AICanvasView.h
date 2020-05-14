@interface AICanvasView : UIView
@property (nonatomic, strong) UIPanGestureRecognizer* gesture;
-(void)clear;
-(UIImage*)captureImage;
@end
