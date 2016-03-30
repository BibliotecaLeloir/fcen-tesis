FROM debian:jessie
MAINTAINER Pablo Montepagano <pablo@montepagano.com.ar>

# Update the package repository
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
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
RUN apt-get install -y build-essential cmake checkinstall
RUN apt-get install -y --no-install-recommends libqt4-dev
RUN apt-get install -y libjpeg-dev libtiff5-dev libpng12-dev zlib1g-dev libboost-all-dev libxrender-dev

## Compilar:
# git clone https://github.com/scantailor/scantailor.git
# cd scantailor
# git checkout enhanced
# cmake .
# make
# checkinstall


## PDFBeads
RUN apt-get install -y ruby ruby-dev ruby-rmagick
RUN gem install pdfbeads

## ImageMagick
RUN apt-get install -y --no-install-recommends imagemagick

## Gimp
RUN apt-get install -y --no-install-recommends gimp gimp-plugin-registry

## Exactimage http://exactcode.com/opensource/exactimage/
RUN apt-get install exactimage



ADD start.sh /start.sh
RUN chmod 0755 /start.sh
CMD ["bash", "start.sh"]
