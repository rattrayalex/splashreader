/* @flow */

export const splashreaderContainerId = 'splashreader-wrapper'

export const wordOptions = {
  wordOptions: {
    wordRegex: /[^–—\s]+/gi,
  },
  characterOptions: {
    includeBlockContentTrailingSpace: false,
    includeSpaceBeforeBr: false,
    includePreLineTrailingSpace: false,
  },
}
