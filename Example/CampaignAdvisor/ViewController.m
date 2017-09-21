//
//  ViewController.m
//  CampaignAdvisor
//
//  Created by mhg5303@gmail.com on 09/19/2017.
//  Copyright (c) 2017 mhg5303@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import <CampaignAdvisor/CampaignManager.h>

@interface ViewController () {
    NSMutableArray *campaigns;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self getCampaigns];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getCampaigns {
    [CampaignManager.sharedManager getCampaigns:@"main" onVC:self];
}

- (void)ad {
    NSLog(@"here is ad");
    [self presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ad"] animated:YES completion:nil];
}

@end
