# SSM练习项目 员工管理系统

基于Spring、SpringMVC、Mybatis框架，实现了对员工数据的增删改查操作的管理系统

## 运用到一些技术

[Mybatis-generator (Mybatis逆向工程)]( http://mybatis.org/generator/ )，根据设计好的数据库表来生成相应的实体类及mapper文件

[Mybatis-PageHelper(分页插件)]( https://pagehelper.github.io/ )，用于完成员工数据在网页上的分页显示

JSR303数据校验，主要完成对邮箱的格式验证

Bootstrap框架，前端网页展示

## 仍存在的一点小问题

在对某一页的某一个员工进行数据修改后，该条员工数据在当前页码就会消失，跑到其他页码的页面显示，也就是数据显示混乱。

## 解决办法

由于此前电脑蓝屏导致系统重装过一次，MySQL数据库也跟着重装，数据全部丢失，所以目前未能解决。。。
