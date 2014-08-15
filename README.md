# Versal Player API [![Build Status](https://travis-ci.org/Versal/player-api.svg?branch=master)](https://travis-ci.org/Versal/player-api) [![Code Climate](https://codeclimate.com/github/Versal/player-api.png)](https://codeclimate.com/github/Versal/player-api)

The Versal Player API provides a convenience layer and stability buffer on top
of the [iframe launcher spec](https://github.com/Versal/versal-gadget-launchers/iframe-launcher/README.md). Please
refer to the [api doc](./api.md) for the full list of supported events and commands.

## Installation

Include as a Bower dependency:

    bower install --save Versal/player-api

With web components:

    <link rel="import" href="bower_components/player-api/index.html">

With vanilla HTML:

    <script src="bower_components/eventEmitter/EventEmitter.js"></script>
    <script src="bower_components/versal-player-api/index.js"></script>

Then instantiate the player API object:

     var playerApi = new VersalPlayerAPI()

## Messages from gadget to player

All supported messages from gadget to player are exposed as methods on the player API object.

### `startListening`

Indicates that the gadget has subscribed to the necessary messages and is ready to start receiving them. This would be typically the first message sent by the gadget to the player.

Example: `playerApi.startListening()`

### `setHeight`

Assign height (in pixels) to the gadget's container.

Example: `playerApi.setHeight(420)`

### `setHeightToBodyHeight`

Assign height to the gadget's container according to the current height of the gadget's `body` element.

Example: `playerApi.setHeightToBodyHeight()`

### `watchBodyHeight`

Create a watching timer that will refresh the gadget container's height according to the current height of the gadget's `body` element. The value of the timer interval is given in milliseconds; the default value is 32.

Example: `playerApi.watchBodyHeight({interval: 200})`

### `unwatchBodyHeight`

Stop dynamically adjusting the gadget container's height.

Example: `playerApi.unwatchBodyHeight()`

### `setAttribute`

Persist a single attribute in the gadget configuration.

Example: `playerApi.setAttribute('myColor', '#202020')`

### `setAttributes`

Persist a object containing the changed attributes in the gadget configuration. Only the changed attributes need to be specified (not the entire gadget configuration).

Example: `playerApi.setAttributes({ myColor: '#202020', myFont: 'Courier' })`

### `setLearnerAttribute`

Persist a single attribute in the gadget's learner state.

Example: `playerApi.setLearnerAttribute('openedGadget', true)`

### `setLearnerAttributes`

Persist an object containing the gadget's current learner state. Only the changed attributes need to be specified (not the entire learner state).

Example: `playerApi.setLearnerAttributes({ lastOpened: 12, lastSelected: true })`

### `setPropertySheetAttributes`

Define the gadget's property sheet.

Usage: `playerApi.setPropertySheetAttributes(descriptionObject)`

The argument is a object describing the attributes appearing in the property sheet.

For each attribute, we describe the attribute's name, the attribute's data type, and options specific to that data type.
Example:

```
playerApi.setPropertySheetAttributes({
     numberOfWords:  { type: 'Range', min: 100, max: 500, step: 20 },
     chosenAuthor: { type: 'Select',
                      options: ['Shakespeare', 'Hegel', 'Dickens', 'Lao Tzu']
                   }
})
```

Presently the player supports the following data types in property sheets:

* `Text`, `Number`, `TextArea`, `Checkbox`, `Color`: these types need no options.

Example: `{ type: 'TextArea' }`

*   `Checkboxes`, `Radio`, `Select`: these types take an array of `options`, representing the possible selection items. The `Select` type is a drop-down listbox.

Example: `{ type: 'Radio', options : ['Green', 'Yellow', 'Red' ] }`

*      `Date`, a date picker

Example: `{ type: 'Date', yearStart: 1990, yearEnd : 2038 }`

*      `DateTime`, a date/time picker

Example: `{ type: 'Datetime', 'yearStart : 1990, yearEnd : 2038, minsInterval : 60 }`

*      `Range`, a slider with a given range and step

Example: `{ type: 'Range', min: 100, max: 200, step: 10 }`

*      `Tags`, a selection of user-supplied tags

Example of using `Tags`:

```
{ type : 'Tags',
  options: ['music', 'movies', 'study', 'family', 'pets'],
  lowercase: true,
  duplicates: false,
  minLength: 3,
  maxLength: 20,
  updateAutoComplete: true
}
```

### `error`

Tell the player to show a placeholder that indicates an error.

Example: `playerApi.error()`

### `track`

Track events generated by the gadget. These events can be, for example, learner's progress, or statistical information about the gadget's performance.

Example: `playerApi.track(name, data)`

The `name` specifies the kind of progress event. The `data` is an object describing that progress event.

### `assetUrl`

Obtain the URL for an asset held by the Versal platform.

Example: `playerApi.assetUrl(assetId)`

The argument is the asset's ID string.

### `requestAsset`

Ask the player to show a standard dialog for uploading an asset.

Usage: `playerApi.requestAsset({attribute: attrName, type: assetType}, function(assetData){...})`

The first parameter describes the desired type of the asset and the name of the gadget attribute in which the new asset's metadata will be stored after a successful upload.

Possible asset types are `image` and `video`.

The second parameter (the callback) is optional. The callback will be invoked after a successful upload.

Each newly uploaded asset is processed and stored on the Versal platform. The asset is described by the data structure of the form

```
{ id: 'xxxx',
   representations: [
      {
      id: 'yyyy',
      original: false,
      contentType: 'image/png',
      scale: '800x600'
      },
      {
      id: 'zzzz',
      original: true,
      contentType: 'image/png',
      scale: '1024x768'
      },
      ...
   ]
}
```

This data structure will be set as the value of the gadget's configuration attribute named `attrName` (which is given as a parameter in the `requestAsset` call). The gadget code should select a desired representation and use its ID in the `playerApi.assetUrl()` method in order to obtain the corresponding URL of the asset.

Since a successful upload will assign a new value for a gadget attribute, the gadget should expect an `attributesChanged` message after the user completes the upload. If the callback argument was given in the `requestAsset` call, the callback function will be also invoked with the new asset data structure as its argument.

## Messages from player to gadget

Subscribe to messages by using the `on` and `off` methods, for example:

`playerApi.on('message name', callback)`

`playerApi.off('message name', callback)`

Supported message names are `attributesChanged`, `learnerStateChanged`, and `editableChanged`.

### `attributesChanged`

This message indicates to the gadget that some attributes have changed their values. This message is also sent to the gadget at initialization time, that is, shortly after the gadget sends `startListening` to the player.

Example: `playerApi.on('attributesChanged', function(attrs){...})`

The callback receives an object containing the new attributes for the gadget. The gadget should update its visual state accordingly.

### `learnerStateChanged`

This message indicates to the gadget that some learner's state has changed. This message is also sent to the gadget at initialization time, that is, shortly after the gadget sends `startListening` to the player.

Example: `playerApi.on('learnerStateChanged', function(learnerState){...})`

The callback receives an object containing the new learner state for the gadget. The gadget should update its visual state accordingly.

### `editableChanged`

This message indicates to the gadget whether its configuration is currently being edited.

Example: `playerApi.on('editableChanged', function(attrs){...})`

The callback receives an object of the form `{editable: true/false}`. The value of `editable` describes the new editable state for the gadget. Accordingly, the gadget should switch its visual state to editing (the author's view) or to the learner's view.

## Change log
- **0.3.3** Adds `setHeightToBodyHeight` and `watchBodyHeight` methods
- **0.3.2** Removed old "challenges" methods
- **0.3.1** Minor fixes
- **0.3.0** Remove compilation
- **0.2.4** Remove setEditable event completely in favor for editableChanged event
