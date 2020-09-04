typedef NS_ENUM(NSInteger, AIButtonType)
{
	AIButtonTypeSubmit,
	AIButtonTypeClear,
	AIButtonTypeStart,
	AIButtonTypeStop
};

@protocol AICellDelegate
@optional
-(void)buttonPressed:(UIButton*)btn ofType:(AIButtonType)type;
@end
