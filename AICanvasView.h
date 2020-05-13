@interface AICanvasView : UIView
@property (nonatomic, strong) UIPanGestureRecognizer* gesture;
-(void)clear;
-(UIImage*)imageWithPixelSize:(CGSize)pixelSize;
@end
