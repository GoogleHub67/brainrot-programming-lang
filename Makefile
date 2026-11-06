# OS Architecture Detection Hook
ifeq ($(OS),Windows_NT)
    # Windows native execution commands
    RM = del /Q /F
    NULL_OUTPUT = >nul 2>&1
    
    # FIX: Bypasses ts-node configuration bugs by utilizing Node's built-in TypeScript execution support
    EXEC_ENGINE = node --experimental-strip-types brainrotengine.ts
    
    COMPILE_CHECK = npx tsc --noEmit --project .
    INSTALL_ENV = npm init -y $(NULL_OUTPUT) && npm install --save-dev typescript @types/node $(NULL_OUTPUT)
else
    # Linux / Debian native execution commands
    RM = sudo rm -f
    NULL_OUTPUT = >/dev/null 2>&1
    
    # FIX: Bypasses ts-node configuration bugs by utilizing Node's built-in TypeScript execution support
    EXEC_ENGINE = node --experimental-strip-types brainrotengine.ts
    
    COMPILE_CHECK = npx tsc --noEmit --project .
    
    # Corrected macro configuration using uniform space indents to prevent raw shell assignment errors
    define INSTALL_ENV
echo "Installing Linux crypto system requirements..." && \
sudo apt-get update -y $(NULL_OUTPUT) || true && \
sudo apt-get install -y ca-certificates curl gnupg $(NULL_OUTPUT) && \
sudo mkdir -p /etc/apt/keyrings && \
$(RM) /etc/apt/keyrings/nodesource.gpg /etc/apt/sources.list.d/nodesource.list $(NULL_OUTPUT) || true && \
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg $(NULL_OUTPUT) && \
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list > /dev/null && \
sudo apt-get update -y $(NULL_OUTPUT) && \
sudo apt-get install -y nodejs $(NULL_OUTPUT) && \
npm init -y $(NULL_OUTPUT) || true && \
npm install --save-dev typescript @types/node $(NULL_OUTPUT)
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
	@$(COMPILE_CHECK)

# Step 3: Run the Script Engine targeting test.rot
run:
	@echo "Invoking the custom parsing pipeline on test.rot..."
	@$(EXEC_ENGINE) test.rot

# Bonus Step: Clean workspace development caches safely across cross-platforms
clean:
	@echo "Wiping module dependency locks..."
	@$(if $(filter Windows_NT,$(OS)),if exist node_modules rmdir /S /Q node_modules,sudo rm -rf node_modules)
