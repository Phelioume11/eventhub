export default {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'scope-enum': [1, 'always', ['api', 'front', 'docker', 'ci', 'docs', 'deps']],
    'subject-max-length': [2, 'always', 72],
  },
};
