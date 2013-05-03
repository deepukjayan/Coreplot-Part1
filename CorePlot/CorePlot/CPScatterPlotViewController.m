//
//  CPScatterPlotViewController.m
//  CorePlot
//
//  Created by Muhammed Rashid A on 03/05/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CPScatterPlotViewController.h"

@interface CPScatterPlotViewController ()

@end

@implementation CPScatterPlotViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"ScatterPlot", @"ScatterPlot");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (UIInterfaceOrientationIsLandscape(interfaceOrientation));
}

@end
