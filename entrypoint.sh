#!/bin/sh

# 1. 设置变量
UUID="0247fc5e-aed9-4f2c-8d95-6eb4932a5d92"
IP=$(wget -qO- ipv4.icanhazip.com)
PORT=8080
SNI="www.microsoft.com"
PBK="3uH3B0T4oV5e8O_1Z2j6v6v4E5z9Ww0y7n7S3m5N4k4="
SID="0123456789abcdef"

# 2. 拼接 VLESS Reality 订阅链接
# 格式：vless://UUID@IP:PORT?type=tcp&security=reality&fp=chrome&pbk=PBK&sni=SNI&sid=SID&flow=xtls-rprx-vision#NodeName
URL="vless://$UUID@$IP:$PORT?type=tcp&security=reality&fp=chrome&pbk=${PBK}&sni=$SNI&sid=$SID&flow=xtls-rprx-vision#Reality-Node"

# 3. 输出供复制
echo "================================================="
echo "✅ 节点启动成功！"
echo "🌍 自动检测 IP: $IP"
echo "🔗 完整订阅链接 (复制下方整行):"
echo ""
echo "$URL"
echo ""
echo "================================================="

# 4. 启动 sing-box
exec sing-box run -c /etc/sing-box/config.json
