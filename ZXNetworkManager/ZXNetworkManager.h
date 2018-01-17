//
//  ZXModelManager.h
//  paohon
//
//  Created by xinying on 2017/7/18.
//  Copyright © 2017年 habav. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "KeyChain.h"

//! Project version number for ZXNetWorkManager.
FOUNDATION_EXPORT double ZXNetworkManagerVersionNumber;

//! Project version string for ZXNetWorkManager.
FOUNDATION_EXPORT const unsigned char ZXNetworkManagerVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <ZXNetworkManager/PublicHeader.h>

@interface ZXNetWorkManager : NSObject

@property(nonatomic,strong)NSDictionary *reqParaDic;
@property(nonatomic,copy)NSString *reqlink;
@property(nonatomic,copy)NSString *reqDomain;

@property(nonatomic,strong) NSDictionary *para2Dic;
@property(nonatomic,strong) NSDictionary *para2Di2;
@property(nonatomic,assign) BOOL isRefresh;

@property(nonatomic,strong) AFHTTPSessionManager* httpManager;
#pragma mark - 保存请求数据
- (void)saveSortwithlink:(NSString *)reqlink ParaDic:(NSDictionary *)reqParaDic;

#pragma mark - （reqParaDic 排序后) 返回一个post请求地址
- (NSString *)giveSortStr:(NSDictionary *)para2Dict urlSub:(NSString *)lk;

//返回一个post请求地址
- (NSString *)givedomainStr:(NSDictionary *)para2Dict urlSub:(NSString *)lk;

//-----------少用
-(NSString *)getSortString:(NSDictionary *)para2Dict;

#pragma mark - dict字典 转向 字符串类型
-(NSString*)ObjectTojsonString:(NSDictionary *)object;

-(void)postWithParam:(NSString *)domStr  para:(NSDictionary *)para2Dict  withSuccess:(void(^)(NSDictionary *responDic))successBlock withFail:(void(^)(NSError *error))failureBlock;

-(void)getWithDomain:(NSString *)domStr
                para:(NSDictionary *)para2Dict
         withSuccess:(void(^)(NSDictionary *responDic))successBlock
            withFail:(void(^)(NSError *error))failureBlock;

-(NSString *)getBaseURL;
-(NSString *)getSalt;

@end
