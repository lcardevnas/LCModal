//
//  NewViewController.h
//  LCModal
//
//  Created by ThXou on 01/07/15.
//  Copyright (c) 2015 iBoo Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewViewDelegate;

@interface NewViewController : UIViewController
@property (nonatomic, weak) id <NewViewDelegate> delegate;
@end


@protocol NewViewDelegate <NSObject>

- (void)didPressedButtonInController:(NewViewController *)controller;

@end
