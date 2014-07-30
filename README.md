# Versal Player API [![Code Climate](https://codeclimate.com/github/Versal/player-api.png)](https://codeclimate.com/github/Versal/player-api)

The Versal Player API provides a convenience layer and stability buffer on top
of the [gadget api spec](https://github.com/Versal/gadget-api-spec). Please
refer to the gadget api spec for the full list of supported events and commands.

## Installation

Include as a Bower dependency:

    bower install --save Versal/player-api

With web components:

    <link rel="import" href="bower_components/player-api/index.html">

With vanilla HTML:

    <script src="bower_components/eventEmitter/EventEmitter.js"></script>
    <script src="bower_components/player-api/index.js"></script>

## Usage

    var player = new VersalPlayerAPI();
    player.on('attributesChanged', function(attrs){
      // do something
    });

    // send this command to receive initial events
    player.startListening();

## Rebuilding

    npm run-script build

## Change log
- v0.2.4. Remove setEditable event completely in favor for editableChanged event
