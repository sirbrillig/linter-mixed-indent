'use babel';
/*global atom*/

import { lint } from 'mixedindentlint';
import LinterHelpers from 'atom-linter';

export default {
  config: {
    ignoreComments: {
      type: 'boolean',
      default: false,
      title: 'Ignore Comments',
      description:
        'Ignore comments entirely in code. Otherwise comment indentation will be scanned as well.',
    },
    forceIndentationType: {
      type: 'string',
      enum: ['automatic', 'tabs', 'spaces'],
      default: 'automatic',
      title: 'Force Indentation Type',
      description:
        'Always assume indentation should be one type, rather than scanning the file for the most common indentation.',
    },
  },

  activate() {},

  deactivate() {},

  scanFile(textEditor) {
    const forceIndentationType = atom.config.get(
      'linter-mixed-indent.forceIndentationType',
    );
    const options = {
      comments: atom.config.get('linter-mixed-indent.ignoreComments'),
      indent:
        forceIndentationType === 'automatic' ? null : forceIndentationType,
    };
    const text = textEditor.getText();
    const linesToDecorate = lint(text, options);
    return linesToDecorate.map(line => {
      return {
        type: 'Warning',
        text: 'Indentation different from rest of file',
        range: LinterHelpers.rangeFromLineNumber(textEditor, line - 1),
        filePath: textEditor.getPath(),
      };
    });
  },

  provideLinter() {
    return {
      name: 'MixedIndent',
      grammarScopes: ['*'],
      scope: 'file',
      lintOnFly: true,
      lint: this.scanFile,
    };
  },
};
