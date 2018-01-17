//
//  ZXModelManager.m
//  paohon
//
//  Created by xinying on 2017/7/18.
//  Copyright © 2017年 habav. All rights reserved.
//

#import "ZXNetWorkManager.h"

#define kbaseURl @"http://www.baidu.com/"
#define salt @"212"

@implementation ZXNetWorkManager

-(AFHTTPSessionManager *)httpManager{
    
    if (!_httpManager) {
        //1，定义一个管理器
        _httpManager =[AFHTTPSessionManager manager];
        //
        _httpManager.requestSerializer =[AFJSONRequestSerializer serializer];
        //设置响应序列化,AFJSONResponseSerializer
        _httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //缺少这一句可能会有error
        _httpManager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",@"text/plain",@"image/png",nil];
    }
    return _httpManager;
}

-(void)postWithParam:(NSString *)domStr
                para:(NSDictionary *)para2Dict
         withSuccess:(void(^)(NSDictionary *responDic))successBlock
            withFail:(void(^)(NSError *error))failureBlock{
    
    [self.httpManager POST:domStr parameters:para2Dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
         NSDictionary *responDic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        successBlock(responDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}

-(void)getWithDomain:(NSString *)domStr
               para:(NSDictionary *)para2Dict
        withSuccess:(void(^)(NSDictionary *responDic))successBlock
           withFail:(void(^)(NSError *error))failureBlock{
    
    [self.httpManager GET:[NSString stringWithFormat:@"%@%@",kbaseURl,domStr] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responDic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        successBlock(responDic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}

#pragma mark - 保存请求数据
- (void)saveSortwithlink:(NSString *)reqlink ParaDic:(NSDictionary *)reqParaDic{
    
    self.reqlink =reqlink;
    self.reqDomain =[self giveSortStr:reqParaDic urlSub:reqlink];
    self.reqParaDic =reqParaDic;
}

#pragma mark - （reqParaDic 排序后) 返回一个post请求地址
- (NSString *)giveSortStr:(NSDictionary *)para2Dict urlSub:(NSString *)lk{
    
    //    NSLog(@"%@",signString);
    NSString* jsonString =[NSString stringWithFormat:@"{%@}%@",[self getSortString:para2Dict],salt];
    ZXLog(@"jsonString =%@",jsonString);
    
    return [NSString stringWithFormat:@"%@%@?sign=%@",kbaseURl,lk,[jsonString md5String]];
}

-(NSString *)getSortString:(NSDictionary *)para2Dict{
    
    //得到排序好的key值
    NSArray* allKeyArray =[para2Dict allKeys];
    NSArray* SortKeyArray =[allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        //obj1 compare:obj2。升序排列
        NSComparisonResult result =[obj1 compare:obj2];
        return result;
    }];
    ZXLog(@"SortKeyArray =%@",SortKeyArray);
    //由排好的key值 获取value值
    NSMutableArray* valueArray =[NSMutableArray array];
    for(NSString * sort in SortKeyArray){
        NSString* valueStr =[para2Dict objectForKey:sort];
        [valueArray addObject:valueStr];
    }
    ZXLog(@"valueArray =%@",valueArray);
    //拼接
    NSMutableArray *signArray = [NSMutableArray array];
    NSString *keyValue;
    for (int i = 0 ; i < SortKeyArray.count; i++) {
        if ([valueArray[i] isKindOfClass:[NSString class]]) {
            keyValue = [NSString stringWithFormat:@"\"%@\":\"%@\"",SortKeyArray[i],valueArray[i]];
        }else{
            keyValue = [NSString stringWithFormat:@"\"%@\":%@",SortKeyArray[i],valueArray[i]];
        }
        [signArray addObject:keyValue];
    }
    
    //signString用于签名的原始参数集合
    return [signArray componentsJoinedByString:@","];
}

//返回一个post请求地址
- (NSString *)givedomainStr:(NSDictionary *)para2Dict urlSub:(NSString *)lk{
    
    NSString* paraStr3 =[self ObjectTojsonString:para2Dict];
    ZXLog(@"paraStr3 =%@",paraStr3);
    NSString* parJStr2 =[NSString stringWithFormat:@"%@%@",paraStr3,salt];
    
    parJStr2 =[parJStr2 md5String];
    
    NSString*  dStr =[NSString stringWithFormat:@"%@%@?sign=%@",kbaseURl,lk,parJStr2];
    
    return dStr;
}

#pragma mark - dict字典 转向 字符串类型
-(NSString*)ObjectTojsonString:(NSDictionary *)object
{
    NSString *jsonString = [[NSString alloc]init];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"ObjectTojsonString error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"jsonString =%@",jsonString);
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    ZXLog(@"mutStr =%@",mutStr);
    NSRange range = {0,jsonString.length};
    [mutStr replaceOccurrencesOfString:@" "withString:@""options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n"withString:@""options:NSLiteralSearch range:range2];
    return mutStr;
}


-(NSString *)getBaseURL{
    return kbaseURl;
}

-(NSString *)getSalt{
    return salt;
}


@end
