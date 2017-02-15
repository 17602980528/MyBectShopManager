//
//  IQIYI.h
//  iqiyi_ios_sdk_demo
//
//  Created by meiwen li on 3/6/13.
//  Copyright (c) 2013 meiwen li. All rights reserved.
//




/*
 
 错误码(error)	错误编号(error_code)	错误描述(error_description)
 
 redirect_uri_mismatch 	    A21322	重定向地址不匹配
 invalid_request	        A21323	请求不合法
 invalid_client	            A21324	client_id或client_secret参数无效
 invalid_grant	            A21325	提供的Access Grant是无效的、过期的或已撤销的
 unauthorized_client	    A21326	客户端没有权限
 expired_token	            A21327	token过期
 unsupported_grant_type	    A21328	不支持的 GrantType
 unsupported_response_type	A21329	不支持的 ResponseType
 access_denied	            A21330	用户或授权服务器拒绝授予数据访问权限
 temporarily_unavailable	A21331	服务暂时无法访问
 A00000 -- 成功
 Q00001 -- 失败
 A00002 -- AppKey非百度专用
 A00007 -- 系统错误
 "A00005"：应用待审核
 "A00007"：应用审核未通过
 "A00008"：应用被冻结
 "A00009"：应用被删除
 "A00018"：超过应用的最大配额
 */


#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#define kQIYI_QICHUANOUT @"http://qichuan.iqiyi.com"// 上传所用的主地址。 首先尝试这个地址
#define kQIYI_QICHUANOUT_BACKUP @"http://qc.iqiyi.com"//当第一个地址挂掉之后， 才使用此备胎地址
#define kQIYI_VCOPSERVER @"http://openapi.iqiyi.com" //qiyi 验证，认证等.

@class VCOPViewController;



@interface VCOPClient:NSObject {
    NSString *_ouid;
    NSString *_accessToken;
    NSDate *_expirationDate;
    NSString *_refreshToken;
    NSString *_appKey;
    NSString *_appSecret;
}

@property (nonatomic, retain) NSString *ouid;
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) NSDate *expirationDate;
@property (nonatomic, retain) NSString *refreshToken;
@property (nonatomic, retain) NSString *appKey;
@property (nonatomic, retain) NSString *appSecret;
//获取SDK版本
+(NSString *) sdkVersion;
//初始化对象
-(id)initWithAppKey:(NSString *)theApppKey
          appSecret:(NSString *)appSecret;


/*
调用此方法前， 确保已经将appkey 和 appSercet 赋值给 VcopClient 实例。
 
*/
-(void) authorizeWithOuid: (NSString *) aOuid
              nickName: (NSString *) aNickName
                  success:(void (^)(NSString* queryKey, id responseObjct))success
                  failure:(void(^)(NSString* queryKey, NSError* error))failure;

/*
系统第一次登陆后不仅获取到了accessToken， 而且获得了refreshToken.   每次在accessToken过期后， 使用refreshToken去重新获取新的accessToken和新的refreshToken ，以此类推。
 
 refreshToken也有过期时间，但无法本地判断refreshToken是否过期，开发者只需在accessToken过期后使用refreshToken去重新获取， 如果重新获取失败， 开发者请去检查错误码，如果是过期导致的，则 重新回到第一次登陆的情境。
 
 调用此方法前， 确保已经将appkey 和 appSercet 赋值给 VcopClient 实例。
 
 */
-(void) refreshTokenWithRefreshToken:(NSString *)refreshToken
                       success:(void (^)(NSString* queryKey, id responseObjct))success
                       failure:(void(^)(NSString* queryKey, NSError* error))failure;



/*/////
//啪啪奇内部团队用户授权
 
 调用此方法前， 确保已经将appkey 和 appSercet 赋值给 VcopClient 实例。
 
 */
- (void)authorizeWithUid:(NSString*)uid
                    success:(void (^)(NSString* queryKey, id responseObjct))success
                     failure:(void(^)(NSString* queryKey, NSError* error))failure;



/*/////
 ////企业用户用户授权
 
 调用此方法前， 确保已经将appkey 和 appSercet 赋值给 VcopClient 实例。
 
 */

- (void)authorizeWithSuccess:(void (^)(NSString* queryKey, id responseObjct))success
                 failure:(void(^)(NSString* queryKey, NSError* error))failure;


//登出
-(void)logOutWithSuccess:(void(^)(void))success;

