#!/bin/sh

PORT=${PORT:-8080}
WS_PATH=${WS_PATH:-/vmess}

# 自动生成 UUID
if [ -z "$UUID" ]; then
    UUID=$(uuidgen)
fi

# 1. 生成 Xray 运行配置
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

# 2. 自动拼装 Vmess 专属 JSON 格式
VMESS_JSON="{\"v\":\"2\",\"ps\":\"Koyeb-Vmess\",\"add\":\"你的Koyeb域名\",\"port\":\"443\",\"id\":\"$UUID\",\"aid\":\"0\",\"scy\":\"auto\",\"net\":\"ws\",\"type\":\"none\",\"host\":\"你的Koyeb域名\",\"path\":\"$WS_PATH\",\"tls\":\"tls\",\"sni\":\"你的Koyeb域名\",\"alpn\":\"\"}"

# 3. 将 JSON 转换为 Base64 编码的 vmess:// 链接
VMESS_LINK="vmess://$(echo -n "$VMESS_JSON" | base64 | tr -d '\n')"

echo "================================================="
echo "✅ 部署成功！Xray 核心已启动。"
echo "-------------------------------------------------"
echo "🔗 你的专属 Vmess 节点链接 (复制下方代码直接导入):"
echo ""
echo "$VMESS_LINK"
echo ""
echo "⚠️ 【最关键的一步】"
echo "导入到 V2rayN/Shadowrocket 后，请右键编辑该节点！"
echo "将里面的【地址】、【伪装域名/SNI】和【Host】修改为你真实的 Koyeb 网址（例如 xxx.koyeb.app）。"
echo "================================================="

# 启动程序
exec xray run -c /config.json
