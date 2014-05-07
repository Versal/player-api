# Versal Player API

Versal player API provides convenience layer and stability buffer on top of
[gadget api spec](https://github.com/Versal/gadget-api-spec). Please, refer to
gadget api spec for the full list of supported events and commands.

## Installation

Install it with bower `bower install versal-player-api`. Include it on the page:

    <script src="bower_components/versal-player-api/dist/api.js"></script>

## Usage

    var player = new VersalPlayerAPI();
    player.on('attributesChanged', function(attrs){
      // do something
    });

    // send this command to receive initial events
    player.startListening();
