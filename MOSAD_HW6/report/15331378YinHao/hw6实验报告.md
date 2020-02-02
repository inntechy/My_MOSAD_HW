# 中山大学数据科学与计算机学院本科生实验报告
| 课程名称 | 现代操作系统应用开发 |   任课老师   |      郑贵锋       |
| :------: | :------------------: | :----------: | :---------------: |
|   年级   |         15级         | 专业（方向） |       嵌软        |
|   学号   |       15331378       |     姓名     |       尹豪        |
|   电话   |     13307461421      |    Email     | 1103912716@qq.com |
| 开始日期 |      2019.11.12      |   完成日期   |    2019.11.14     |



## 一、实验题目

个人作业6 - 多线程和本地存储



## 二、实现内容

实现一个简单的图片浏览应用，页面如下：

|         初始状态          |         加载图片          |
| :-----------------------: | :-----------------------: |
| ![初始状态](./imgs/1.png) | ![加载图片](./imgs/2.png) |

manual中有演示视频，要求如下：

1. 只有一个页面，包含一个Label，一个图片列表（可以用UICollectionView或UITableView），以及三个按钮（"加载" "清空" "删除缓存"）。
2. 点击"加载"按钮，若Cache中没有缓存的文件，则加载网络图片并显示在图片列表中，要求：
   - 在子线程下载图片，返回主线程更新UI
   - 图片下载完成前，显示loading图标
   - 图片下载后，存入沙盒的Cache中
3. 点击"加载"按钮，若Cache中已存在图片文件，则直接从Cache中读取出图片并显示。
4. 点击"清空"按钮，清空图片列表中的所有图片。
5. 点击"删除缓存"按钮，删除存储在Cache中的图片文件。



## 三、实验结果

### (1)实验截图

![实验截图](./imgs/result.gif)

### (2)实验步骤以及关键代码

根据gitee的commit记录，实验步骤为

1. 搭建整个app的结构，完成顶栏底栏部分
2. 完成中间的图片tableView的UI
3. 完成图片的加载/清空
4. 完成基于NSOperation的多线程加载
5. 完成图片缓存管理
6. 完成基于GCD的多线程加载

#### 关键代码

#####NSOperation和GCD的选择

我定义了一个全局变量来控制代码使用NSOperation还是GCD

```objc
static BOOL useGCD = YES;
```

在这个变量的基础上，按钮的点击事件

```objc
- (void)loadBtnClicked{
    if(_dataSource.count == 0){
        for(int i = 0; i < 5; i++){
            //若缓存中存在这张图片
            if([self imageIndexExistsAtCache:i]){
                //则直接取出使用
                [self.dataSource addObject:[self getImageFromCache:i]];
            }else{
                //否则先使用loading图，并调用get方法往缓存中下载图片
                [self.dataSource addObject:[UIImage imageNamed:@"loading.png"]];
                if(useGCD){
                  	//GCD方式
                    [self getImageFromWeb_GCD:i];
                }else{
                  	//NSOperation方式
                    [self getImageFromWeb_NSO:i];
                }
            }
        }
        //刷新tableview
        [self.tableView reloadData];
    }
}
```

##### NSOperation方式的实现

下面的代码是下载序号为`index`的图片，更新UI并存入缓存的过程。

```objc
#pragma mark 基于NSOperation的多线程
- (void)getImageFromWeb_NSO:(int)index {
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
        NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadPicToCache:) object:[NSNumber numberWithInt:index]];
  			//将op加入执行队列中自动并发执行
        [operationQueue addOperation:op];
}

- (void) downloadPicToCache:(NSNumber *) index {
    NSArray *urls_str = @[此处省略……];
    NSURL *url = [NSURL URLWithString:urls_str[[index intValue]]];
    //通过对应的url下载index的图片
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    //放入datasource，更新UI
    _dataSource[[index intValue]] = image;
    //tableview只能在主线程更新
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    //更新完UI之后，才存入缓存
    NSLog(@"Download pic%@ to cache",index);
    [self saveImageToCache:image picIndex:[index intValue]];
}
```

##### GCD方式的实现

具体的操作与NSOperation大同小异，只是创建队列、执行任务的过程稍有区别

```objc
#pragma mark 基于GCD的多线程
- (void)getImageFromWeb_GCD:(int)index{
    // 创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("tag", DISPATCH_QUEUE_CONCURRENT);
    // 创建异步执行任务
    dispatch_async(queue,^{
        NSLog(@"GCD downloading pic%d ...",index);
        NSArray *urls_str = @[此处省略……];
        NSURL *url = [NSURL URLWithString:urls_str[index]];
        //通过对应的url下载index的图片
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        //放入datasource，更新UI
        self->_dataSource[index] = image;
        //[self.tableView reloadData];
        //tableview只能在主线程更新
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        //更新完UI之后，才存入缓存
        NSLog(@"Download pic%d to cache",index);
        [self saveImageToCache:image picIndex:index];
    });
}
```

##### 缓存管理

实现了四个方法对缓存进行管理，具体代码可见项目源码。

```objc
#pragma mark 缓存
//保存图片到缓存
- (void)saveImageToCache:(UIImage *)image picIndex:(NSInteger) index{
	//……
}

//判断编号为index的图片是否在缓存中
- (BOOL)imageIndexExistsAtCache:(NSInteger) index{
    //……
}

//清空缓存
- (void)clearImageCache{
    //……
}

//从缓存中取出指定图片
- (UIImage *)getImageFromCache:(NSInteger) index{
    //……
}
```



### (3)实验遇到的困难以及解决思路

#### 问题一：在子线程中更新tableview，但不生效

UI的更新只能在主线程下进行，因此不能简单在子线程中写`[tableView reloadData]`，而要使用回调函数：

```objc
//tableview只能在主线程更新
[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
```

#### 问题二：在TableViewCell类中，获取Cell的frame问题

如果在`init`方法里获取`Cell.frame.bounds.size`会得到一个错误的结果`(300,76)`，原因是在`init`方法执行时，`cell`还没有确定其`frame`的大小。需要重写`Cell`的`layoutSubviews`方法，在这里才能获取到正确的值。

```objc
- (void)layoutSubviews{
    [super layoutSubviews];
    _imgView.frame = self.contentView.bounds;
    [self.contentView addSubview:self.imgView];
}
```



## 四、实验思考及感想

这次实验的内容是前端、客户端常用到的网络相关的内容：异步请求，本地缓存。在加载图片的时候，可以先用一个placeholder占位，然后再对其进行更新，这样用户体验会更好，这也是实际生活中app常用的做法。

