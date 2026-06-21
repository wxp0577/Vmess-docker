FROM ghcr.io/sagernet/sing-box:latest
# 暴露你的容器端口
EXPOSE 8080
# 启动时运行 sing-box
ENTRYPOINT ["sing-box", "run", "-c", "/etc/sing-box/config.json"]
