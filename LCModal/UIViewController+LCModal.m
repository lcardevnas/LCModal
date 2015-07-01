//
//  UIViewController+LCModal.m
//  LCModal
//
//  Created by ThXou on 01/07/15.
//  Copyright (c) 2015 iBoo Mobile. All rights reserved.
//

#import "UIViewController+LCModal.h"

@implementation UIViewController (LCModal)

- (void)lc_presentViewController:(UIViewController *)viewControllerToPresent completion:(void (^)(void))completion
{
    NSLog(@"showing modal!");
    
    // adding overlay
    
    UIImageView *screenshot = [self takeScreenshot];
    
    UIView *overlay = [[UIView alloc] initWithFrame:self.view.bounds];
    overlay.backgroundColor = [UIColor blackColor];
    [overlay addSubview:screenshot];
    [self.view addSubview:overlay];
    
    
    // adding dismiss area
    
    CGRect dismissArea = overlay.frame;
    dismissArea.size.height = self.view.frame.size.height - viewControllerToPresent.view.frame.size.height;
    
    UIButton *dismissAreaButton = [[UIButton alloc] initWithFrame:dismissArea];
    [dismissAreaButton addTarget:self action:@selector(dismissModal) forControlEvents:UIControlEventTouchUpInside];
    dismissAreaButton.backgroundColor = [UIColor clearColor];
    [overlay addSubview:dismissAreaButton];
    
    
    // setting rect for the view controller to be presented
    
    CGRect initialRect = viewControllerToPresent.view.frame;
    initialRect.origin.x = 0.0;
    initialRect.origin.y = self.view.frame.size.height;
    viewControllerToPresent.view.frame = initialRect;
    
    [self addChildViewController:viewControllerToPresent];
    [self.view addSubview:viewControllerToPresent.view];
    [viewControllerToPresent didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         // scalling the presenting view controller
                         
                         CATransform3D transform = CATransform3DIdentity;
                         transform.m34 = 1.0 / -900;
                         transform = CATransform3DScale(transform, 0.8, 0.8, 1);
                         screenshot.layer.transform = transform;
                         screenshot.alpha = 0.5;
                         
                         
                         // showing the view controller to be presented
                         
                         CGRect newRect = viewControllerToPresent.view.frame;
                         newRect.origin.y = 0.0 + dismissArea.size.height;
                         viewControllerToPresent.view.frame = newRect;
                         
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"completado");
                     }];
    

}


- (void)lc_dismissViewControllerWithCompletion:(void (^)(void))completion
{
    NSLog(@"dismissing modal!");
    
    /*[self.currentSelectedController willMoveToParentViewController:nil];
    [self.currentSelectedController.view removeFromSuperview];
    [self.currentSelectedController removeFromParentViewController];*/
}



#pragma mark - Custom methods

- (void)dismissModal {
    [self lc_dismissViewControllerWithCompletion:nil];
}


- (void)animateModalOnPresentation:(BOOL)presenting
{
    
}


- (UIImageView *)takeScreenshot
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, [[UIScreen mainScreen] scale]);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
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
