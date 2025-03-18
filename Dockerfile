FROM ubuntu:20.04

# 设置工作目录
WORKDIR /app

# 一次性安装所有依赖并清理缓存
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
    bzip2 && \
    # 下载 Miniconda
    wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py39_25.1.1-2-Linux-x86_64.sh -O miniconda.sh && \
    # 安装 Miniconda
    bash miniconda.sh -b -p /opt/miniconda3 && \
    # 清理安装文件和无用软件包
    rm miniconda.sh && \
    apt-get purge -y wget && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# 设置 Conda 环境变量
ENV PATH="/opt/miniconda3/bin:$PATH"

# 安装 Python 依赖并清理缓存
RUN conda install -y numpy=1.26.4 && \
    # 安装 PyTorch CPU 版本
    pip install --no-cache-dir torch==1.10.0+cpu torchvision==0.11.0+cpu torchaudio==0.10.0 -f https://download.pytorch.org/whl/torch_stable.html && \
    # 清理 Conda 和 Pip 缓存
    conda clean -ya && \
    rm -rf /root/.cache/pip

# 初始化 Conda 并设置默认启动命令
RUN conda init bash
CMD ["/bin/bash"]
