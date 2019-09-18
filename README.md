# CampaignAdvisor

[![CI Status](http://img.shields.io/travis/mhg5303@gmail.com/CampaignAdvisor.svg?style=flat)](https://travis-ci.org/mhg5303@gmail.com/CampaignAdvisor)
[![Version](https://img.shields.io/cocoapods/v/CampaignAdvisor.svg?style=flat)](http://cocoapods.org/pods/CampaignAdvisor)
[![License](https://img.shields.io/cocoapods/l/CampaignAdvisor.svg?style=flat)](http://cocoapods.org/pods/CampaignAdvisor)
[![Platform](https://img.shields.io/cocoapods/p/CampaignAdvisor.svg?style=flat)](http://cocoapods.org/pods/CampaignAdvisor)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 8.0 or later

## Installation

CampaignAdvisor is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CampaignAdvisor'
```

## Getting Started

- Read the [Campaign-Server README](https://github.com/GamePlatform/Campaign-Server)

#### Setting in Appdelegate

######다음과 같이 헤더를 추가하고, didFinishLaunchingWithOptions에서 [CampaignManager.sharedManager startCampaignAdvisor:<#(NSString *)#> withServer:<#(NSString *)#>]에 앱에 해당하는 id와 서버주소를 적어줍니다.
######[CampaignManager.sharedManager setFailNetworking:<#^(void)failNetworking#>]에는 서버 접근 하지 못하는 등의 에러가 발생했을때의 처리를 적어줍니다.

```objective-c
#import <CampaignAdvisor/CampaignManager.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.

	[CampaignManager.sharedManager startCampaignAdvisor:@"app_info Table's id" withServer:@"http://url"];
	[CampaignManager.sharedManager setFailNetworking:^{
		NSLog(@"");
	}];
	return YES;
}
```
#### Usage

######광고를 가져와야 할 때에 다음과 같은 함수를 호출합니다. [CampaignManager.sharedManager getCampaigns:<#(NSString *)#> onVC:<#(UIViewController *)#>] 이때 첫번째 파라미터는 location_for_app테이블의 location_id이며 두번째 파라미터는 광고를 띄울 뷰컨트롤러입니다.

```objective-c
[CampaignManager.sharedManager getCampaigns:@"location_for_app_ location_id" onVC:viewController];
```

######campaign_info테이블의 redirect_location에 이름을 맞추어 위에 적은 뷰컨트롤러에서 연결된 세그의 이름을 동일하게 하거나 실행될 함수를 작성합니다.

## Author

mhg5303@gmail.com

## License

CampaignAdvisor is available under the MIT license. See the LICENSE file for more info.

