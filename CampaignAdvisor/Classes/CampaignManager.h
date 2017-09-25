//
//  CampaignManager.h
//  CampaignPlatform
//
//  Created by hyeongyun on 2017. 9. 13..
//  Copyright © 2017년 hyeongyun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AnalyticsTypeTag) {
    AnalyticsTypeExposure = 1,
    AnalyticsTypeClick,
    AnalyticsTypePurchase
};


typedef void (^ProgressBlock)(NSProgress *uploadProgress);
typedef void (^NetworkSucBlock)(NSURLSessionTask *task, id obj);
typedef void (^ServiceResponseBlock)(NSDictionary *response, NSError *error);
typedef void (^SimpleBlock)();

@interface CampaignManager : NSObject

+ (CampaignManager *)sharedManager;

- (void)startCampaignAdvisor:(NSString *)appID withServer:(NSString *)serverHost;
- (void)setFailNetworking:(SimpleBlock)failNetworking;
- (void)getCampaigns:(NSString *)locationID onVC:(UIViewController *)viewController;
- (void)addExceptCampaign:(id)campaignID forDays:(int)days;
- (void)addAnalytics:(NSString *)campaignID type:(AnalyticsTypeTag)type;

@end
