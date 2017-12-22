FROM debian:jessie
MAINTAINER Pablo Montepagano <pablo@montepagano.com.ar>


RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y --no-install-recommends \
  automake \
  autotools-dev \
  build-essential \
  checkinstall \
  cmake \
  curl \
  exactimage \
  git \
  gimp \
  gimp-plugin-registry \
  imagemagick \
  libboost-all-dev \
  libjpeg-dev \
  libjpeg62-turbo-dev \
  libldap2-dev \
  libleptonica-dev \
  libmagickwand-dev \
  libpng12-dev \
  libqt4-dev \
  libsasl2-dev \
  libssl-dev \
  libtiff5-dev \
  libtool \
  libxrender-dev \
  mysql-client \
  nodejs \
  poppler-utils \
  python-dev \
  tesseract-ocr \
  tesseract-ocr-eng \
  tesseract-ocr-spa \
  tesseract-ocr-spa-old \
  tesseract-ocr-equ \
  wget \
  yarn \
  zlib1g-dev && \
  rm -rf /var/lib/apt/lists /var/cache/apt/*

# Compilar Scantailor Enhanced:
RUN git clone https://github.com/scantailor/scantailor.git /usr/src/scantailor
WORKDIR /usr/src/scantailor
RUN git checkout enhanced && cmake . && make && checkinstall -y

# JBIG2ENC
RUN git clone https://github.com/agl/jbig2enc.git /usr/src/jbig2enc
WORKDIR /usr/src/jbig2enc
RUN ./autogen.sh && ./configure && make && make install

# PDFBeads http://proyecto.derechoaleer.org/codex/pdfbeads/  y https://rubygems.org/gems/pdfbeads
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://raw.githubusercontent.com/rvm/rvm/stable/binscripts/rvm-installer | bash -s stable --ruby=1.9.3
ENV rvm_bin_path=/usr/local/rvm/bin \
    GEM_HOME=/usr/local/rvm/gems/ruby-1.9.3-p551 \
    IRBRC=/usr/local/rvm/rubies/ruby-1.9.3-p551/.irbrc \
    MY_RUBY_HOME=/usr/local/rvm/rubies/ruby-1.9.3-p551 \
    rvm_path=/usr/local/rvm \
    rvm_prefix=/usr/local \
    PATH=/usr/local/rvm/gems/ruby-1.9.3-p551/bin:/usr/local/rvm/gems/ruby-1.9.3-p551@global/bin:/usr/local/rvm/rubies/ruby-1.9.3-p551/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/rvm/bin \
    GEM_PATH=/usr/local/rvm/gems/ruby-1.9.3-p551:/usr/local/rvm/gems/ruby-1.9.3-p551@global
RUN gem install nokogiri -v 1.6.8.1 && \
    gem install ttfunk -v 1.4.0 && \
    gem install pdfbeads

#TODO: usar versión de pdfbeads en https://github.com/ifad/pdfbeads que debería
#ser compatible con Ruby 2. Se puede instalar usando https://github.com/rdp/specific_install
# para instalar directamente desde Github

VOLUME /srv/tiff
VOLUME /srv/ocr

ADD fcen-postprocessing /fcen-postprocessing
RUN chmod 0755 /fcen-postprocessing
ENTRYPOINT ["/fcen-postprocessing/scripts/profile-processor"]
