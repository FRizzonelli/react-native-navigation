#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

<<<<<<< HEAD

=======
extern const NSInteger BLUR_STATUS_TAG;
extern const NSInteger BLUR_TOPBAR_TAG;
>>>>>>> v2

@interface RNNNavigationOptions : NSObject

extern const NSInteger TOP_BAR_TRANSPARENT_TAG;

@property (nonatomic, strong) NSNumber* topBarBackgroundColor;
@property (nonatomic, strong) NSNumber* topBarTextColor;
@property (nonatomic, strong) NSNumber* statusBarHidden;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSNumber* screenBackgroundColor;
@property (nonatomic, strong) NSString* topBarTextFontFamily;
@property (nonatomic, strong) NSNumber* topBarHidden;
@property (nonatomic, strong) NSNumber* topBarHideOnScroll;
@property (nonatomic, strong) NSNumber* topBarButtonColor;
@property (nonatomic, strong) NSNumber* topBarTranslucent;
@property (nonatomic, strong) NSString* tabBadge;
@property (nonatomic, strong) NSNumber* topBarTextFontSize;
<<<<<<< HEAD
@property (nonatomic, strong) NSNumber* topBarTransparent;
@property (nonatomic) int topBarTransparentTag;
@property (nonatomic, strong) NSMutableDictionary* originalTopBarImages;
@property (nonatomic, strong) NSString* backButtonTransition;
=======
@property (nonatomic, strong) id orientation;
@property (nonatomic, strong) NSArray* leftButtons;
@property (nonatomic, strong) NSArray* rightButtons;
@property (nonatomic, strong) NSNumber* topBarNoBorder;
@property (nonatomic, strong) NSNumber* statusBarBlur;
@property (nonatomic, strong) NSNumber* statusBarHideWithTopBar;
@property (nonatomic, strong) NSNumber* tabBarHidden;
@property (nonatomic, strong) NSNumber* topBarBlur;


- (UIInterfaceOrientationMask)supportedOrientations;
>>>>>>> v2

-(instancetype)init;
-(instancetype)initWithDict:(NSDictionary *)navigationOptions;

-(void)applyOn:(UIViewController*)viewController;
-(void)mergeWith:(NSDictionary*)otherOptions;
-(void)storeOriginalTopBarImages:(UIViewController*)viewController;

@end