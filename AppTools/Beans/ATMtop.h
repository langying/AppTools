//
//  TBMtopTool.h
//  TBImageCache
//
//  Created by 韩 琼 on 13-10-9.
//  Copyright (c) 2013年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 最新地址：http://tbdocs.alibaba-inc.com/pages/viewpage.action?pageId=194125274
 */
@interface ATMtop : NSObject

/**
 * http://dev.wireless.taobao.net/mediawiki/index.php?title=API3.0%E8%B0%83%E7%94%A8%E8%AF%B4%E6%98%8E
 * 完整格式:api={api}&v={v}&t={t}&imei={imei}&imsi={imsi}&appKey={appKey}&data={data}&sign={sign}&sid={sid}&deviceId={deviceId}&lng={lng}&lat={lat}
 * 必填参数:api,v,t,imei,imsi,appKey,sign
 * 可选参数:deviceId, lng, lat
 * data:具体的data内容由各个api具体定义，data参数不能为空，当没有参数时传递data={}
 * ecode 根据API的需求，可以选择为空
 */
+(NSString*)urlWithAPI:(NSString*)api version:(NSString*)version sid:(NSString*)sid ecode:(NSString*)ecode data:(NSDictionary*)datas;

/**
 * http://dev.wireless.taobao.net/mediawiki/index.php?title=API3.0%E8%B0%83%E7%94%A8%E8%AF%B4%E6%98%8E
 * 完整格式:api={api}&v={v}&t={t}&imei={imei}&imsi={imsi}&appKey={appKey}&data={data}&sign={sign}&sid={sid}&deviceId={deviceId}&lng={lng}&lat={lat}
 * 必填参数:api,v,t,imei,imsi,appKey,sign
 * 可选参数:deviceId, lng, lat
 * data:具体的data内容由各个api具体定义，data参数不能为空，当没有参数时传递data={}
 * ecode 根据API的需求，可以选择为空
 */
+(NSDictionary*)paramsWithAPI:(NSString*)api version:(NSString*)version sid:(NSString*)sid ecode:(NSString*)ecode data:(NSDictionary*)datas;

@end
