# maven配置文件


<!-- vim-markdown-toc GFM -->
* [download 依赖](#download-依赖)
* [deploy到nexus私服](#deploy到nexus私服)

<!-- vim-markdown-toc -->

## download 依赖

将 `src/main/maven/settings.xml` 拷贝到 `${user.home}/.m2` 目录下即可。

## deploy到nexus私服

需要将 `src/main/maven/security/settings-security.xml` 拷贝到 `${user.home}/.m2` 目录。

在需要上传到公司内部 `nexus` 的项目的 `pom.xml` 中添加如下配置即可。

```xml
<distributionManagement>
    <snapshotRepository>
        <id>etd-nexus-snapshots</id>
        <name>common utils Snapshot</name>
        <url>${etd-nexus.repository}/maven-snapshots/</url>
    </snapshotRepository>
    <repository>
        <id>etd-nexus-releases</id>
        <name>common utils Release</name>
        <url>${etd-nexus.repository}/maven-releases/</url>
    </repository>
</distributionManagement>
```

