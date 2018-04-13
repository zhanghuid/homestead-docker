1. 安装docker环境，[for win]((https://blog.jayway.com/2017/04/19/running-docker-on-bash-on-windows/))

2. clone homestead for docker的package: <br>
`git clone https://github.com/shincoder/homestead-docker.git`

3. pull homestead image：<br>
`docker pull shincoder/homestead:php7.1`

4. copy && edit docker-compose.yml <br>
```bash
$ cp docker-compose.dist.yml docker-compose.yml
$ vim docker-compose and like follow
```
```yml
web:
    image: shincoder/homestead:php7.0
    restart: unless-stopped
    ports:
        - "80:80" # web
        - "22:22" # ssh
    volumes:
        - f:/works/.composer:/home/homestead/.composer # composer caching
        - f:/works/.gitconfig:/home/homestead/.gitconfig # Git configuration ( access alias && config )
        - f:/works/.ssh:/home/homestead/.ssh # Ssh keys for easy deployment inside the container
        - f:/works/web:/apps # all apps
        - f:/works/nginx/sites-available:/etc/nginx/sites-available # nginx sites ( in case you recreate the container )
        - f:/works/nginx/sites-enabled:/etc/nginx/sites-enabled # nginx sites ( in case you recreate the container )
        - f:/works/nginx/ssl:/etc/nginx/ssl
    links:
        - mysql

mysql:
    image: mysql:5.7
    restart: unless-stopped
    ports:
        - "3306:3306"
    environment:
        MYSQL_ROOT_PASSWORD: 'root'
    volumes:
        - f:/docker/mysql:/var/lib/mysql
```
---
***说明:***
<br>
- 该docker-compose.yml有`web`跟`mysql`两个容器

- `image` 字段: 标识使用的镜像的名称，可以切换，homestead-docker包的作者提供了php5.6/7.0/7.1版本

- `ports` 字段: 是端口的映射。第一个 `80` 是本机的 `80` 端口；第二个 `80` 是指容器内部的 `80` 端口

- `volumes` 字段：是指数据卷的映射。
    - `f:/works/.composer:/home/homestead/.composer`：表示以`冒号(:)`分割，拆分为 `f:/works/.composer`（表示本机的目录） 跟 `/home/homestead/.composer`（表示容器内部的目录地址）。

---

5. 连接web容器
```bash
# 密码是secret
ssh homestead@localhost
```

6. 连接数据库
```bash
# 密码为docker-compose.yml上的 【MYSQL_ROOT_PASSWORD: 'root'】即：root
mysql -uroot -p
```
***有可能是密码为空，即直接: `mysql -uroot -p` 直接回车***

6. for laravel
```bash
# 这里的 host 为 mysql是因为容器的/etc/hosts文件已经配置了映射【172.17.1.3  mysql】,我这里的mysql ip是172.17.1.3
DB_HOST=mysql
DB_PORT=3306
DB_USERNAME=root
DB_PASSWORD=
```
> [原文](https://github.com/shincoder/homestead-docker.git)