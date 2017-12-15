//
//  CampaignManager.m
//  CampaignPlatform
//
//  Created by hyeongyun on 2017. 9. 13..
//  Copyright © 2017년 hyeongyun. All rights reserved.
//

#import "CampaignManager.h"
#import "CampaignAPIManager.h"
#import "UtilForDebug.h"
#import "Campaign/CampaignViewController/CampaignViewController.h"

#define kdeviceKey @"CampaignDeviceID"
#define kanalyticsKey @"CampaignAnalytics"

@interface CampaignManager() {
    NSMutableArray *campaigns;
}

@end

@implementation CampaignManager

+ (CampaignManager *)sharedManager {
    static dispatch_once_t pred;
    static CampaignManager *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[CampaignManager alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        // do init here
//        analytics = [NSMutableArray new];
    }
    return self;
}

- (void)startCampaignAdvisor:(NSString *)appID withServer:(NSString *)serverHost {
    if (![[NSUserDefaults standardUserDefaults] stringForKey:kdeviceKey])
        [[NSUserDefaults standardUserDefaults] setObject:NSUUID.UUID.UUIDString forKey:kdeviceKey];
    if (![[NSUserDefaults standardUserDefaults] arrayForKey:kanalyticsKey])
        [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:kanalyticsKey];
    [[CampaignAPIManager sharedManager] setDeviceID:[[NSUserDefaults standardUserDefaults] stringForKey:kdeviceKey]];
    [[CampaignAPIManager sharedManager] setAppID:appID];
    [[CampaignAPIManager sharedManager] setServerHost:serverHost];
    [[CampaignAPIManager sharedManager] postDeviceInfo:kInformStr];
}

- (void)setFailNetworking:(SimpleBlock)failNetworking {
    [CampaignAPIManager.sharedManager setFailNetworking:failNetworking];
}

- (void)getCampaigns:(NSString *)locationID onVC:(UIViewController *)viewController {
    [[CampaignAPIManager sharedManager] getCampaigns:kInformStr locationID:locationID exceptCampaigns:[self getExceptArr:NSDate.date] success:^(NSURLSessionTask *task, id obj) {
        campaigns = [obj[@"campaigns"] mutableCopy];
        campaigns = [[campaigns sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
            return [obj2[@"campaign_order"] compare:obj1[@"campaign_order"]];
        }] mutableCopy];
        [self presentCampaigns:viewController];
    }];
}

- (void)presentCampaigns:(UIViewController *)viewController {
    if (campaigns.count) {
        CampaignViewController *vc = [CampaignViewController new];
        [vc setInfo:campaigns.lastObject];
        [campaigns removeLastObject];
        [vc setModalPresentationStyle:(UIModalPresentationOverCurrentContext)];
        [viewController presentViewController:vc animated:YES completion:^{
            [self presentCampaigns:vc];
        }];
    }
}

- (void)addExceptCampaign:(id)campaignID forDays:(int)days {
    for (int i = 0; i < days; i++) {
        NSDate *nextDate = [NSCalendar.currentCalendar dateByAddingUnit:NSCalendarUnitDay value:i toDate:NSDate.date options:0];
        NSMutableArray* arr = [[self getExceptArr:nextDate] mutableCopy];
        [arr addObject:campaignID];
        [NSUserDefaults.standardUserDefaults setObject:arr forKey:[self getKey:nextDate]];
    }
}

- (NSString *)getKey:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [NSString stringWithFormat:@"ExceptCampaigns_%@", [dateFormatter stringFromDate:date]];
}

- (NSArray *)getExceptArr:(NSDate *)date {
    NSString* key = [self getKey:date];
    NSArray* arr = [NSArray new];
    if ([NSUserDefaults.standardUserDefaults arrayForKey:key])
        arr = [NSUserDefaults.standardUserDefaults arrayForKey:key];
    return arr;
}

- (void)addAnalytics:(NSString *)campaignID type:(AnalyticsTypeTag)type {
    NSMutableArray* analyticsArr = [[[NSUserDefaults standardUserDefaults] arrayForKey:kanalyticsKey] mutableCopy];
    [analyticsArr addObject:@{@"campaign_id":campaignID, @"type":@(type)}];
    [[NSUserDefaults standardUserDefaults] setObject:analyticsArr forKey:kanalyticsKey];
    if (analyticsArr.count > 3) {
        DLog(@"%@", analyticsArr);
        [[CampaignAPIManager sharedManager] postAnalytics:kInformStr analytics:analyticsArr success:^(NSURLSessionTask *task, id obj) {
            [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:kanalyticsKey];
        }];
    }
}

@end
