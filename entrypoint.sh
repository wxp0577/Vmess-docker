#!/bin/sh

# 监听端口，云平台通常内部使用 8080
PORT=${PORT:-8080}

# 自动生成 UUID (如果环境变量中未设置)
if [ -z "$UUID" ]; then
    UUID=$(uuidgen)
    echo "⚠️ 未提供 UUID，系统已自动生成: $UUID"
fi

# WebSocket 路径，默认为 /vmess
WS_PATH=${WS_PATH:-/vmess}

echo "================================================="
echo "✅ Vmess (WebSocket) 节点初始化成功!"
echo "-------------------------------------------------"
echo "📝 请在客户端中填写以下信息："
echo "👉 协议类型: Vmess"
echo "👉 伪装域名 (SNI): 你的云平台分配的公网域名"
echo "👉 端口 (Port): 443"
echo "👉 用户 ID (UUID): $UUID"
echo "👉 额外 ID (AlterId): 0"
echo "👉 传输协议 (Network): ws"
echo "👉 伪装路径 (Path): $WS_PATH"
echo "👉 底层安全 (TLS): tls / 开启"
echo "================================================="

# 动态生成 Xray 配置文件 (Vmess协议)
cat <<EOF > /config.json
{
  "inbounds": [
    {
      "port": $PORT,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "$UUID",
            "alterId": 0
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "$WS_PATH"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF

# 启动 Xray 核心程序
exec xray run -c /config.json
