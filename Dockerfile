# 使用 Alpine 作为基础镜像
FROM alpine:latest as builder

# 设置工作目录
WORKDIR /app

# 默认平台为 x86_64
# ARG TARGETPLATFORM=linux/amd64

# 根据平台选择性地复制文件
COPY chfs-${TARGETPLATFORM} chfs

# 最终阶段，使用适当的基础镜像
FROM alpine:latest

LABEL maintainer="solyhe84"

# ENV RULE="::r|user:admin:r:filebox:rwd"

# 设置工作目录
WORKDIR /app

# 从构建阶段复制文件
COPY --from=builder /app .
COPY chfs.ini .

EXPOSE 80

CMD ["/bin/sh", "-c", "chfs --file=chfs.ini"]
# CMD ["/bin/sh", "-c", "/chfs --rule=$RULE --path=/home"]
