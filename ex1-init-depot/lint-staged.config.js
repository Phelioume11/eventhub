// Le hook est lancé depuis la racine du dépôt : ces règles s'appliquent à tous les exercices.
const dir = 'ex1-init-depot';
const eslint = `node ${dir}/node_modules/eslint/bin/eslint.js --fix --config ${dir}/eslint.config.js`;
const prettier = `node ${dir}/node_modules/prettier/bin/prettier.cjs --write --config ${dir}/.prettierrc.json --ignore-path ${dir}/.prettierignore`;

export default {
  '*.{ts,tsx,js}': [eslint, prettier],
  '*.{json,md,yml}': [prettier],
};
