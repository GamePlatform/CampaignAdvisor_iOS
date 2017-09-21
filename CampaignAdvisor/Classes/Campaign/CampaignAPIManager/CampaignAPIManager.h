//
//  CampaignAPIManager.h
//
//  Created by hyeongyun on 2016. 7. 25..
//
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "CampaignManager.h"

typedef void (^FormDataBlock)(id<AFMultipartFormData> formData);

@interface CampaignAPIManager : NSObject

@property (atomic, strong) NSString *serverHost;
@property (atomic, strong) NSString *appID;
@property (atomic, strong) NSString *deviceID;
@property (atomic, strong) SimpleBlock failNetworking;

+ (CampaignAPIManager *)sharedManager;

- (void)postDeviceInfo:(NSString*)inform;

- (void)getCampaigns:(NSString*)inform locationID:(NSString *)locationID success:(NetworkSucBlock)success;

- (void)postAnalytics:(NSString*)inform analytics:(NSArray *)analytics success:(NetworkSucBlock)success;

@end
