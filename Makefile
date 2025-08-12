help: ## Show help message
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

clean: ## Clean the build directory
	@echo "$(WHALE) $@"
	@rm -rf build
	@find . -type f -name '*.bak[0-9]*' -delete
	@find -type f -name '*.pdf' -delete

pre-step:
	@docker ps -f name=mytexlive -aq | xargs -I{} docker rm -f {}

build-image: pre-step ## Build the docker image
	@echo "$(WHALE) $@"
	@docker build --tag mytexlive:0.1.0 .
	@docker image ls -f dangling=true -aq | xargs -I{} docker rmi {}

build: clean ## Build the PDF
	@echo "$(WHALE) $@"
	@latexmk -xelatex -outdir=build main.tex
	@echo "\033[1;32m The PDF is built under ./build/\033[0m"

build-in-docker: pre-step ## Build the PDF inside image
	@echo "$(WHALE) $@"
	@docker run -dt --name mytexlive mytexlive:0.1.0
	@docker exec mytexlive make build
	@docker cp mytexlive:/home/appuser/build/main.pdf .
	@echo "\033[1;32m The PDF is built under current path\033[0m"

install-texlive-deps: ## Install texlive dependencies
	@tlmgr install latexmk xetex xecjk fontspec geometry tcolorbox fancyhdr xcolor titlesec multirow setspace enumitem
	@sudo apt install fonts-texgyre=20180621-6
	@fc-cache -fv

install-tex-fmt: ## Install tex-fmt
	@echo "$(WHALE) $@"
	@cargo install tex-fmt

format: ## Format tex source
	@echo "$(WHALE) $@"
	@tex-fmt *.tex
