//
//  Interface.h
//  TeacherPro
//
//  Created by DCQ on 2017/4/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#ifndef Interface_h
#define Interface_h



/*
#if 常量
...程序段1...
 
#else
...程序段2...
#endif
这里表示，如果常量为真（非0，随便什么数字，只要不是0），就执行程序段1，否则执行程序段2。
 

#if, #elif, #else, #endif
#if　条件　1
 　代码段　1
#elif 条件　2
 代码段　2
 ...
#elif 条件　n
 代码段　n
#else
 代码段 n+1
#endif
 
  #if 的一般含义是如果#if 后面的常量表达式为true，则编译它所控制的代码，如条件1成立时就代码段1，条件1不成立再看条件2是否成立，如果条件2成立则编译代码段2，否则再依次类推判断其它条件，如果条件1－N都不成力则会编译最后的代码段n+1。
 

*/

/**
 *  ********************************* 内网测试环境 ************************************
 */
#if 0

#define   Request_NameSpace_company_internal            @""//内网开发网



#define    is_production      FALSE
/**
 *  ***********************************************************************
 */
#elif 1
/**
 *  ********************************* 外网测试环境 ************************************
 */
#define    Request_NameSpace_company_internal         @""

#define    is_production      FALSE






/**
 *  ********************************* 正式环境 ************************************
 */
#else

#define     Request_NameSpace_company_internal            @""   //app 接口

#define    is_production      YES

#endif



/**
 *  ********************************* 通用 ************************************
 */
#define     HEADURL_RECOMMENDED_WEB    @"" //
#define     HEADURL_HELP_WEB         @"" //


#endif /* Interface_h */
