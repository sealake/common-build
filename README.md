# common-build

作为所有项目的父项目，提供父pom配置，通过为子项目设置maven插件来管理软件工程。 目前common-build父pom定义了使用的maven的最低版本,java版本(java8),字符编码(UTF-8),常见的插件等内容。

想要使用common-build提供的maven插件以及配置，只要将其设置为父项目即可。如下所示：

```$xslt
    <parent>
        <groupId>com.etongdai</groupId>
        <artifactId>common-build</artifactId>
        <version>1.0.0-SNAPSHOT</version>
    </parent>
```

## 其他
### 编码规范

关于编码规范以及IDE插件设置，请点击[这里](src/readme/code-style.md)

### Java后端技术栈

在后端项目中使用的框架以及文档，请点击[这里](src/readme/backend-stack.md)

### maven设置
maven配置文件，请点击[这里](src/readme/maven-settings.md)

