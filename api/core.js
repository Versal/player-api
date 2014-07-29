module.exports = {

  startListening: function(){
    this.sendMessage('startListening');
  },

  setHeight: function(px){
    this.sendMessage('setHeight', { pixels: px });
  },

  setAttribute: function(name, value){
    if (name === 'vs-challenges') return;

    var attr = {};
    attr[name] = value;
    this.setAttributes(attr);
  },

  setAttributes: function(attrs) {
    // Remove any interference between challenges-js-api
    // and player-api
    //  - Only allow challenges to set 'vs-challenges'
    delete attrs['vs-challenges'];

    this.sendMessage('setAttributes', attrs);
  },

  setLearnerAttribute: function(name, value){
    if (name === 'vs-challenges') return;

    var attr = {};
    attr[name] = value;
    this.setLearnerState(attr);
  },

  setLearnerAttributes: function(attrs) {
    this.sendMessage('setLearnerState', attrs);
  },

  setLearnerState: function(attrs) {
    // Remove any interference between challenges-js-api
    // and player-api
    //  - Only allow challenges to set 'vs-scores'
    delete attrs['vs-scores'];

    this.sendMessage('setLearnerState', attrs);
  },

  setPropertySheetAttributes: function(attrs){
    this.sendMessage('setPropertySheetAttributes', attrs);
  },

  setEmpty: function(empty){
    this.sendMessage('setEmpty', { empty: empty });
  },

  track: function(name, _data){
    var data = { '@type': name };
    Object.keys(_data).forEach(function(key){
      data[key] = _data[key];
    });
    this.sendMessage('track', data);
  },

  error: function(data){
    this.sendMessage('error', data);
  },

  // controversial
  changeBlocking: function(){
    this.sendMessage('changeBlocking');
  },

  requestAsset: function(data, callback){
    if(!data.attribute) {
      data.attribute = '__asset__';
    }
    // TODO: remove this after assets are communicated from the player
    // in a dedicated event
    this._assetAttributes[data.attribute] = true;

    if(callback) {
      this._assetCallbacks[data.attribute] = callback;
    }
    this.sendMessage('requestAsset', data);
  },

  assetUrl: function(id){
    return this.assetUrlTemplate.replace(/<%= id %>/, id);
  }
};
