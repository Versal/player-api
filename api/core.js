module.exports = {

	connect: function(){
		this.sendMessage('connect');
		this.sendMessage('getPath', '%id');
	},

	setHeight: function(px){
		this.sendMessage('setHeight', { pixels: px });
	},

	setAttribute: function(name, value){
		var attr = {};
		attr[name] = value;
		this.setAttributes(attr);
	},

	setAttributes: function(attrs) {
		this.sendMessage('setAttributes', attrs);
	},

	setLearnerAttribute: function(name, value){
		var attr = {};
		attr[name] = value;
		this.setLearnerState(attr);
	},

	setLearnerAttributes: function(attrs) {
		this.sendMessage('setLearnerState', attrs);
	},

	setLearnerState: function(attrs) {
		this.sendMessage('setLearnerState', attrs);
	},

	setPropertySheetAttributes: function(attrs){
		this.sendMessage('setPropertySheetAttributes', attrs);
	},

	setEmpty: function(empty){
		this.sendMessage('setEmpty', { empty: empty });
	},

	track: function(data){
		this.sendMessage('track', data);
	},

	error: function(data){
		this.sendMessage('error', data);
	},

	// controversial
	changeBlocking: function(){
		this.sendMessage('changeBlocking');
	},

	requestAsset: function(data){
		if(!data.attribute) {
			data.attribute = '__asset__';
		}
		// TODO: remove this after assets are communicated from the player
		// in a dedicated event
		this._assetAttributes[data.attribute] = true;
		this.sendMessage('requestAsset', data);
	}
};
