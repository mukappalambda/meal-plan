FROM texlive/texlive:latest-basic AS build

SHELL ["/bin/bash", "-c"]

RUN tlmgr update --self && \
    tlmgr install latexmk xetex titlesec multirow setspace enumitem fontspec xcolor

RUN apt-get update && \
    apt-get install --yes --no-install-recommends fonts-texgyre=20180621-6 && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -r appuser && useradd --no-log-init -m -s /bin/bash -r -g appuser appuser

USER "appuser"

ENV HOME=/home/appuser

ENV PATH="/usr/local/texlive/2025/bin/x86_64-linux:$HOME/.local/bin:$PATH"

WORKDIR $HOME

COPY Makefile main.tex ./

CMD ["/bin/bash"]
