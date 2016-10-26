fcen-tesis
----------


Para correr el script lo más fácil es hacerlo con Docker.

Para armar el container, correr:

    docker build -t fcenbiblioteca/ocr:v0 .

Agregar `--build-arg proxy=http://proxy.fcen.uba.ar:8080` si estás atrás del proxy de la FCEN.

Luego, para correr el OCR de una tesis que esté en /srv/tiff y escribir el output a /srv/ocr, hacer:

    docker run --rm -t -i -v /srv/tiff:/srv/tiff -v /srv/ocr:/srv/ocr fcenbiblioteca/ocr:v0 "src=/srv/tiff/" "wrk=/srv/ocr/" "name=Tesis_2680_Castro" "dir=Tesis_2680_Castro" "imgimprove=0021"


*Entorno de software utilizado:*

#### Scantailor Enhanced: ####

- [Instrucciones paso a paso para compilar Scantailor en Debian](http://codex.bibliohack.tk/scan_tailor/)
- [Código fuente en github](https://github.com/scantailor/scantailor/tree/enhanced)

Nota: La ruta por defecto al ejecutable en el script es: `/opt/src/scantailor-enhanced/scantailor-cli`.

#### Tesseract: ####

instalar

      apt-get install tesseract-ocr tesseract-ocr-eng tesseract-ocr-spa tesseract-ocr-spa-old tesseract-ocr-equ

Compilar: [Compilar e Instalar tesseract-ocr en Debian](http://codex.bibliohack.tk/tesseract-ocr/)

#### Pdfbeads: ####

- [Instrucciones paso a paso para instalar PDFBeads en Debian](http://codex.bibliohack.tk/pdfbeads/)
- [Página de Pdfbeads en rubygems.org](https://rubygems.org/gems/pdfbeads)

#### ImageMagick: ####

Para instalar en Debian/Ubuntu:

     apt-get install imagemagick

#### Gimp: ####

Para instalar en Debian/Ubuntu:

      apt-get install gimp gimp-plugin-registry

#### Exactimage: ####

Para instalar en Debian/Ubuntu:

      apt-get install exactimage

[Sitio web de exactimage](http://exactcode.com/opensource/exactimage/)


Documentación
-------------

[profile-processor](https://github.com/d-a-l/fcen-tesis/blob/master/fcen-postprocessing/docs/profile-processor/man-profile-processor.md)