//上传视频
-(void)uploadVideoWithContentOfFile:(NSString *)filePath
                           fileType:(NSString *)fileType
                             params:(NSDictionary*)params
                        threadCount:(NSInteger)threadCount
                          willStart:(void(^)(NSString* filePath,NSString* fileId))start
                           progress:(void(^)(NSString* fileId,NSNumber* percent))progress
                           complete:(void(^)(NSString* fileId,NSDictionary* videoInfo))success
                            failure:(void(^)(NSString* fileId, NSError* error))failure;
                        
//暂停上传视频
-(void) pauseUploadVideoWithfileId:(NSString*)fileId
                           success:(void(^)(NSString* fileId))success
                           failure:(void(^)(NSString* fileId, NSError* error))failure;
//继续视频上传
-(void) resumeUploadWithfileId:(NSString*)fileId
                       success:(void(^)(NSString* fileId))success
                       failure:(void(^)(NSString* fileId, NSError* error))failure;
//取消上传
-(void) cancelUploadWithfileId:(NSString*)fileId
                       success:(void(^)(NSString* fileId,id responseObj))success
                       failure:(void(^)(NSString* fileId, NSError* error))failure;

//获取视频列表
-(void)fetchVideoInfoListWithPageIndex:(NSInteger)aPageIndex
                               perPage:(NSInteger)aPageSize
                               success:(void(^)(NSString* queryKey, id responseObj))aSuccess
                               failure:(void(^)(NSString* queryKey, NSError* error))aFailure;

//获取视频的总数
-(void)fetchVideoListCountSuccess:(void(^)(NSString* queryKey, id responseObj))aSuccess
                          failure:(void(^)(NSString* queryKey, NSError* error))aFailure;

//批量获取用户视频信息
-(void)fetchVideoInfoWithFileIds:(NSArray *)fileIds
                         success:(void(^)(NSString* queryKey, id responseObj))aSuccess
                         failure:(void(^)(NSString* queryKey, NSError* error))aFailure;


//只查询单个视频信息，此接口的优势在于，可以根据返回状态码来判断该视频是否可用。
//上面的批量获取用户视频信息接口返回的状态码只用来标示该请求是否成功，无法判断视频是否可用，譬如如果请求5个视频信息，，3个可用，2个审核不通过，则返回状态码反映不出每个视频的状态。
-(void)fetchSingleVideoInfoByFileId:(NSString*)fileId
                      success:(void(^)(NSString* queryKey, id responseObj))aSuccess
                      failure:(void(^)(NSString* queryKey, NSError* error))aFailure;


//设置视频metadata
-(void)setVideoMetaDataWithFileId:(NSString *)aFileId
                           params:(NSDictionary *)aParams
                          success:(void(^)(NSString* queryKey, id responseObj))success
                          failure:(void(^)(NSString* queryKey, NSError* error))failure;

/*
//(批量)删除视频
 
 FileIds的类型必须 是 NSString  或者   NSArray  二选一。
 
 1，如果删除一条信息， FileIds传入此视频的ID。且必须是NSString
 
 2， 如果想批量删除多条视频， 则FileIds 是NSArray 类型。
*/

-(void) deleteVideoByFileId:(id)FileIds
                    success:(void(^)(NSString* queryKey, id responseObj))success
                    failure:(void(^)(NSString* queryKey, NSError* error))failure;


//根据fileID，获取视频的播放url
-(void)fetchVideoUrlStrWithFileId:(NSString *)aFileId
                         fileType:(NSString*)aFileType
                           success:(void(^)(NSString* queryKey, id responseObj))aSuccess
                           failure:(void(^)(NSString* queryKey, NSError* error))aFailure;

/*
//根据虚拟地址，获取视频的播放url
 
fileId he 
 returnedurl 返回的是真实播放地址。
*/
-(void)fetchVideoUrlStrWithViutualUrl:(NSString *)virtualUrlStr
                               fileId:(NSString *)fileId
                              success:(void(^)(NSString* queryKey, NSString* returnedurl))aSuccess
                              failure:(void(^)(NSString* queryKey, NSError* error))aFailure;


/*
获取视频的状态,包括视频是否转码成功，审核状态， 是否已经删除 等信息。打印可知更多详细信息。
 */
-(void)fetchVideoFullStatusByFileId:(NSString *)fileId
                              success:(void(^)(NSString* queryKey, id responseDict))aSuccess
                              failure:(void(^)(NSString* queryKey, NSError* error))aFailure;


//获取SDK为完成上传的视频列表
-(NSArray *) getUploadingVideoList;


- (BOOL)isLoggedIn;
@end




extern BOOL IQIYIIsDeviceIPad();