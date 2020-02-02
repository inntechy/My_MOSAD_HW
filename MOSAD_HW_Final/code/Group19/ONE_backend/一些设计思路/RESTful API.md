### RESTful API

| 序号 | URL                | HTTP方法 | 发送内容 | 返回结果         |
| ---- | ------------------ | -------- | -------- | ---------------- |
| 1    | /api/today_list    | GET      | 空       | 最新的文章列表   |
| 2    | /api/list/:vol     | GET      | 空       | 第vol期文章列表  |
| 3    | /api/ article /:id | GET      | 空       | 特定id的文章内容 |

### 1. GET /api/today_list

获取今日的文章列表

不发送内容

返回格式如下，各数据意义详见数据库设计。

```json
{
    "vol": 2634,
    "year": 2019,
    "month": 12,
    "day": 23,
    "motto": "你说是 辣就是",
    "motto_auth": "天皇",
    "photo_url": "http://image.wufazhuce.com/FnW4HPyoiKOofjviWyBbdKsD3ITs",
    "photo_auth": "Alvin Balemesa",
    "articles_count": 3,
    "articles_list": [
        {
            "ID_vol": 263401,
            "content_type": "阅读",
            "title": "摔了一跤111",
            "auth": "王大乂",
            "photo_url": "http://image.wufazhuce.com/FnW4HPyoiKOofjviWyBbdKsD3ITs",
            "foreword": "111斗气别隔夜，把话说明白，依然是互相帮助的伙伴。"
        },
        {
            "ID_vol": 263402,
            "content_type": "生活家",
            "title": "摔了一跤222",
            "auth": "王大乂",
            "photo_url": "http://image.wufazhuce.com/FnW4HPyoiKOofjviWyBbdKsD3ITs",
            "foreword": "222斗气别隔夜，把话说明白，依然是互相帮助的伙伴。"
        },
        {
            "ID_vol": 263403,
            "content_type": "搞黄色",
            "title": "摔了一跤333",
            "auth": "王大乂3",
            "photo_url": "http://image.wufazhuce.com/FnW4HPyoiKOofjviWyBbdKsD3ITs",
            "foreword": "333斗气别隔夜，把话说明白，依然是互相帮助的伙伴。"
        }
    ]
}
```

### 2. GET /api/list/:vol

获取特定期的目录内容。

不发送内容

返回格式与1.获取当日目录相同，各数据意义详见数据库设计。



### 3.GET /api/ article /:id

获取特定id的文章内容，其中id前四位为vol，后两位为文章编号。

不发送内容

返回格式如下，各数据意义详见数据库设计。

```json
{
    "ID_vol": 263401,
    "content_type": "阅读",
    "title": "摔了一跤111",
    "auth": "王大乂",
    "photo_url": "http://image.wufazhuce.com/FnW4HPyoiKOofjviWyBbdKsD3ITs",
    "foreword": "111斗气别隔夜，把话说明白，依然是互相帮助的伙伴。",
    "content": "01 \n\n王丽丽那天再次走上地铁褡裢坡B口的扶手电梯时，忽然明白自己两周前为什么会在上面摔了一跤。\n\n她那一跤摔得不算尴尬，因为当她爬起来等到电梯运行至路面，颠簸着走到旁边弯起腰缓解疼痛时，才有人从她身旁路过。……"
}
```

