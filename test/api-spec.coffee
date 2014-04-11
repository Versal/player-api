sinon = require 'sinon'
assert = require 'assert'
PlayerAPI = require('../index')

describe 'supported commands', ->
  papi = null
  postMessage = null

  beforeEach ->
    postMessage = sinon.spy()
    papi = new PlayerAPI(eventSource: { postMessage })

  it 'connect', ->
    papi.connect()

    assert.deepEqual postMessage.firstCall.args, [{ event: 'connect' }, '*']
    assert.deepEqual postMessage.secondCall.args, [{ event: 'getPath', data: '%id' }, '*']

  it 'setHeight', ->
    papi.setHeight(73)

    expectedMessage = { event: 'setHeight', data: { pixels: 73 } }
    assert postMessage.calledWith expectedMessage, '*'

  it 'setAttribute', ->
    papi.setAttribute 'foo', 'bar'

    expectedMessage = { event: 'setAttributes', data: { foo: 'bar'} }
    assert postMessage.calledWith expectedMessage, '*'

  it 'setAttributes', ->
    papi.setAttributes { foo: 'bar'}

    expectedMessage = { event: 'setAttributes', data: { foo: 'bar'} }
    assert postMessage.calledWith expectedMessage, '*'

  it 'setPropertySheetAttributes', ->
    papi.setPropertySheetAttributes { foo: 'bar' }

    expectedMessage =
      event: 'setPropertySheetAttributes',
      data: { foo: 'bar' }
    assert postMessage.calledWith expectedMessage, '*'

  it 'setEmpty', ->
    papi.setEmpty true

    expectedMessage = { event: 'setEmpty', data: { empty: true } }
    assert postMessage.calledWith expectedMessage, '*'

  it 'track', ->
    papi.track { foo: 'bar'}

    expectedMessage = { event: 'track', data: { foo: 'bar'} }
    assert postMessage.calledWith expectedMessage, '*'

  it 'error', ->
    papi.error { foo: 'bar'}

    expectedMessage = { event: 'error', data: { foo: 'bar'} }
    assert postMessage.calledWith expectedMessage, '*'

  it 'changeBlocking', ->
    papi.changeBlocking()

    expectedMessage = { event: 'changeBlocking' }
    assert postMessage.calledWith expectedMessage, '*'

  it 'requestAsset', ->
    papi.requestAsset { foo: 'bar'}

    expectedMessage = { event: 'requestAsset', data: { foo: 'bar'} }
    assert postMessage.calledWith expectedMessage, '*'

  describe 'compatibility', ->

    it 'setEditable should trigger editableChanged', ->
      editableChanged = sinon.spy()
      papi.on('editableChanged', editableChanged)
      papi.handleMessage data: { event: 'setEditable', data: true }
      assert editableChanged.called

    it 'setPath should update assetUrlTemplate', ->
      papi.handleMessage data: { event: 'setPath', data: { url: 'foo/bar' } }
      assert.equal papi.assetUrlTemplate, 'foo/bar'
