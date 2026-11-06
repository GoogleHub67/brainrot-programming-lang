import * as fs from 'fs';
import * as path from 'path';
import * as os from 'os';
import { execSync } from 'child_process';

export class BrainrotEngine {

  // ---- Tiny JSON parser: flat { "KEY": "value", ... } only ----
  private static parseFlatJson(raw: string): Array<[string, string]> {
    const s = raw.trim();
    const fail = (msg: string): never => {
      throw new Error(`keywords.json: ${msg}`);
    };

    let i = 0;
    const skipWs = (): void => {
      while (i < s.length && /\s/.test(s[i])) {
        i++;
      }
    };

    const readString = (): string => {
      skipWs();
      if (i >= s.length || s[i] !== '"') fail("expected a string");
      i++;
      let b = "";
      while (i < s.length && s[i] !== '"') {
        if (s[i] === '\\') {
          i++;
          if (i >= s.length) fail("cut-off escape");
          const c = s[i];
          switch (c) {
            case 'n': b += '\n'; i++; break;
            case 't': b += '\t'; i++; break;
            case 'r': b += '\r'; i++; break;
            case 'b': b += '\b'; i++; break;
            case 'f': b += '\f'; i++; break;
            case '"': b += '"';  i++; break;
            case '\\': b += '\\'; i++; break;
            case '/': b += '/';  i++; break;
            case 'u':
              if (i + 4 >= s.length) fail("bad \\u escape");
              const hex = s.substring(i + 1, i + 5);
              b += String.fromCharCode(parseInt(hex, 16));
              i += 5;
              break;
            default: fail(`unknown escape \\${c}`);
          }
        } else {
          b += s[i];
          i++;
        }
      }
      if (i >= s.length) fail("unterminated string");
      i++;
      return b;
    };

    skipWs();
    if (i >= s.length || s[i] !== '{') fail("root must be a { } object");
    i++;
    skipWs();
    if (i < s.length && s[i] === '}') {
      i++;
      return [];
    }

    const out: Array<[string, string]> = [];
    while (true) {
      const k = readString();
      skipWs();
      if (i >= s.length || s[i] !== ':') fail("expected ':'");
      i++;
      const v = readString();
      out.push([k, v]);
      skipWs();
      if (i < s.length && s[i] === ',') {
        i++;
      } else if (i < s.length && s[i] === '}') {
        i++;
        return out;
      } else {
        fail("expected ',' or '}'");
      }
    }
  }

  // ---- Translation Engine ----
  private static readonly StrLit = /"(?:[^"\\]|\\.)*"/g;

  private static escapeRegExp(string: string): string {
    return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  }

  private static swapKeywords(chunk: string, dict: Array<[string, string]>): string {
    let result = chunk;
    for (const [meme, tsKw] of dict) {
      const regex = new RegExp(this.escapeRegExp(meme), 'g');
      result = result.replace(regex, () => tsKw);
    }
    return result;
  }

  private static translate(capCode: string, dict: Array<[string, string]>): string {
    // Sort longest first: "NO CAP" beats "CAP"
    const sorted = [...dict].sort((a, b) => b[0].length - a[0].length);
    
    let result = "";
    let lastIndex = 0;
    let match;

    // Reset regex state tracking
    this.StrLit.lastIndex = 0;

    while ((match = this.StrLit.exec(capCode)) !== null) {
      const textBefore = capCode.substring(lastIndex, match.index);
      result += this.swapKeywords(textBefore, sorted);
      result += match[0]; // String literals stay untouched
      lastIndex = this.StrLit.lastIndex;
    }

    result += this.swapKeywords(capCode.substring(lastIndex), sorted);
    return result;
  }

  // ---- Main Runner Context ----
  public static main(args: string[]): void {
    if (args.length < 1) {
      console.log("SKILL ISSUE: Please provide a .cap file! Example: node brainrotengine.js script.cap");
      process.exit(1);
    }

    const capFilePath = args[0];
    const dictPath = args[1] || "/content/keywords.json";

    // FIX: Variables initialized with structural safe-defaults to satisfy control flow checks
    let capCode: string = "";
    try {
      capCode = fs.readFileSync(capFilePath, 'utf-8');
    } catch {
      console.log(`SKILL ISSUE: Could not read file ${capFilePath}`);
      process.exit(1);
    }

    let rawJson: string = "";
    try {
      rawJson = fs.readFileSync(dictPath, 'utf-8');
    } catch {
      console.log(`SKILL ISSUE: Could not read dictionary ${dictPath}`);
      process.exit(1);
    }

    let dict: Array<[string, string]> = [];
    try {
      dict = this.parseFlatJson(rawJson);
    } catch (e: any) {
      console.log(`SKILL ISSUE (bad dictionary): ${e.message}`);
      process.exit(1);
    }
    console.log(`Loaded ${dict.length} brainrot keywords from ${dictPath}`);

    const tsCode = this.translate(capCode, dict);

    // Create a secure temp file execution context
    const tempDir = os.tmpdir();
    const tempFilePath = path.join(tempDir, `cap_output_${Date.now()}.ts`);
    
    try {
      fs.writeFileSync(tempFilePath, tsCode, 'utf-8');
    } catch (e: any) {
      console.log(`SKILL ISSUE (Write Error): ${e.message}`);
      process.exit(1);
    }

    // Process termination handling cleanup hook
    const cleanup = () => {
      try { if (fs.existsSync(tempFilePath)) fs.unlinkSync(tempFilePath); } catch {}
    };
    process.on('exit', cleanup);
    process.on('SIGINT', () => { cleanup(); process.exit(1); });

    // Execute the compiled TypeScript output directly using ts-node
    try {
      const output = execSync(`node --experimental-strip-types \${tempFilePath}`, { encoding: 'utf-8' });
      console.log(output.trim());
    } catch (e: any) {
      console.log(`SKILL ISSUE (Compile/Runtime Error):\n${e.message}`);
    }
  }
}

// Automatically invoke engine runner execution if run directly via CLI context
if (require.main === module) {
  BrainrotEngine.main(process.argv.slice(2));
}
