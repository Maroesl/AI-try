#!/bin/bash
# 健康检查脚本 - 检查nginx和后端服务是否正常

# 环境变量默认值
YPROMPT_HOST=${YPROMPT_HOST:-127.0.0.1}
YPROMPT_PORT=${YPROMPT_PORT:-8888}
HEALTH_CHECK_TIMEOUT=${HEALTH_CHECK_TIMEOUT:-10}

# 检查nginx是否运行
if ! pgrep nginx >/dev/null 2>&1; then
    echo "Nginx进程不存在"
    exit 1
fi

# 检查nginx是否响应（通过80端口）
if ! curl -sf --max-time ${HEALTH_CHECK_TIMEOUT} http://localhost/api/auth/config >/dev/null 2>&1; then
    echo "Nginx无法访问API端点"
    exit 1
fi

# 检查后端服务是否响应
if ! curl -sf --max-time ${HEALTH_CHECK_TIMEOUT} http://${YPROMPT_HOST}:${YPROMPT_PORT}/api/auth/config >/dev/null 2>&1; then
    echo "后端服务健康检查失败"
    exit 1
fi

# 所有检查通过
exit 0
