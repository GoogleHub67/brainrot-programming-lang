# OS Architecture Detection Hook
ifeq ($(OS),Windows_NT)
    # Windows native execution commands
    RM = del /Q /F
    NULL_OUTPUT = >nul 2>&1
    EXEC_ENGINE = npx ts-node brainrotengine.ts
    COMPILE_CHECK = npx tsc --noEmit brainrotengine.ts
    INSTALL_ENV = npm init -y $(NULL_OUTPUT) && npm install --save-dev typescript ts-node @types/node $(NULL_OUTPUT)
else
    # Linux / Debian native execution commands
    RM = sudo rm -f
    NULL_OUTPUT = >/dev/null 2>&1
    EXEC_ENGINE = npx ts-node brainrotengine.ts
    COMPILE_CHECK = npx tsc --noEmit brainrotengine.ts
    
    # Inline generation block executing NodeSource manual configuration setups safely via escaped single shell streams
    define INSTALL_ENV
	echo "Installing Linux crypto system requirements..." && \
	sudo apt-get update -y $(NULL_OUTPUT) || true && \
	sudo apt-get install -y apt-transport-https ca-certificates curl gnupg $(NULL_OUTPUT) && \
	sudo mkdir -p /usr/share/keyrings && \
	$(RM) /usr/share/keyrings/nodesource.gpg /etc/apt/sources.list.d/nodesource.sources $(NULL_OUTPUT) || true && \
	curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/nodesource.gpg $(NULL_OUTPUT) && \
	sudo chmod 644 /usr/share/keyrings/nodesource.gpg && \
	printf "Types: deb\nURIs: https://deb.nodesource.com/node_20.x\nSuites: nodistro\nComponents: main\nArchitectures: $$(dpkg --print-architecture)\nSigned-By: /usr/share/keyrings/nodesource.gpg\n" | sudo tee /etc/apt/sources.list.d/nodesource.sources > /dev/null && \
	printf "Package: nodejs\nPin: origin deb.nodesource.com\nPin-Priority: 600\n" | sudo tee /etc/apt/preferences.d/nodejs > /dev/null && \
	sudo apt-get update -y $(NULL_OUTPUT) && \
	sudo apt-get install -y nodejs $(NULL_OUTPUT) && \
	npm init -y $(NULL_OUTPUT) || true && \
	npm install --save-dev typescript ts-node @types/node $(NULL_OUTPUT)
    endef
endif

.PHONY: install compile run clean

# Step 1: Detect architecture and inject environment properties
install:
	@echo "Detected Operating System Focus: [$(if $(filter Windows_NT,$(OS)),Windows CMD,Debian Linux)]"
	@echo "Configuring environment dependencies..."
	@$(INSTALL_ENV)
	@echo "All workspace runtime instances successfully mapped!"

# Step 2: Validate the syntax and execute structural type-checking across the Engine core
compile:
	@echo "Analyzing compilation diagnostics across the workspace core..."
	@$(COMPILE_CHECK) $(if $(filter Windows_NT,$(OS)),,2>&1; echo "EXIT: $$?")

# Step 3: Run the Script Engine targeting test.rot
run:
	@echo "Invoking the custom parsing pipeline on test.rot..."
	@$(EXEC_ENGINE) test.rot

# Bonus Step: Clean workspace development caches safely across cross-platforms
clean:
	@echo "Wiping module dependency locks..."
	@$(if $(filter Windows_NT,$(OS)),if exist node_modules rmdir /S /Q node_modules,sudo rm -rf node_modules)
