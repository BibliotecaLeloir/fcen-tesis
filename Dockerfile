FROM debian:jessie
MAINTAINER Pablo Montepagano <pablo@montepagano.com.ar>
ENV http_proxy http://proxy.fcen.uba.ar:8080/

# Update the package repository
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y wget curl locales

# Configure timezone and locale
RUN echo "America/Argentina/Buenos_Aires" > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata
RUN export LANGUAGE=en_US.UTF-8 && \
	export LANG=en_US.UTF-8 && \
	export LC_ALL=en_US.UTF-8 && \
	locale-gen en_US.UTF-8 && \
	DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales


## Instalar Tesseract
RUN apt-get install -y tesseract-ocr tesseract-ocr-eng tesseract-ocr-spa tesseract-ocr-spa-old tesseract-ocr-equ

## Para compilar Scantailor enhanced. https://github.com/scantailor/scantailor/wiki/Building-from-Source-Code-on-Linux-and-Mac-OS-X
RUN apt-get install -y build-essential cmake checkinstall git
RUN apt-get install -y --no-install-recommends libqt4-dev
RUN apt-get install -y libjpeg-dev libtiff5-dev libpng12-dev zlib1g-dev libboost-all-dev libxrender-dev
# Compilar:
RUN git clone https://github.com/scantailor/scantailor.git /usr/src/scantailor
WORKDIR /usr/src/scantailor
RUN git checkout enhanced && cmake . && make && checkinstall -y


## ImageMagick
RUN apt-get install -y --no-install-recommends imagemagick

## Gimp
RUN apt-get install -y --no-install-recommends gimp gimp-plugin-registry

## Exactimage http://exactcode.com/opensource/exactimage/
RUN apt-get install -y exactimage

## PDFBeads http://proyecto.derechoaleer.org/codex/pdfbeads/  y https://rubygems.org/gems/pdfbeads

# JBIG2ENC
RUN apt-get install -y automake libleptonica-dev libjpeg62-turbo-dev libtiff5-dev libpng12-dev zlib1g-dev  autotools-dev libtool
RUN git clone https://github.com/agl/jbig2enc.git /usr/src/jbig2enc
WORKDIR /usr/src/jbig2enc
RUN ./autogen.sh && ./configure && make && make install

# PDFBeads
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable --ruby=1.9.3
RUN apt-get install -y --no-install-recommends libmagickwand-dev

ENV rvm_bin_path /usr/local/rvm/bin
ENV GEM_HOME /usr/local/rvm/gems/ruby-1.9.3-p551
ENV IRBRC /usr/local/rvm/rubies/ruby-1.9.3-p551/.irbrc
ENV MY_RUBY_HOME /usr/local/rvm/rubies/ruby-1.9.3-p551
ENV rvm_path /usr/local/rvm
ENV rvm_prefix /usr/local
ENV PATH /usr/local/rvm/gems/ruby-1.9.3-p551/bin:/usr/local/rvm/gems/ruby-1.9.3-p551@global/bin:/usr/local/rvm/rubies/ruby-1.9.3-p551/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/rvm/bin
ENV GEM_PATH /usr/local/rvm/gems/ruby-1.9.3-p551:/usr/local/rvm/gems/ruby-1.9.3-p551@global

RUN gem install pdfbeads


ADD fcen-postprocessing /fcen-postprocessing
RUN chmod 0755 /fcen-postprocessing
CMD ["bash"]
