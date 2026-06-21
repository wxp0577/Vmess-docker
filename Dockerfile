FROM ghcr.io/sagernet/sing-box:latest

# 创建目录并把配置拷进去
RUN mkdir -p /etc/sing-box
COPY config.json /etc/sing-box/config.json

# 调试命令：启动时先打印一遍配置内容，看看它到底能不能找到
ENTRYPOINT ["sh", "-c", "cat /etc/sing-box/config.json && sing-box run -c /etc/sing-box/config.json"]
