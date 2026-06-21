#!/bin/sh

PORT=${PORT:-8080}
WS_PATH=${WS_PATH:-/vmess}

# 引入一个叫 DOMAIN 的环境变量，方便直接生成完美链接
DOMAIN=${DOMAIN:-"请替换为你的Koyeb域名"}

# 自动生成 UUID
if [ -z "$UUID" ]; then
    UUID=$(uuidgen)
fi

# 1. 生成 Xray 核心配置
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

# 2. 拼装 Vmess 专属 JSON 数据
VMESS_JSON="{\"v\":\"2\",\"ps\":\"Koyeb-Vmess\",\"add\":\"$DOMAIN\",\"port\":\"443\",\"id\":\"$UUID\",\"aid\":\"0\",\"scy\":\"auto\",\"net\":\"ws\",\"type\":\"none\",\"host\":\"$DOMAIN\",\"path\":\"$WS_PATH\",\"tls\":\"tls\",\"sni\":\"$DOMAIN\",\"alpn\":\"\"}"

# 3. 将 JSON 转换为 Base64 编码的 vmess:// 链接 (去除回车换行)
VMESS_LINK="vmess://$(echo -n "$VMESS_JSON" | base64 | tr -d '\n' | tr -d '\r')"

# 4. 在日志最后输出完美链接！
echo "================================================="
echo "✅ Xray 核心已启动！"
echo "-------------------------------------------------"
echo "🔗 你的专属 Vmess 一键导入链接 (完整复制下方代码):"
echo ""
echo "$VMESS_LINK"
echo ""
echo "================================================="

# 启动程序
exec xray run -c /config.json
