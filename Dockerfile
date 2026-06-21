FROM alpine:latest

# 安装基础依赖组件 (包含 uuidgen 用于自动生成 ID)
RUN apk add --no-cache tzdata ca-certificates wget unzip util-linux

# 修改这里：先下载为 xray.zip，再解压，最后删除压缩包
RUN wget -qO xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
    && unzip -d /usr/local/bin/ xray.zip \
    && rm xray.zip \
    && chmod +x /usr/local/bin/xray

# 复制启动脚本并赋予执行权限
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 启动容器时执行脚本
ENTRYPOINT ["/entrypoint.sh"]
