# Versal Player API

Versal player API provides convenience layer and stability buffer on top of
[gadget api spec](https://github.com/Versal/gadget-api-spec). Please, refer to
gadget api spec for the full list of supported events and commands.

## Known events

Events, coming from Versal player, are triggered on instance of player API. You
can subscribe to them by using `.on` or `.addEventListener`:

    var playerAPI = new VersalPlayerAPI();
		playerAPI.on('attributesChanged', gadget.doSomething);
		playerAPI.on('attached', gadget.render);

## Supported commands

Commands are exposed as methods with the corresponding names. You can call commands
right on your instance of player API:

    playerAPI.requestAsset({ type: 'image', attribute: 'src' });
		playerAPI.setHeight(300);

For a full list of supported events and commands

## Contributing

To contribute, clone this repo and npm install. Write some tests, run them with
`npm test`, then make them pass.
