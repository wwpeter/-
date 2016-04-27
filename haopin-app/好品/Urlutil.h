//
//  Urlutil.h
//  haopin
//
//  Created by ww on 16/4/8.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#ifndef Urlutil_h
#define Urlutil_h
//登录
#define testURL @"http://api.howshow.com/api/user/login?username=%@&password=%@&product=haoyang&devicesn=%@&sign=%@"
//#define testURL @"http://www.haoxiu.com/api/user/login?username=%@&password=%@&product=haoyang&devicesn=%@&sign=%@"
//注册
//#define Register @"http://oauth.lixy.com/api/user/register"
//#define Register @"http://www.haoxiu.com/api/user/register"
#define Register @"http://api.howshow.com/api/user/register"

//获取验证码
#define GetCode @"http://api.howshow.com/api/user/getmobilecode?mobile=%@&sign=%@"
//#define GetCode @"http://www.haoxiu.com/api/user/getmobilecode?mobile=%@&sign=%@"

//修改密码
#define Modify @"http://api.howshow.com/api/user/editpwd"
//#define Modify @"http://www.haoxiu.com/api/user/editpwd"

//找回密码
#define Back @"http://api.howshow.com/api/user/findpwd"
//#define Back @"http://www.haoxiu.com/api/user/findpwd"

#endif /* Urlutil_h */
