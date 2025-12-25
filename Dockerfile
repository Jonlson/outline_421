# -----------------------
# 单阶段构建（兼容 CodeArts 内网）
# -----------------------
FROM swr.cn-north-4.myhuaweicloud.com/library/node:22.21.0-slim

WORKDIR /app

# 设置华为云 npm 镜像
RUN npm config set registry https://repo.huaweicloud.com/repository/npm/

# 拷贝 package.json 并安装依赖
COPY package.json package-lock.json* ./
RUN npm install

# 拷贝应用源码
COPY . .

# 设置环境变量和数据目录
ENV NODE_ENV=production
ENV FILE_STORAGE_LOCAL_ROOT_DIR=/var/lib/outline/data
RUN mkdir -p "$FILE_STORAGE_LOCAL_ROOT_DIR" && \
    chmod 1777 "$FILE_STORAGE_LOCAL_ROOT_DIR"

VOLUME /var/lib/outline/data

# 暴露端口
EXPOSE 3000

# 切换非 root 用户
RUN addgroup --gid 1001 nodejs && adduser --uid 1001 --ingroup nodejs nodejs
USER nodejs

# 启动命令
CMD ["yarn", "start"]
