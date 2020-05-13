typedef NS_ENUM(NSInteger, AIButtonType)
{
	AIButtonTypeSubmit,
	AIButtonTypeClear
};

@protocol AICellDelegate
@required
-(void)buttonPressed:(UIButton*)btn ofType:(AIButtonType)type;
@end
