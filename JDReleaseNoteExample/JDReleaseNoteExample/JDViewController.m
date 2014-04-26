//
//  JDViewController.m
//  JDReleaseNoteExample
//
//  Created by Jean-Baptiste Denoual on 06/04/2014.
//  Copyright (c) 2014 Jean-Baptiste Denoual. All rights reserved.
//

#import "JDViewController.h"
#import "JDReleaseNote.h"

@interface JDViewController ()

@end

@implementation JDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JDReleaseNote displayReleaseNoteBandIfNeeded];
    });
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
