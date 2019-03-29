FROM alpine:3.9.2

RUN apk add --no-cache python3 \
    python3-dev \
    gcc \
    g++ \
    build-base \
    cmake \
    bash \
    git \
    m4 \
    perl \
    tzdata \
    libstdc++ && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools conan==1.12.0 && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

ENV CONAN_USER_HOME=/conan

RUN mkdir $CONAN_USER_HOME && \
    conan

COPY files/registry.json $CONAN_USER_HOME/.conan/
COPY files/default_profile $CONAN_USER_HOME/.conan/profiles/default

RUN git clone https://github.com/ess-dmsc/build-utils.git && \
    cd build-utils && \
    git checkout c05ed046dd273a2b9090d41048d62b7d1ea6cdf3 && \
    make install

RUN adduser --disabled-password --gecos "" jenkins

RUN chown -R jenkins $CONAN_USER_HOME/.conan

USER jenkins

WORKDIR /home/jenkins
