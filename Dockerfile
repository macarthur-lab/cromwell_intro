# this base image works with Cromwell
FROM bitnami/minideb:stretch

RUN install_packages ca-certificates wget curl less \
    pkg-config gcc man-db g++ make autoconf dpkg-dev build-essential \
    unzip bzip2 libcurl4-openssl-dev libbz2-dev liblzma-dev zlib1g-dev

ENV SUBREAD_VERSION="1.6.5"
RUN wget https://sourceforge.net/projects/subread/files/subread-${SUBREAD_VERSION}/subread-${SUBREAD_VERSION}-Linux-x86_64.tar.gz/download -O subread-${SUBREAD_VERSION}-Linux-x86_64.tar.gz \
  && tar xzf subread-${SUBREAD_VERSION}-Linux-x86_64.tar.gz \
  && rm subread-${SUBREAD_VERSION}-Linux-x86_64.tar.gz \
  && ln -s subread-${SUBREAD_VERSION}-Linux-x86_64/bin/featureCounts /featureCounts

ENV SAMTOOLS_VERSION="1.9"
RUN wget https://github.com/samtools/htslib/releases/download/${SAMTOOLS_VERSION}/htslib-${SAMTOOLS_VERSION}.tar.bz2 \
  && tar xjf htslib-${SAMTOOLS_VERSION}.tar.bz2 \
  && rm htslib-${SAMTOOLS_VERSION}.tar.bz2

RUN cd htslib-${SAMTOOLS_VERSION} \
  && ./configure \
  && make \
  && make install \
  && make clean

RUN wget https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2 \
  && tar xjf samtools-${SAMTOOLS_VERSION}.tar.bz2 \
  && rm samtools-${SAMTOOLS_VERSION}.tar.bz2

RUN install_packages libncursesw5-dev
RUN cd samtools-${SAMTOOLS_VERSION} \
  && ./configure \
  && make \
  && make install \
  && make clean
