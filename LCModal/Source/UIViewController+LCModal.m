//
//  UIViewController+LCModal.m
//  LCModal
//
//  Created by ThXou on 01/07/15.
//  Copyright (c) 2015 iBoo Mobile. All rights reserved.
//

#import "UIViewController+LCModal.h"
#import <objc/runtime.h>

#define kLCModalOverlayTag 1000
#define kLCModalScreenshotTag 2000
#define kLCModalPresentedControllerKey @"kLCModalPresentedControllerKey"


@implementation UIViewController (LCModal)


- (UIViewController *)presentedViewControllerParent
{
    UIViewController *parent = self;
    while (parent.parentViewController) {
        parent = parent.parentViewController;
    }
    return parent;
}


- (void)lc_presentViewController:(UIViewController *)viewControllerToPresent completion:(void (^)(void))completion
{
    
    objc_setAssociatedObject(self, kLCModalPresentedControllerKey, viewControllerToPresent, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UIViewController *parent = [self presentedViewControllerParent];
    
    // adding overlay
    
    UIImageView *screenshot = [self takeScreenshot];
    screenshot.tag = kLCModalScreenshotTag;
    
    UIView *overlay = [[UIView alloc] initWithFrame:parent.view.bounds];
    overlay.backgroundColor = [UIColor blackColor];
    overlay.tag = kLCModalOverlayTag;
    [overlay addSubview:screenshot];
    [parent.view addSubview:overlay];
    
    
    // adding dismiss area
    
    CGRect dismissArea = overlay.frame;
    dismissArea.size.height = parent.view.frame.size.height - viewControllerToPresent.view.frame.size.height;
    
    UIButton *dismissAreaButton = [[UIButton alloc] initWithFrame:dismissArea];
    [dismissAreaButton addTarget:self action:@selector(dismissModal) forControlEvents:UIControlEventTouchUpInside];
    dismissAreaButton.backgroundColor = [UIColor clearColor];
    [overlay addSubview:dismissAreaButton];
    
    
    // setting rect for the view controller to be presented
    
    CGRect initialRect = viewControllerToPresent.view.frame;
    initialRect.origin.x = 0.0;
    initialRect.origin.y = parent.view.frame.size.height;
    viewControllerToPresent.view.frame = initialRect;
    
    [parent addChildViewController:viewControllerToPresent];
    [parent.view addSubview:viewControllerToPresent.view];
    [viewControllerToPresent didMoveToParentViewController:parent];
    
    
    [self animateModalOnPresentation:YES completion:completion];
}


- (void)lc_dismissViewControllerWithCompletion:(void (^)(void))completion {
    [self animateModalOnPresentation:NO completion:completion];
}



#pragma mark - Custom methods

- (void)dismissModal {
    [self lc_dismissViewControllerWithCompletion:nil];
}


- (void)animateModalOnPresentation:(BOOL)present completion:(void (^)(void))completion
{
    UIViewController *parent = [self presentedViewControllerParent];
    UIView *overlay = (UIView *)[parent.view viewWithTag:kLCModalOverlayTag];
    UIImageView *screenshot = (UIImageView *)[overlay viewWithTag:kLCModalScreenshotTag];
    
    UIViewController *presentedViewController = objc_getAssociatedObject(self, kLCModalPresentedControllerKey);
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         // scalling the presenting view controller
                         
                         CATransform3D transform = CATransform3DIdentity;
                         transform.m34 = 1.0 / -900;
                         
                         CGRect dismissArea = overlay.frame;
                         if (present)
                         {
                             dismissArea.size.height = parent.view.frame.size.height - presentedViewController.view.frame.size.height;
                             transform = CATransform3DScale(transform, 0.8, 0.8, 1);
                             screenshot.layer.transform = transform;
                             screenshot.alpha = 0.5;
                         }
                         else
                         {
                             dismissArea.size.height = parent.view.frame.size.height;
                             screenshot.layer.transform = CATransform3DIdentity;
                             screenshot.alpha = 1.0;
                         }
                         
                         CGRect newRect = presentedViewController.view.frame;
                         newRect.origin.y = dismissArea.size.height;
                         presentedViewController.view.frame = newRect;
                         
                     }
                     completion:^(BOOL finished) {
                         
                         if (!present)
                         {
                             [screenshot removeFromSuperview];
                             [overlay removeFromSuperview];
                             
                             [parent willMoveToParentViewController:nil];
                             [presentedViewController.view removeFromSuperview];
                             [presentedViewController removeFromParentViewController];
                             
                             objc_setAssociatedObject(self, kLCModalPresentedControllerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         }
                         
                         if (completion) {
                             completion();
                         }
                         
                     }];
}


- (UIImageView *)takeScreenshot
{
    UIViewController *parent = [self presentedViewControllerParent];
    
    UIGraphicsBeginImageContextWithOptions(parent.view.bounds.size, YES, [[UIScreen mainScreen] scale]);
    [parent.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *screenshot = nil;
    if (screenshot) {
        screenshot.image = image;
    }
    else
    {
        screenshot = [[UIImageView alloc] initWithImage:image];
        screenshot.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return screenshot;
}


@end
