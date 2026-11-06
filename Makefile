.PHONY: install compile run

# Step 1: Clone official NodeSource manual setup logic, configure modern architecture paths, and install nodejs safely
install:
	@echo "Installing system-level cryptographic prerequisites..."
	@sudo apt-get update -y > /dev/null 2>&1 || true
	@sudo apt-get install -y apt-transport-https ca-certificates curl gnupg > /dev/null 2>&1
	@sudo mkdir -p /usr/share/keyrings
	@echo "Importing secure NodeSource signing key rings..."
	@sudo rm -f /usr/share/keyrings/nodesource.gpg /etc/apt/sources.list.d/nodesource.sources > /dev/null 2>&1 || true
	@curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/nodesource.gpg > /dev/null 2>&1
	@sudo chmod 644 /usr/share/keyrings/nodesource.gpg
	@echo "Injecting native system architecture metadata structures..."
	@printf "Types: deb\nURIs: https://deb.nodesource.com/node_20.x\nSuites: nodistro\nComponents: main\nArchitectures: $$(dpkg --print-architecture)\nSigned-By: /usr/share/keyrings/nodesource.gpg\n" | sudo tee /etc/apt/sources.list.d/nodesource.sources > /dev/null
	@echo "Pinning package delivery weights..."
	@printf "Package: nodejs\nPin: origin deb.nodesource.com\nPin-Priority: 600\n" | sudo tee /etc/apt/preferences.d/nodejs > /dev/null
	@echo "Provisioning Node.js engine binaries..."
	@sudo apt-get update -y > /dev/null 2>&1
	@sudo apt-get install -y nodejs > /dev/null 2>&1
	@echo "Initializing workspace metadata manifest and resolving local toolchains..."
	@npm init -y > /dev/null 2>&1 || true
	@npm install --save-dev typescript ts-node @types/node > /dev/null 2>&1
	@echo "Environment configuration finalized! Dependencies safely mapped without global namespace pollution."

# Step 2: Validate the syntax and execute structural type-checking across the Engine core
compile:
	@echo "Analyzing compilation diagnostics across the workspace core..."
	@npx tsc --noEmit brainrotengine.ts 2>&1; echo "EXIT: $$?"

# Step 3: Run the Script Engine targeting test.rot
run:
	@echo "Invoking the custom parsing pipeline on test.rot..."
	@npx ts-node brainrotengine.ts test.rot
