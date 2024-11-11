# 将 JAVA_HOME 和 GRAALVM_HOME 添加到 .bashrc
echo "export JAVA_HOME=/mnt/c/Users/eric.kuo/.jdks/graalvm-jdk-23+37.1-linux" >> ~/.bashrc
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> ~/.bashrc  # {{ edit_2 }}
echo "export GRAALVM_HOME=/mnt/c/Users/eric.kuo/.jdks/graalvm-jdk-23+37.1-linux" >> ~/.bashrc
echo "export PATH=\$GRAALVM_HOME/bin:\$PATH" >> ~/.bashrc
echo "请运行 'source ~/.bashrc' 以使更改生效。"

# 检查 /etc/resolv.conf 是否存在
if [ ! -f /etc/resolv.conf ]; then
    echo "Creating /etc/resolv.conf"
    sudo touch /etc/resolv.conf
fi

# 检查 /etc/resolv.conf 是否包含 nameserver
if ! grep -q "^nameserver" /etc/resolv.conf; then
    echo "Adding nameservers to /etc/resolv.conf"
    echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf > /dev/null
    echo "nameserver 8.8.4.4" | sudo tee -a /etc/resolv.conf > /dev/null
else
    echo "Nameservers already exist in /etc/resolv.conf"
fi

# 更新 WSL 内所有 package
echo "Updating all packages in WSL..."
sudo apt update && sudo apt upgrade -y

# 清理不需要的包
echo "Cleaning up unnecessary packages..."
sudo apt autoremove -y
sudo apt clean
echo "Package update and cleanup completed."

# 启动 dockerd
sudo dockerd > /dev/null 2>&1 &
DOCKER_PID=$!
sleep 5

# 递归查找并启动所有 docker-compose.yml
find . -name docker-compose.yml -exec sh -c '
    echo "Starting Docker Compose in $(dirname {})"
    cd $(dirname {})
    docker-compose up -d
' \;