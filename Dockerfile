# 使用 Docker Buildx 的基础镜像
FROM --platform=$TARGETPLATFORM alpine:latest AS builder

# 设置工作目录
WORKDIR /app

# 如果是 x86_64 平台，复制 x86_64 运行程序
# 如果是 arm64 平台，复制 arm64 运行程序
COPY exec_${TARGETPLATFORM} myapp

# 最终阶段，使用适当的基础镜像
FROM alpine:latest

LABEL maintainer="solyhe84"

ENV RULE="::r|user:admin:r:filebox:rwd"

COPY chfs /

EXPOSE 80

CMD ["/bin/sh", "-c", "/chfs --rule=$RULE --path=/home"]
