**表名: papers**

| 键名 | 示例 | 数据类型 | 注释                |
| ---- | ---- | -------- | --------------- |
| ID_vol | 2634                                                    | int | 主键：表示第几期 |
| motto | 你能在浪费中获得乐趣，就不是浪费时间。 | string | 每日格言 |
| motto_auth | 罗素 | string | 每日格言的作者 |
| release_year | 2019 | string(4) | 发布日期-年 |
| release_month | 12 | string(2) | 发布日期-月 |
| release_day | 22 | string(2) | 发布日期-日 |
| release_data  | 20191222                                                | string(8) | 发布日期 |
| photo_url | http://image.wufazhuce.com/FnW4HPyoiKOofjviWyBbdKsD3ITs | string | 每日摄影作品的url |
| photo_auth | Alvin Balemesa | string | 每日摄影的作者 |
| articles_count | 3 | int | 共有几篇文章 |

**(阅读)表名：articles**

| 键名      | 示例                                                    | 数据类型 | 注释                     |
| --------- | ------------------------------------------------------- | -------- | ------------------------ |
| ID_vol    | 263401                                                  | int      | 主键：表示是第几期的第几篇文章 |
|content_type|阅读|string|文章的类型，包括阅读、生活家、问答等|
| title     | 摔了一跤                                                | string   | 文章的标题               |
| auth      | 王大乂                                                  | string   | 文章的作者               |
| photo_url | http://image.wufazhuce.com/FnW4HPyoiKOofjviWyBbdKsD3ITs | string   | 头图                     |
| foreword  | 斗气别隔夜，把话说明白，依然是互相帮助的伙伴。          | string   | 前言                     |
| content   | 王丽丽那天再次……                                        | text     | 文章内容                 |

