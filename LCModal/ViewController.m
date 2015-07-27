//
//  ViewController.m
//  LCModal
//
//  Created by ThXou on 01/07/15.
//  Copyright (c) 2015 iBoo Mobile. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+LCModal.h"
#import "NewViewController.h"

@interface ViewController () <NewViewDelegate>

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}



- (IBAction)showModal:(id)sender
{
    NewViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"NewViewController"];
    controller.view.frame = CGRectMake(0.0, 0.0, 320, 374);
    controller.delegate = self;
    [self lc_presentViewController:controller completion:^{
        NSLog(@"completed showing!");
    }];
}


- (void)didPressedButtonInController:(NewViewController *)controller
{
    [self lc_dismissViewControllerWithCompletion:^{
        NSLog(@"completed dismissing!");
    }];
}





@end
