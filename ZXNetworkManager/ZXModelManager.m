//
//  ZXModelManager.m
//  ZXNetworkManager
//
//  Created by xinying on 2018/1/17.
//  Copyright © 2018年 habav. All rights reserved.
//

#import "ZXModelManager.h"

@implementation ZXModelManager

+ (instancetype) sharedInstance
{
    static ZXModelManager *marketModelManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        marketModelManager = [[self alloc] init];
    });
    return marketModelManager;
}

@end
