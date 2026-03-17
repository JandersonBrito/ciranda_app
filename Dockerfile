# ─────────────────────────────────────────────────────────────────────────────
# Ciranda App — Dockerfile
# Imagem para desenvolvimento e build Flutter (Android APK / web)
# ─────────────────────────────────────────────────────────────────────────────
FROM ubuntu:22.04

# Evita prompts interativos durante apt
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Fortaleza

# ── Versões ──────────────────────────────────────────────────────────────────
ENV FLUTTER_VERSION=3.41.4
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV FLUTTER_HOME=/opt/flutter
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# ── PATH global ──────────────────────────────────────────────────────────────
ENV PATH="${FLUTTER_HOME}/bin:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${JAVA_HOME}/bin:${PATH}"

# ── Dependências do sistema ───────────────────────────────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    wget \
    unzip \
    xz-utils \
    zip \
    lib32z1 \
    libgl1-mesa-dev \
    openjdk-17-jdk-headless \
    ca-certificates \
    gnupg \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    && rm -rf /var/lib/apt/lists/*

# ── Android SDK Command-line Tools ───────────────────────────────────────────
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    wget -q "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip" \
         -O /tmp/cmdline-tools.zip && \
    unzip -q /tmp/cmdline-tools.zip -d /tmp/cmdline-tools-extracted && \
    mv /tmp/cmdline-tools-extracted/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    rm -rf /tmp/cmdline-tools.zip /tmp/cmdline-tools-extracted

# ── Licenças Android ─────────────────────────────────────────────────────────
RUN yes | sdkmanager --licenses > /dev/null 2>&1 || true

# ── Componentes Android SDK ───────────────────────────────────────────────────
RUN sdkmanager --install \
    "platform-tools" \
    "platforms;android-34" \
    "build-tools;34.0.0" > /dev/null 2>&1

# ── Flutter SDK ───────────────────────────────────────────────────────────────
RUN wget -q "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
         -O /tmp/flutter.tar.xz && \
    tar -xJf /tmp/flutter.tar.xz -C /opt && \
    rm /tmp/flutter.tar.xz && \
    git config --global --add safe.directory /opt/flutter && \
    flutter --version

# ── Configuração do Flutter ───────────────────────────────────────────────────
RUN flutter config --no-analytics \
    && flutter config --android-sdk ${ANDROID_SDK_ROOT} \
    && flutter precache --android --web \
    && flutter doctor --android-licenses || true \
    && flutter doctor -v

# ── Diretório de trabalho ─────────────────────────────────────────────────────
WORKDIR /app

# ── Copia pubspec para cache de dependências ──────────────────────────────────
COPY pubspec.yaml pubspec.lock* ./

# ── Instala dependências (camada cacheável) ───────────────────────────────────
RUN flutter pub get

# ── Copia o restante do projeto ───────────────────────────────────────────────
COPY . .

# ── Porta para flutter run --web (opcional) ───────────────────────────────────
EXPOSE 8080

# ── Comando padrão: mostra ajuda disponível ───────────────────────────────────
CMD ["flutter", "--version"]