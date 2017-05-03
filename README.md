# [MGDS_Swift](http://www.jianshu.com/p/a2212b045094#comment-10133305)
逗视iOS客户端: 在这一个高速运转的社会中,大家真的太忙了,没有了欢笑,没有了生活！ 但是我们生活中不能缺少欢乐，搞笑！那么，逗视来了！！ 你可以在逗视中看到海量的搞笑，恶搞的精彩视频，秒拍，美拍等热门视频。 逗视首页分类包括推荐，精华，热门等满足更多人的需求！ 逗视在发现页面有排行榜功能，看看哪些视频大家都在看！ 逗视中的视频可以分享到QQ，微信，微博等社交平台，与你的朋友一起欢乐！ 逗视可以说是搞笑视频全聚合！！！一定会让你爱不离手的！！ 让我们回到以前的自己，天天高高兴兴，让我们开怀大笑吧！！！ 支持3DTouch 手势，快捷菜单：我的收藏，排行榜
***

- # 第一步：
 - 下载项目,其实第二步可以不用了，下载下来的代码中已经包含framework，解压即可IJKframework,拖入项目
 
 ---
- # 第二步：
 - 下载framework，拖入项目
 - 链接: https://pan.baidu.com/s/1boWHvht 密码: hu7a
 
 ***
- # 第三步：
 - 解压framework，拖入项目，运行项目即可
 如果拖入项目报这个错，记得Ctrl + Shift + K 清除一下缓存。继续报错，强退XCode，清空DerivedData，重新打开XCode
 ![报这个错.png](http://upload-images.jianshu.io/upload_images/1429890-0b89560ecafeb462.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
 
***
![逗视介绍2.gif](http://upload-images.jianshu.io/upload_images/1429890-91b427263bc09abd.gif?imageMogr2/auto-orient/strip)
---

- # 使用技术：
# 一款娱乐的App，主要有首页、音乐、发现、我的四大模块。采用Swift3.x语法编写项目。
 - 1.项目主要用MVVM设计模式开发，也涉及到MVC
 - 2.使用纯代码和Xib混合开发，使用SnapKit和AutoLayout做UI布局，在学会使用Xib和storyboard的同时也要掌握使用纯代码进行开发。看个人习惯，看运用场景决定开发方式。
 - 3.集成友盟分享,第三方QQ和微博登录，其实登录就是做个样子，因为没有后台，所以采用LeanCloud进行登录注册
 - 4.使用第三方Kingfisher和AFN进行图片异步加载 ，封装Alamofire请求工具类进行数据请求。
 - 5.SVProessHUD和MBProessHUD进行遮盖提示，进行自定义封装MBProessHUD，做成类扩展，方便使用
 - 6.父子控制器的使用，想很多App都会使用到这些东西，比如斗鱼、今日头条等运用。
 - 7.首次启动App使用ScrollView加到window进行引导。这样的一个好处在于在引导页看完之后，首页的数据已经加载好了
 - 8.UIWebView和WKWebView加载网页等技术，^_^- 
