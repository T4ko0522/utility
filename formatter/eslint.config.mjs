import antfu from "@antfu/eslint-config";
import tailwindcss from "eslint-plugin-better-tailwindcss";
import pluginQuery from "@tanstack/eslint-plugin-query";

export default antfu(
  {
    react: {
      reactCompiler: false,
      overrides: {
        "react/no-context-provider": "off",
        "react/no-forward-ref": "off",
        "react/no-use-context": "off",
        "react-hooks/set-state-in-effect": "off",
      },
    },
    nextjs: true,
    ignores: [
      "node_modules/**",
      ".next/**",
      "out/**",
      "build/**",
      "dist/**",
      ".nuxt/**",
      ".output/**",
      ".vite/**",
      ".turbo/**",
      ".cache/**",
      "coverage/**",
      "next-env.d.ts",
      "src/components/ui/**",
      "*.mjs",
      "*.cjs",
      "*.min.js",
    ],
    typescript: {
      overrides: {
        "ts/consistent-type-definitions": ["error", "type"],
        "ts/no-explicit-any": "error",
      },
    },
    test: {
      overrides: {
        "test/prefer-lowercase-title": "off",
      },
    },
    stylistic: {
      overrides: {
        "antfu/top-level-function": "off",
        "style/quotes": ["error", "double"],
        "style/semi": ["error", "always"],
      },
    },
  },
  {
    rules: {
      "node/prefer-global/process": "off",
    },
  },
  ...pluginQuery.configs["flat/recommended"],
  tailwindcss.configs.recommended,
  {
    settings: {
      "better-tailwindcss": {
        entryPoint: "src/app/globals.css",
      },
    },
    rules: {
      "better-tailwindcss/enforce-consistent-class-order": "warn",
      "better-tailwindcss/enforce-consistent-line-wrapping": "off",
      "better-tailwindcss/enforce-shorthand-classes": "warn",
      "better-tailwindcss/no-unknown-classes": [
        "error", {
        ignore: [

        ],
      },
    ],
    },
  },
);
