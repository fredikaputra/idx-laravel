import { readFileSync, writeFileSync, existsSync } from "fs";
import { join } from "path";

const targetDir = process.argv[2] || ".";

const tsPath = join(targetDir, "vite.config.ts");
const jsPath = join(targetDir, "vite.config.js");

const fileName = existsSync(tsPath) ? tsPath : (existsSync(jsPath) ? jsPath : null);

if (!fileName) {
    console.error(`Could not find vite.config.js or .ts in ${targetDir}`);
    process.exit(0);
}

let content = readFileSync(fileName, "utf-8");

if (!content.includes("process.loadEnvFile();")) {
    content = content.replace("export default defineConfig({", "process.loadEnvFile();\n\nexport default defineConfig({");
}

const hmrBlock = "        hmr: {\n" +
                 "            host: process.env.HMR_HOST,\n" +
                 "            clientPort: parseInt(process.env.HMR_PORT || ''),\n" +
                 "            protocol: process.env.HMR_PROTOCOL,\n" +
                 "        },";

const fullServerBlock = "    server: {\n" + hmrBlock + "\n    },";

if (content.includes("server: {")) {
    content = content.replace("server: {", "server: {\n" + hmrBlock);
} else {
    content = content.replace(/\}\);\s*$/, (match) => {
        return fullServerBlock + "\n" + match;
    });
}

writeFileSync(fileName, content);
