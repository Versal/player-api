var EventEmitter = require('events').EventEmitter;
var coreApi = require('./api/core');

//  This Player thing should be used inside gadget
//  as a convenience API over postMessage.
//
//  Supported events:
//  https://github.com/Versal/gadget-api-spec
var PlayerAPI = function(options){
  EventEmitter.call(this);

  this.eventSource = (options && options.eventSource) || window.parent;

  // TODO: implement connect event and read value from env variables
  this.assetUrlTemplate = options.assetUrlTemplate ||
                          'https://static.versal.com/restapi/assets/';

  // TODO: don't communicate assets in setAttributes event in the player
  this._assetAttributes = {};

  if(typeof window != 'undefined'){
    window.addEventListener('message', this.handleMessage.bind(this));
  }
};

PlayerAPI.prototype = Object.create(EventEmitter.prototype);

PlayerAPI.prototype.on = PlayerAPI.prototype.addListener;
PlayerAPI.prototype.off = PlayerAPI.prototype.removeListener;
PlayerAPI.prototype.addEventListener = PlayerAPI.prototype.addListener;
PlayerAPI.prototype.removeEventListener = PlayerAPI.prototype.removeListener;

PlayerAPI.prototype.sendMessage = function(name, data) {
  var message = { event: name };
  if(data) { message.data = data; }

  this.eventSource.postMessage(message, '*');
};

PlayerAPI.prototype.handleMessage = function(evt) {
  var message = evt.data;

  if(message && message.event) {
    this.emit('message', message);

    // Inspect attributes for asset-related fields and extract asset json
    if(message.event == 'attributesChanged') {
      this._triggerAssetCallbacks(message.data);
    }

    this.emit(message.event, message.data);

    // Future-proofing editableChanged event
    if(message.event == 'setEditable') {
      this.emit('editableChanged', message.data.editable);
    }

    // Store asset URL template for further usage
    if(message.event == 'setPath') {
      this.assetUrlTemplate = message.data.url;
    }
  }
};

PlayerAPI.prototype.assetUrl = function(id){
  return this.assetUrlTemplate + id;
};

// TODO: move implementation to the player
PlayerAPI.prototype._triggerAssetCallbacks = function(attrs){
  Object.keys(this._assetAttributes).forEach(function(name){
    if(attrs[name]) {
      var asset = attrs[name];
      this.emit('assetSelected', { name: name, asset: asset });
      attrs[name] = null;
    }
  }.bind(this));
};

PlayerAPI.use = function(dictionary){
  Object.keys(dictionary).forEach(function(key){
    PlayerAPI.prototype[key] = dictionary[key];
  });
};

PlayerAPI.use(coreApi);

module.exports = PlayerAPI;
