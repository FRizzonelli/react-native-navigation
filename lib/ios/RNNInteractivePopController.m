//
//  RNNInteractivePopController.m
//  ReactNativeNavigation
//
//  Created by Elad Bogomolny on 03/09/2017.
//  Copyright © 2017 Wix. All rights reserved.
//

#import "RNNInteractivePopController.h"
#import "RNNSharedElementView.h"
#import "RNNRootViewController.h"

@interface  RNNInteractivePopController()
@property (nonatomic) CGRect topFrame;
@property (nonatomic) CGFloat percent;
@property (nonatomic) UINavigationController* nc;
@property (nonatomic) UIView* imageSnapshot;
@property (nonatomic) double totalTranslate;
@property (nonatomic) id transitionContext;

@end

@implementation RNNInteractivePopController

-(instancetype)initWithTopView:(RNNSharedElementView*)topView andBottomView:(RNNSharedElementView*)bottomView andOriginFrame:(CGRect)originFrame andViewController:(UIViewController*)vc{
	RNNInteractivePopController* interactiveController = [[RNNInteractivePopController alloc] init];
	[interactiveController setTopView:topView];
	[interactiveController setBottomView:bottomView];
	[interactiveController setOriginFrame:originFrame];
	[interactiveController setVc:vc];
	[interactiveController setNc:vc.navigationController];
	return interactiveController;
}

-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
	[super startInteractiveTransition:transitionContext];
}
-(void)handleGesture:(UIPanGestureRecognizer*)recognizer {
	CGPoint translation = [recognizer translationInView:self.topView];
	if (recognizer.state == UIGestureRecognizerStateBegan) {
		CGPoint velocity = [recognizer velocityInView:recognizer.view];
		self.nc.delegate = self;
		if (velocity.y > 0) {
			[self.nc popViewControllerAnimated:YES];
		}
	} else if (recognizer.state == UIGestureRecognizerStateChanged) {
		self.totalTranslate = self.totalTranslate + translation.y;
		[self animateAlongsideTransition:^void(id context){
			self.imageSnapshot.center = CGPointMake(self.imageSnapshot.center.x + translation.x,
													self.imageSnapshot.center.y + translation.y);
		}
							  completion:nil];
		[recognizer setTranslation:CGPointMake(0, 0) inView:self.imageSnapshot];
		if (self.totalTranslate >= 0 && self.totalTranslate <= 400.0) {
			[self updateInteractiveTransition:self.totalTranslate/400];
		}
	} else if (recognizer.state == UIGestureRecognizerStateEnded) {
		if([recognizer velocityInView:self.imageSnapshot].y < 0 || self.totalTranslate < 0) {
			[self cancelInteractiveTransition];
			[UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut  animations:^{
				self.imageSnapshot.frame = self.topFrame;
			} completion:^(BOOL finished) {
				[self.topView setHidden:NO];
				self.nc.delegate = nil;
				
			}];
		} else {
			[UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut  animations:^{
				self.imageSnapshot.frame = self.originFrame;
			} completion:^(BOOL finished) {
				self.nc.delegate = nil;
			}];
			[self finishInteractiveTransition];
		}
	}
}
- (BOOL)animateAlongsideTransition:(void (^)(id<UIViewControllerTransitionCoordinatorContext> context))animation
						completion:(void (^)(id<UIViewControllerTransitionCoordinatorContext> context))completion;{
	animation(nil);
	return YES;
}
- (void)animationEnded:(BOOL)transitionCompleted {
	
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
	return 1;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
	self.totalTranslate = 0;
	self.transitionContext = transitionContext;
	UIViewController* toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	UIViewController* fromVC  = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIView* containerView = [transitionContext containerView];
	
	toVC.view.frame = fromVC.view.frame;
	UIView* topViewContent = [self.topView subviews][0];
	UIView* imageSnapshot = [topViewContent snapshotViewAfterScreenUpdates:false];
	CGPoint fromSharedViewFrameOrigin = [topViewContent.superview convertPoint:topViewContent.frame.origin toView:nil];
	CGRect fromOriginRect = CGRectMake(fromSharedViewFrameOrigin.x, fromSharedViewFrameOrigin.y, topViewContent.frame.size.width, topViewContent.frame.size.height);
	self.topFrame = fromOriginRect;
	imageSnapshot.contentMode = UIViewContentModeScaleAspectFit;
	imageSnapshot.frame = fromOriginRect;
	imageSnapshot.clipsToBounds = true;
	self.imageSnapshot = imageSnapshot;
	
	[self.bottomView setHidden:YES];
	
	UIView* toSnapshot = [toVC.view snapshotViewAfterScreenUpdates:true];
	toSnapshot.frame = fromVC.view.frame;
	[containerView insertSubview:(UIView *)toSnapshot atIndex:1];
	[containerView addSubview:self.imageSnapshot];
	toSnapshot.alpha = 0.0;
	[self.topView setHidden:YES];
	
	[UIView animateKeyframesWithDuration:(NSTimeInterval)[self transitionDuration:transitionContext]
								   delay:0
								 options: UIViewKeyframeAnimationOptionAllowUserInteraction
							  animations:^{
								  [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 animations:^{
									  fromVC.view.alpha = 0;
									  toSnapshot.alpha = 1;
								  }];
							  }
							  completion:^(BOOL finished) {
								  [self.bottomView setHidden:NO];
								  [self.imageSnapshot removeFromSuperview];
								  [toSnapshot removeFromSuperview];
	
								  if (![transitionContext transitionWasCancelled]) {
									  [containerView addSubview: toVC.view];
									  [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
									  
								  }
								  if ([transitionContext transitionWasCancelled]) {
									  [containerView addSubview: fromVC.view];
									  [transitionContext completeTransition:NO];
								  }
							  }];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
								  animationControllerForOperation:(UINavigationControllerOperation)operation
											   fromViewController:(UIViewController*)fromVC
												 toViewController:(UIViewController*)toVC {
	
		if (operation == UINavigationControllerOperationPop) {
			return self;
		} else {
			return nil;
		}
	
	return nil;
	
}
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
						 interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
	return self;
}

@end