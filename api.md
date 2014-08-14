# API reference

## Creating the player API object

The player API object is created by

     var playerApi = new VersalPlayerAPI();

## Messages from player to gadget

Subscribe to messages by using the `on` and `off` methods:

* `playerApi.on('message name', callback)`

* `playerApi.off('message name', callback)`

Supported message names:

      attributesChanged
      learnerStateChanged
      editableChanged

* `playerApi.on('attributesChanged', function(attrs){...})`

The callback receives the new dictionary of attributes for the gadget. The gadget should update the configuration visually.

* `playerApi.on('learnerStateChanged', function(learnerState){...})`

The callback receives the new dictionary of learner state for the gadget. The gadget should update the learner state visually.

* `playerApi.on('editableChanged', function(attrs){...})`

The callback receives a dictionary of the form `{editable: true/false}`. This value describes the new editable state for the gadget. Accordingly, the gadget should switch to editing or back to learner's view.

## Messages from gadget to player

All supported messages from gadget to player are exposed as methods on the player API object.

* `playerApi.startListening()`

Indicates that the gadget has subscribed to the necessary messages and is ready to start receiving them. This would be typically the first message sent by the gadget to the player.

* `playerApi.setHeight(heightPx)`

Assign height (in pixels) to the gadget's container.

* `playerApi.setHeightToBodyHeight()`

Automatically assign height to the gadget's container according to the current height of the gadget's `body` element.

* `playerApi.watchBodyHeight({interval: NNN})`

Create a watching timer that will refresh the gadget container's height according to the current height of the gadget's `body` element. The value of the interval (default is 32) is given in ms.

* `playerApi.unwatchBodyHeight()`

Stop dynamically adjusting the gadget container's height.

* `playerApi.setAttribute(name, value)`

Persist a single attribute in the gadget configuration.

* `playerApi.setAttributes(attrs)`

Persist a dictionary of attributes in the gadget configuration.

* `playerApi.setLearnerAttribute(name, value)`

Persist a single attribute in the gadget's learner state.

* `playerApi.setLearnerAttributes(attrs)` or also `playerApi.setLearnerState(attrs)`

Persist a dictionary of attributes in the gadget's learner state.

* `playerApi.setPropertySheetAttributes(propertySheetDict)`

Define the gadget's property sheet. The argument is a dictionary describing the attributes appearing in the property sheet.

Presently the player supports the following data types in property sheets:

*	`Text`, `Number`, `TextArea`, `Checkbox`, `Color`: these types need no options.

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

Example:

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

Here is a small example of defining a property sheet:

```
playerApi.setPropertySheetAttributes({
     numberOfWords:  { type: 'Range', min: 100, max: 500, step: 20 },
     chosenAuthor: { type: 'Select',
                      options: ['Shakespeare', 'Hegel', 'Dickens', 'Lao Tzu']
                   }
})
```


* `playerApi.setEmpty()`

Tell the player to show an "empty gadget" placeholder.

* `playerApi.error()`

Tell the player to show an "error in gadget" placeholder.

* `playerApi.track(name, dataDictionary)`

Track learner's progress. The `name` specifies the kind of progress event. The `dataDictionary` is a dictionary corresponding to that progress event.

* `playerApi.changeBlocking()`

Tell the player that the gadget no longer blocks the next lesson from being shown. (Useful for quiz-like gadgets at the end of a lesson.)

* `playerApi.assetUrl(assetId)`

Obtain the URL for an asset held by the Versal platform. The argument is the asset's data structure.

* `playerApi.requestAsset({attribute: attrName, type: assetType}, function(assetData){...})`

Tell the player to show the dialog for uploading an asset. 

The first parameter describes the desired type of the asset and the name of the gadget attribute in which the new asset metadata will be stored after a successful upload. Possible asset types are `image` and `video`.

The second parameter (the callback) is optional. 

If the user successfully uploads an asset, a new asset is created and stored on the Versal platform. The asset is described by the data structure of the form

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
      id: 'zzz',
      original: true,
      contentType: 'image/png',
      scale: '1024x768'
      },
      ...
   ]
}
```

This data structure is set as the value of the gadget's configuration attribute named `attrName`. The gadget code can use any of the asset IDs in the `playerApi.assetUrl()` method in order to obtain the corresponding URLs.

Since a successful upload initiates a new value for an attribute, the `attributesChanged` message will be sent to the gadget. If the callback argument was given in the `requestAsset` call, the callback function will be also invoked with the new asset data structure as its argument.
