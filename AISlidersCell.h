#import "AITableCell.h"
#import "AISliderView.h"

@interface AISlidersCell : AITableCell <AISliderDelegate>
-(void)setupSliders;
-(void)slider:(NSString*)key didChangeToValue:(NSNumber*)value;
@end
