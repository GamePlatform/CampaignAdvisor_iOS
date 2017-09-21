#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CampaignAPIManager.h"
#import "CampaignViewController.h"
#import "CampaignManager.h"
#import "UtilForDebug.h"

FOUNDATION_EXPORT double CampaignAdvisorVersionNumber;
FOUNDATION_EXPORT const unsigned char CampaignAdvisorVersionString[];

