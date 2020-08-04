# Experiment Web Page Component

This houses the front-end component of an experiment. Dependencies are in the yarn.lock or package.json files, which are packaged by the CLI and attached to the core website using the shortName defined by the experiment’s config.yaml file. Pushkin uses React for the front end. Experiment web pages are mounted as React components and given the full size of the screen under the header and navigation bar.

## Recommended Structure

As long as the webpage folder contains an `index.js` file in `web page/src` that includes all your experiment code, you should be set. It is not even necessary for this to use jsPsych. However, we recommend building on top of an experiment template. Most have the same structure, including in the `/src` folder two files \(`experiments.js` and `index.js`\) and a folder \(`/assets`\). `experiments.js` contains a jsPsych timeline. `index.js` is essentially a wrapper around the timeline. The core functionality of interest is here:

```javascript
      async startExperiment() {
  this.setState({ experimentStarted: true });

  jsPsych.data.addProperties({user_id: this.props.userID}); //See https://www.jspsych.org/core_library/jspsych-data/#jspsychdataaddproperties
  await pushkin.connect('/api/pushkintemplate');
  await pushkin.prepExperimentRun(this.props.userID);
  await pushkin.loadScripts([
    'https://cdn.jsdelivr.net/gh/jspsych/jsPsych@6.0.4/plugins/jspsych-html-keyboard-response.js',
  ]);
  const timeline = pushkin.setSaveAfterEachStimulus(timeline_basic);
  await jsPsych.init({
    display_element: document.getElementById('jsPsychTarget'),
    timeline: timeline,
    on_finish: this.endExperiment.bind(this),
  });

  document.getElementById('jsPsychTarget').focus();
  this.setState({ loading: false });
}

endExperiment() {
  document.getElementById("jsPsychTarget").innerHTML = "Thank you for participating!";
}
```

Any jsPsych plugins you need to use should be listed inside `pushkin.loadScripts()`. All jsPsych plugins should be available through jsdelivr.net. It is fairly self-explanatory: just edit the URL to indicate the jsPsych version and the name of the plugin.

Another line of code worth noting is `const timeline = pushkin.setSaveAfterEachStimulus(timeline_basic);`. This uses a helper function from the pushkin-client to save data after each stimulus. This is generally good practice. You could of course write this into the timeline, but this helper function saves some typing.

Finally, when the timeline finishes `endExperiment()` will be called. In the template, this simply adds a “Thank you for participating” message. If one were providing more complex feedback, that could be handled in this function.

### Assets

The `assets` folder should contain any static assets that will be imported by React.

Note that this method of importation won’t work for files referenced by jsPsych. jsPsych timelines are not compiled by React, and so by the time jsPsych runs, the files on the server are no longer accessible. However, create-react-app provides a nifty workaround: `process.env.PUBLIC_URL` will point to the folder `/front-end/src/public` during runtime.

## Customizing the client

{ This section is a work in progress! }

If you need to extend the client with custom API calls, etc., you should extend the defaultClient class. For instance, rather than loading the pushkin client directly:

You would first extend it, adding any additional methods you need:

