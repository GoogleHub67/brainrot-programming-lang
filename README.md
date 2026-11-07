# 🚀 brainrot-programming-lang

An ultra-modern, high-performance programming language transpilation framework that translates custom vocabulary logic structures into type-safe, optimized TypeScript execution contexts. Powered by Node.js, `tsx`, and a custom high-speed text mapping matrix pipeline.

---

## 📂 Repository Layout

```text
brainrot-programming-lang/
├── .vscode/                       # Editor interface adjustments
│   └── settings.json              # Automatic VS Code syntax highlighting mapping
├── _data/                         # System metadata configuration storage
│   └── keywords.json              # The core dictionary mapping token database
├── content/
│   └── basic-brainrot-scripts/    # Code playground & standard script gallery
│       ├── test.rot               # Core operational testing script
│       ├── fizzbuzz.rot           # Nested loop execution benchmark
│       ├── bubble-sort.rot        # Array index mutation stress verification
│       ├── class-inheritance.rot  # Object-Oriented paradigm verification
│       └── [many more...]         # Multi-tier control flow logic suites
├── .eslintrc.json                 # Core linter metrics (analyzes code bugs)
├── .gitignore                     # Prevents tracking system cache noise (node_modules)
├── .npmrc                         # Strict package manager runtime settings
├── .prettierrc                    # Automated code layout formatting style policies
├── BrainrotEngine.ts              # Core translator, parser, & runtime engine
├── LICENSE
├── Makefile                       # Cross-platform automation (Windows CMD & Linux)
├── package-lock.json              # Absolute snapshot lock of deep dependencies
├── package.json                   # Modern ES Module dependency architecture
└── tsconfig.json                  # Type-checking compiler flags configuration
```

---

## 🛠️ Project Environment Setup

Ensure you have a modern version of **Node.js** installed on your system layout. To automatically pull down configuration dependencies and map the workspace parameters, run:

```cmd
make install
```

---

## 🏎️ Automation Pipeline Commands

Your project includes a fully featured automation layer via the `Makefile` to handle development lifecycles seamlessly:

### 1. Validate & Type-Check Code Base (`make compile`)
Runs structural diagnostics, processes syntax parsing verifications, and catches type-checking mismatch exceptions across the workspace core without generating unnecessary build caches:

```cmd
make compile
```

### 2. Run the Engine Pipeline (`make run`)
Compiles, translates, and executes the default validation script (`content/basic-brainrot-scripts/test.rot`) using our automated parsing tracking matrix:

```cmd
make run
```

### 3. Clear Development Cache (`make clean`)
Instantly purges local module distribution layers and module dependency lock setups to restore the workspace back to a clean baseline state:

```cmd
make clean
```

---

## 🏎️ Shorthand CLI Script Execution

You can bypass the automation defaults and target any standalone development script directly inside your repository using our custom `npm` wrapper shorthand command:

```cmd
npm run brainrot content/basic-brainrot-scripts/NAME_OF_FILE.rot _data/keywords.json
```
