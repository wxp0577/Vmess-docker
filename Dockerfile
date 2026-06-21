FROM alpine:latest

# 安装基础依赖
RUN apk add --no-cache tzdata ca-certificates wget unzip util-linux

# 修复核心：先下载为独立文件，再解压，最后删除安装包
RUN wget -qO xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
    && unzip -d /usr/local/bin/ xray.zip \
    && rm xray.zip \
    && chmod +x /usr/local/bin/xray

# 复制脚本并执行
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
