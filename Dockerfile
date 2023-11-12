# 使用 Alpine 作为基础镜像
FROM alpine:latest as builder

# 设置工作目录
WORKDIR /app

# 从 GitHub Actions 传递过来的环境变量
ARG TARGETPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM}

# 使用 SHELL 指令切换到 Shell，使用 && 连接多个命令
SHELL ["/bin/bash", "-c"]

# 判断平台并选择性地复制文件
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
        echo "Copying for x86_64 platform" && \
        cp chfs-linux-amd64 chfs; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
        echo "Copying for arm64 platform" && \
        cp chfs-linux-arm64 chfs; \
    else \
        echo "Unsupported platform" && \
        exit 1; \
    fi


# 最终阶段，使用适当的基础镜像
FROM alpine:latest

LABEL maintainer="solyhe84"

# ENV RULE="::r|user:admin:r:filebox:rwd"

# 设置工作目录
WORKDIR /app

# 从构建阶段复制文件
COPY --from=builder /app .
COPY chfs.ini ./app

EXPOSE 80

CMD ["/bin/sh", "-c", "chfs --file=chfs.ini"]
# CMD ["/bin/sh", "-c", "/chfs --rule=$RULE --path=/home"]
