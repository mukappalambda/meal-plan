# Default
default:
    @just --list

# Clean the build directory
clean:
    @rm -rf build
    @find . -type f -name '*.bak[0-9]*' -delete
    @find -type f -name '*.pdf' -delete

_pre-step:
    @docker ps -f name=mytexlive -aq | xargs -I{} docker rm -f {}

# Build the docker image
build-image: _pre-step
    @docker build --tag mytexlive:0.1.0 .
    @docker image ls -f dangling=true -aq | xargs -I{} docker rmi {}

# Build the PDF
build: clean
    @latexmk -xelatex -outdir=build main.tex
    @echo "\033[1;32m The PDF is built under ./build/\033[0m"

# Build the PDF inside image
build-in-docker: _pre-step
    @docker run -dt --name mytexlive mytexlive:0.1.0
    @docker exec mytexlive make build
    @docker cp mytexlive:/home/appuser/build/main.pdf .
    @echo "\033[1;32m The PDF is built under current path\033[0m"

# Install texlive dependencies
install-texlive-deps:
    @tlmgr install latexmk xetex xecjk fontspec geometry tcolorbox fancyhdr xcolor titlesec multirow setspace enumitem
    @sudo apt install fonts-texgyre=20180621-6
    @fc-cache -fv

# Install tex-fmt
install-tex-fmt:
    @cargo install tex-fmt

# Format tex source
format:
    @tex-fmt *.tex
