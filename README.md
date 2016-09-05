# A Speed Reader that lets you come up for air.

[Get the Chrome Extension](https://chrome.google.com/webstore/detail/splashreader-speed-readin/poilkhacfacheblaajlfkdclgbpjolmd)

## Description

Sometimes, you want to zoom through an article at 800 words per minute.

But you might miss something. You might lose sense of where you are - in a bulleted list? A new paragraph?

SplashReader lets you easily switch back and forth between speed-reading and normal reading with a flick of the space bar. It pauses every paragraph, giving a sense of context. Highlight a word to re-read a section or start again somewhere new.

Don't sacrifice comprehension for speed when you don't have to.

SplashReader is an RSVP (Rapid Serial Visual Presentation), similar to other excellent speed-readers like Reedy, Spreed, Spritz, Squirt.io, and Glance. The main difference is the ease with which you can move back and forth between one-word-at-a-time speed reading, and standard reading.


## To Develop:

- Install deps: `npm install`
- To build/watch: `npm run dev`
    + Navigate to `chrome://extensions`, 
    turn on developer mode, 
    and click "load unpacked extension". Choose this directory.
- To create a chrome extension zip: `npm run chrome`
- To typecheck, `brew install flow`, and run `flow`.
- To lint, `npm install -g eslint babel-eslint`, and run `eslint`
