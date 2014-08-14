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

* `playerApi.setPropertySheetAttributes(attrs)`

Define the gadget's property sheet.

* `playerApi.setEmpty()`

Tell the player to show an "empty gadget" placeholder.

* `playerApi.error()`

Tell the player to show an "error in gadget" placeholder.

* `playerApi.track(name, dataDictionary)`

Track learner's progress. The `name` specifies the kind of progress event. The `dataDictionary` is a dictionary corresponding to that progress event.

* `playerApi.changeBlocking()`

Tell the player that the gadget no longer blocks the next lesson from being shown. (Useful for quiz-like gadgets at the end of a lesson.)

* `playerApi.assetUrl(assetId)`

Obtain the URL for an asset held by the Versal platform. The argument is the asset's ID string.

* `playerApi.requestAsset({attribute: attrName, type: assetType}, function(assetId){...})`

Tell the player to show the dialog for uploading an asset. The first parameter describes the desired type of the asset and the name of the gadget attribute in which the new asset ID will be stored after a successful upload. The second parameter (the callback) is optional. 

If the user successfully uploads an asset, a new asset ID is created and set as the value of the gadget's configuration attribute named `attrName`. Note that the URL corresponding to this asset ID must be obtained through the `playerApi.assetUrl()` method.

Since a successful upload initiates a new value for an attribute, the `attributesChanged` message will be sent to the gadget. If the callback argument was given in the `requestAsset` call, the callback function will be also invoked with the new asset ID.
