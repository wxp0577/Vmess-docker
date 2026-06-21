#!/bin/sh

PORT=${PORT:-8080}
WS_PATH=${WS_PATH:-/vmess}

# 1. 自动获取容器的公网 IP (通过第三方接口获取)
PUBLIC_IP=$(wget -qO- ipv4.icanhazip.com || echo "无法获取IP")

# 2. 自动生成 UUID
if [ -z "$UUID" ]; then
    UUID=$(uuidgen)
fi

# 3. 生成 Xray 核心配置
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

# 4. 拼装 Vmess 专属 JSON 数据 (纯IP模式，去除TLS，端口跟随变量)
VMESS_JSON="{\"v\":\"2\",\"ps\":\"Docker-IP-Node\",\"add\":\"$PUBLIC_IP\",\"port\":\"$PORT\",\"id\":\"$UUID\",\"aid\":\"0\",\"scy\":\"auto\",\"net\":\"ws\",\"type\":\"none\",\"host\":\"\",\"path\":\"$WS_PATH\",\"tls\":\"\",\"sni\":\"\",\"alpn\":\"\"}"

# 5. 将 JSON 转换为 Base64 编码的 vmess:// 链接 (去除回车换行)
VMESS_LINK="vmess://$(echo -n "$VMESS_JSON" | base64 | tr -d '\n' | tr -d '\r')"

# 6. 在日志最后输出完美链接！
echo "================================================="
echo "✅ Xray 核心已启动！"
echo "-------------------------------------------------"
echo "🌍 自动检测到的公网 IP: $PUBLIC_IP"
echo "🔗 你的专属 Vmess 一键导入链接 (完整复制下方代码):"
echo ""
echo "$VMESS_LINK"
echo ""
echo "⚠️ 新手注意:"
echo "如果平台分配给你的外部访问端口不是 $PORT (比如映射成了一个随机端口)，"
echo "请在客户端导入节点后，手动把节点的【端口】改成平台给你的实际端口！"
echo "================================================="

# 启动程序
exec xray -config /config.json
