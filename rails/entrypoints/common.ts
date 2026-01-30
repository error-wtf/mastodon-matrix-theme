import { start } from 'mastodon/common';
import { initMatrixTheme } from 'mastodon/features/MATRIX/matrix_theme';

// Import Matrix rain effect (side-effect: auto-initializes when theme-matrix class is present)
import '@/MATRIX/matrix/index.js';

start();
initMatrixTheme();
