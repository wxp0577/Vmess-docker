FROM alpine:latest

# 安装基础依赖组件 (包含 uuidgen 用于自动生成 ID)
RUN apk add --no-cache tzdata ca-certificates wget unzip util-linux

# 下载并提取最新版 Xray-core
RUN wget -qO- https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip | unzip -d /usr/local/bin/ - \
    && chmod +x /usr/local/bin/xray

# 复制启动脚本并赋予执行权限
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 启动容器时执行脚本
ENTRYPOINT ["/entrypoint.sh"]
