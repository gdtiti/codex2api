# ============================================================
# Stage 1: 构建前端 (React + Vite)
# ============================================================
FROM node:20-alpine AS frontend-builder

WORKDIR /frontend
COPY frontend/package.json frontend/package-lock.json ./
RUN npm ci --no-audit --no-fund
COPY frontend/ .
RUN npm run build

# ============================================================
# Stage 2: 构建 Go 后端 (嵌入前端静态文件)
# ============================================================
FROM golang:1.23-alpine AS go-builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

COPY . .
# 将前端构建产物复制到 frontend/dist，供 go:embed 使用
COPY --from=frontend-builder /frontend/dist ./frontend/dist

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /codex2api .

# ============================================================
# Stage 3: 最终运行镜像 (最小化体积)
# ============================================================
FROM alpine:3.19

RUN apk --no-cache add ca-certificates tzdata

COPY --from=go-builder /codex2api /usr/local/bin/codex2api

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/codex2api"]
