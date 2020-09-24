@protocol AISliderDelegate <NSObject>
@required
-(void)slider:(NSString*)key didChangeToValue:(NSNumber*)value;
@end

struct SliderDescriptor
{
	NSString* key;
	NSString* title;
	CGFloat min;
	CGFloat max;
	BOOL integer;
};

@interface AISliderView : UIView
-(instancetype)initWithDescriptor:(struct SliderDescriptor)descriptor delegate:(id<AISliderDelegate>)delegate;
-(void)setupSlider;
@end
