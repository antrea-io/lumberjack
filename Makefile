SHELL := /bin/bash

GO ?= go

# Arguments to pass to the "go test" invocation.
# Example: make check TEST_ARGS="-run ^TestMaxAge$"
TEST_ARGS ?=

GOLANGCI_LINT_VERSION := v2.12.2
GOLANGCI_LINT_BINDIR := $(CURDIR)/.golangci-bin
GOLANGCI_LINT_BIN := $(GOLANGCI_LINT_BINDIR)/$(GOLANGCI_LINT_VERSION)/golangci-lint

.PHONY: all
all: check

.PHONY: check
check:
	@echo "===> Running unit tests <==="
	@CGO_ENABLED=1 $(GO) test $(TEST_ARGS) -race ./...

$(GOLANGCI_LINT_BIN):
	@echo "===> Installing golangci-lint <==="
	@rm -rf $(GOLANGCI_LINT_BINDIR)/* # remove old versions
	@curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/$(GOLANGCI_LINT_VERSION)/install.sh | sh -s -- -b $(GOLANGCI_LINT_BINDIR)/$(GOLANGCI_LINT_VERSION) $(GOLANGCI_LINT_VERSION)

.PHONY: golangci
golangci: $(GOLANGCI_LINT_BIN)
	@echo "===> Running golangci-lint <==="
	@$(GOLANGCI_LINT_BIN) run ./...

.PHONY: golangci-fix
golangci-fix: $(GOLANGCI_LINT_BIN)
	@echo "===> Running golangci-lint --fix <==="
	@$(GOLANGCI_LINT_BIN) run --fix ./...

.PHONY: clean
clean:
	@rm -rf $(GOLANGCI_LINT_BINDIR)
