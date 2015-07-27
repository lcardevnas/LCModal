//
//  UIViewController+LCModal.h
//  LCModal
//
//  Created by ThXou on 01/07/15.
//  Copyright (c) 2015 iBoo Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIViewController (LCModal)

- (void)lc_presentViewController:(UIViewController *)viewControllerToPresent completion:(void (^)(void))completion;
- (void)lc_dismissViewControllerWithCompletion:(void (^)(void))completion;

@end
