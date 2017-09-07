# etongdai Java代码规范

为了避免合作者使用不同代码格式造成混乱, 使代码在版本控制上的diff保持干净, 我们要求所有合作者使用同样的代码格式.

因为代码量比较大, 很难使用人力维护格式, 我们使用工具来进行代码格式化和格式检查.

我们使用的工具在IntelliJ和Eclipse上都有相应的插件, 能满足绝大多数开发者的需求.

本文主要解决开发者如何设置本地开发环境的问题。使用的checkstyle, pmd等配置文件在 src/main里面。开发者只需在自己的工作站上设置好IDE插件, 并导入给出的配置文件即可。

<!-- vim-markdown-toc GFM -->
* [git设置](#git设置)
    * [全局禁止git自动替换换行符](#全局禁止git自动替换换行符)
    * [检查git设置](#检查git设置)
    * [项目级别的git设置](#项目级别的git设置)
* [代码风格标准](#代码风格标准)
    * [后端代码风格](#后端代码风格)
    * [Web 代码风格](#web-代码风格)
* [Eclipse 代码风格设置](#eclipse-代码风格设置)
    * [Eclipse import 调整 (与IntelliJ兼容)](#eclipse-import-调整-与intellij兼容)
* [IntelliJ 代码风格设置](#intellij-代码风格设置)
    * [IntelliJ import 调整](#intellij-import-调整)
* [Eclipse 代码风格工具简单使用](#eclipse-代码风格工具简单使用)
    * [google style代码风格](#google-style代码风格)
    * [editorconfig 插件](#editorconfig-插件)
    * [checkstyle 插件](#checkstyle-插件)
    * [eclipse-pmd 插件](#eclipse-pmd-插件)
    * [findbugs 插件](#findbugs-插件)
    * [JDepend4Eclipse 插件](#jdepend4eclipse-插件)
    * [EclEmma 插件](#eclemma-插件)
* [其他文档](#其他文档)

<!-- vim-markdown-toc -->

## git设置

### 全局禁止git自动替换换行符

```
git config --global core.autocrlf false
```

### 检查git设置

```
git config --list
```

### 项目级别的git设置

执行命令

```
git config --local core.autocrlf false
git config --local core.filemode true
git config --local core.ignorecase false
git config --local core.quotepath false
git config --local core.safecrlf true
git config --local user.name "someone"
git config --local user.email "someone@home1.cn"
```

或编辑.git/config

```
[core]
    ignorecase = false
    quotepath = false
    filemode = true
    autocrlf = false
    safecrlf = true

[user]
    name = someone
    email = someone@home1.cn
```

## 代码风格标准

### 后端代码风格

[Java代码风格](https://google.github.io/styleguide/javaguide.html)
[Python代码风格](https://google.github.io/styleguide/pyguide.html)
[Shell代码风格](https://google.github.io/styleguide/shell.xml)

### Web 代码风格

[Javascript代码风格](https://google.github.io/styleguide/javascriptguide.xml)
[AngularJS代码风格](https://google.github.io/styleguide/angularjs-google-style.html)
[HTML/CSS代码风格](://google.github.io/styleguide/htmlcssguide.xml)

## Eclipse 代码风格设置

导入 `src/main/eclipse/google-style-java-eclipse*.xml` 配置文件
Preferences -> Java -> Code Style -> Formatter -> Import
此文件来自 [google style](https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml) 并进行过简单修改

+ 安装 [editorconfig](https://github.com/ncjones/editorconfig-eclipse#readme) 插件
+ 安装 [checkstyle](https://sourceforge.net/projects/eclipse-cs/) 插件并导入src/main/checkstyle下对应版本的配置文件
+ 安装 [eclipse-pmd](http://acanda.github.io/eclipse-pmd/) (注意不是pmd-eclipse)插件
+ 安装 [findbugs](https://github.com/findbugsproject/findbugs/releases) 插件
+ 安装 JDepend4Eclipse
+ 安装 [EclEmma](http://www.eclemma.org/)，该插件可用于jacoco测试覆盖度

> [使用 EclEmma 进行覆盖测试](http://www.ibm.com/developerworks/cn/java/j-lo-eclemma/index.html)

### Eclipse import 调整 (与IntelliJ兼容)

导入src/main/eclipse/google-style-java-eclipse*.importorder配置文件
Preferences -> Java -> Code Style -> Organize Imports -> Import

set "class count to use import with '*'" to 99 (seems like you cannot turn this off)

## IntelliJ 代码风格设置

导入 `src/main/intellij/google-style-java-intellij*.xml` 配置文件
Preferences -> Plugins -> Editor -> Code Style -> Manage -> Import -> Intellij IDEA code style XML
此文件来自google style并进行过简单修改。

**CheckStyle-IDEA插件**

![](src/readme/static/images/intellij_checkstyle_install.png)

![](src/readme/static/images/intellij_checkstyle_settings.png)

![](src/readme/static/images/intellij_checkstyle_view.png)

**FindBugs-IDEA插件** 

![](src/readme/static/images/intellij_findbugs_install.png)

![](src/readme/static/images/intellij_findbugs_view.png)

**PMDPlugin插件** 

![](src/readme/static/images/intellij_pmd_install.png)

![](src/readme/static/images/intellij_pmd_ruleset_settings.png)

![](src/readme/static/images/intellij_pmd_options_settings.png)

![](src/readme/static/images/intellij_pmd_run.png)

该插件评价不高。

**EditorConfig 插件已安装且启用**

### IntelliJ import 调整

Preferences -> Editor -> Code Style --> Java --> Imports (tab) -> Import Layout

## Eclipse 代码风格工具简单使用

安装代码风格插件以后, 有些需要手工启用, 简单介绍如下:

### google style代码风格

google style导入以后, 一般能够直接使用, 可以格式化一个文件试试, 代码缩进为2个空格. 要将整个项目进行格式化, 则需要在 package explorer 视图下, 选中项目(可同时选中多个), 点击"Source"菜单, 选择"format".

如果第一次导入不能使用, 那么先手动切换回原来style, 再切换回来就可以了.

### editorconfig 插件

EditorConfig 用来定义代码格式，以实现不同编辑器、不同项目成员之间统一代码风格. 详情: [editorconfig](https://github.com/ncjones/editorconfig-eclipse#readme)。

### checkstyle 插件

代码检查工具. 开启方式: 右键项目(可以选中多个) -> checkstyle -> active checkstyle. 在problems标签下就能看到相应警告. 

![](src/readme/static/images/eclipse-checkstyle-plugin.png)

### eclipse-pmd 插件

源码分析器, 检查Java源文件中的潜在问题. 这个需要手工对每一个项目启用. 右键项目 -> properties -> pmd -> 启用. 然后在select rule set里面, 点击add -> file system, 找到oss-build/src/main/pmd/pmd-ruleset.xml并启用. 启用以后, 就能在problems标签看到警告.

如果没反应, 先取消启用, 再重新启用一下就好. 

![](src/readme/static/images/eclipse-pmd-plugin.png)

### findbugs 插件

右键项目(可选中多个) -> findbugs -> findbugs, 结果在 problems标签下查看.

### JDepend4Eclipse 插件

生成Java包的质量评价报告. 选择src文件夹，然后点击右键，然后点击run JDepend analysis.

### EclEmma 插件

代码覆盖度插件.

## 其他文档
1. [业务开发技术栈](stack.md)
