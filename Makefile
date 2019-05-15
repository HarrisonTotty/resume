.PHONY: src

CC = xelatex -halt-on-error
BUILD_DIR = build
SRC_DIR = src
RESUME_DIR = src/resume
CV_DIR = src/cv
RESUME_SRCS = $(shell find $(RESUME_DIR) -name '*.tex')
CV_SRCS = $(shell find $(CV_DIR) -name '*.tex')

all: $(foreach x, coverletter cv resume, $x.pdf)

coverletter.pdf: $(SRC_DIR)/coverletter.tex
	$(CC) -output-directory=$(SRC_DIR) $< && \
	mv $(SRC_DIR)/coverletter.pdf $(BUILD_DIR)/ && \
	rm -rf $(SRC_DIR)/*.{aux,log,out}

cv.pdf: $(SRC_DIR)/cv.tex $(CV_SRCS)
	$(CC) -output-directory=$(SRC_DIR) $< && \
	mv $(SRC_DIR)/cv.pdf $(BUILD_DIR)/ && \
	rm -rf $(SRC_DIR)/*.{aux,log,out}

resume.pdf: $(SRC_DIR)/resume.tex $(RESUME_SRCS)
	$(CC) -output-directory=$(SRC_DIR) $< && \
	mv $(SRC_DIR)/resume.pdf $(BUILD_DIR)/ && \
	rm -rf $(SRC_DIR)/*.{aux,log,out}

clean:
	rm -rf $(BUILD_DIR)/*.pdf && rm -rf $(SRC_DIR)/*.{aux,log,out}
