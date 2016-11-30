//
//  main.m
//  HelloWorld
//
//  Created by Joe on 4/23/16.
//  Copyright © 2016 Joe. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
/* 程序入口函数 */
int main(int argc, char * argv[])
{
    /* 自动释放池, 该环境中执行的语句会自动回收所创建的对象 */
    @autoreleasepool
    {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
