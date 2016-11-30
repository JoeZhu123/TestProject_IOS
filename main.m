//
//  main.m
//  HelloWorld
//
//  Created by Joe on 4/23/16.
//  Copyright © 2016 Joe. All rights reserved.
//
/* 导入 Foundation 框架下的 Foundation.h 文件 */
#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
//#import "AppDelegate.h"
/* 程序入口函数 */
int main(int argc, char * argv[])
{
    /* 自动释放池, 该环境中执行的语句会自动回收所创建的对象 */
    @autoreleasepool
    {
        /* Foundation 中的输出函数, 可输出字符串, 对象等 */
        NSLog(@"Hello World"); /* @"Hello World", 加上 @ 是为了与 C 中的字符串区分 */
    }
    return 0;
}
