//
//  CampaignAPIManager.m
//
//  Created by hyeongyun on 2016. 7. 25..
//
//

#import "CampaignAPIManager.h"
#import "UtilForDebug.h"

@interface CampaignAPIManager() {
    AFHTTPSessionManager *manager;
}

@end

@implementation CampaignAPIManager

+ (CampaignAPIManager *)sharedManager {
    static dispatch_once_t pred;
    static CampaignAPIManager *sharedInstance = nil;

    dispatch_once(&pred, ^{
        sharedInstance = [[CampaignAPIManager alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        // do init here
        
        manager = [AFHTTPSessionManager manager];
    }
    return self;
}

- (void)defaultGet:(NSString*)url parameters:(NSDictionary*)parameters inform:(NSString*)inform
           success:(NetworkSucBlock)successCallback failFromServer:(NetworkSucBlock)failureCallback completion:(SimpleBlock)completion {
    [[AFHTTPSessionManager manager] GET:url parameters:parameters progress:nil
                                success:^(NSURLSessionTask *task, id obj) {
                                    DLog(@"%@ success\ninform: %@\nobj: %@", url, inform, obj);
                                    if (successCallback)
                                        successCallback(task, obj);
                                    if(completion)
                                        completion();
                                }
                                failure:^(NSURLSessionTask *operation, NSError *error){
                                    DLog(@"failure: %ld\ninform: %@\noperation: %@\nerror: %@", ((NSHTTPURLResponse*)operation.response).statusCode, inform, operation, error);
                                    if(completion)
                                        completion();
                                    if (_failNetworking)
                                        _failNetworking();
                                }];
}

- (void)get:(NSString*)url parameters:(NSDictionary*)parameters inform:(NSString*)inform
    success:(NetworkSucBlock)successCallback failFromServer:(NetworkSucBlock)failureCallback completion:(SimpleBlock)completion {
    
    [manager GET:[NSString stringWithFormat:@"%@%@",_serverHost, url] parameters:parameters progress:nil
         success:^(NSURLSessionTask *task, id obj){
             DLog(@"%@ success\ninform: %@\nobj: %@", url, inform, obj);
             if ([obj[@"code"] intValue]) {
                 if (failureCallback)
                     failureCallback(task, obj);
                 else {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:url message:obj[@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alert DShow];
                 }
             }
             else {
                 if (successCallback)
                     successCallback(task, obj);
             }
             if(completion)
                 completion();
         }
         failure:^(NSURLSessionTask *operation, NSError *error){
             DLog(@"failure: %ld\ninform: %@\noperation: %@\nerror: %@", ((NSHTTPURLResponse*)operation.response).statusCode, inform, operation, error);
             if(completion)
                 completion();
             if (_failNetworking)
                 _failNetworking();
         }];
}

- (void)post:(NSString*)url parameters:(NSDictionary*)parameters inform:(NSString*)inform
    formData:(FormDataBlock)formDataCallback progress:(ProgressBlock)progressCallback
     success:(NetworkSucBlock)successCallback failFromServer:(NetworkSucBlock)failureCallback completion:(SimpleBlock)completion {
    
    [manager POST:[NSString stringWithFormat:@"%@%@",_serverHost, url] parameters:parameters
constructingBodyWithBlock:^(id<AFMultipartFormData> formData){if(formDataCallback) formDataCallback(formData);}
         progress:^(NSProgress *uploadProgress){if(progressCallback) progressCallback(uploadProgress);}
          success:^(NSURLSessionTask *task, id obj){
              DLog(@"%@ success\ninform: %@\nobj: %@", url, inform, obj);
              if ([obj[@"code"] intValue]) {
                  if (failureCallback)
                      failureCallback(task, obj);
                  else {
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:url message:obj[@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                      [alert DShow];
                  }
              }
              else {
                  if (successCallback)
                      successCallback(task, obj);
              }
              if(completion)
                  completion();
          }
          failure:^(NSURLSessionDataTask *operation, NSError *error){
              DLog(@"failure: %ld\ninform: %@\noperation: %@\nerror: %@", ((NSHTTPURLResponse*)operation.response).statusCode, inform, operation, error);
              if(completion)
                  completion();
              if (_failNetworking)
                  _failNetworking();
          }];
}

#pragma mark - All Kinds of API

- (void)getCampaigns:(NSString*)inform locationID:(NSString *)locationID exceptCampaigns:(NSArray* )ec success:(NetworkSucBlock)success {
    [self get:[NSString stringWithFormat:@"api/apps/%@/locations/%@/campaigns", _appID, locationID]
   parameters:@{@"ec":ec} inform:inform success:success failFromServer:nil completion:nil];
}

- (void)postAnalytics:(NSString*)inform analytics:(NSArray *)analytics success:(NetworkSucBlock)success {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:[NSJSONSerialization dataWithJSONObject:analytics options:NSJSONWritingPrettyPrinted error:nil] forKey:@"analytics"];
    [param setObject:_deviceID forKey:@"deviceID"];
    
    [self post:[NSString stringWithFormat:@"api/apps/%@/analytics", _appID] parameters:param inform:inform formData:nil progress:nil success:success failFromServer:nil completion:nil];
}

- (void)postDeviceInfo:(NSString*)inform {
    [self post:@"api/apps/2/locations" parameters:@{@"os":@"iOS", @"devicd_id":_deviceID, @"app_id":_appID, @"country_code":[NSLocale.currentLocale objectForKey:NSLocaleCountryCode]}
        inform:inform formData:nil progress:nil success:nil failFromServer:nil completion:nil];
}

@end
