sinon = require 'sinon'
assert = require 'assert'
PlayerAPI = require('../index')

describe 'supported commands', ->
  papi = null
  postMessage = null

  beforeEach ->
    postMessage = sinon.spy()
    papi = new PlayerAPI(eventSource: { postMessage })

  it 'start', ->
    papi.start()

    assert.deepEqual postMessage.firstCall.args, [{ event: 'start' }, '*']

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

  it 'setLearnerAttribute', ->
    papi.setLearnerAttribute 'foo', 'bar'

    expectedMessage = { event: 'setLearnerState', data: { foo: 'bar'} }
    assert postMessage.calledWith expectedMessage, '*'

  it 'setLearnerAttributes', ->
    papi.setLearnerAttributes { foo: 'bar'}

    expectedMessage = { event: 'setLearnerState', data: { foo: 'bar'} }
    assert postMessage.calledWith expectedMessage, '*'

  it 'setLearnerState', ->
    papi.setLearnerState { foo: 'bar'}

    expectedMessage = { event: 'setLearnerState', data: { foo: 'bar'} }
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
    papi.track 'done', { foo: 'bar'}

    expectedMessage = { event: 'track', data: { event: 'done', data: { foo: 'bar' } } }
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
    papi.requestAsset { type: 'image' }

    expectedMessage = {
      event: 'requestAsset',
      data: { type: 'image', attribute: '__asset__'}
    }
    assert postMessage.calledWith expectedMessage, '*'

  describe 'compatibility', ->

    it 'setEditable should trigger editableChanged', ->
      editableChanged = sinon.spy()
      papi.on('editableChanged', editableChanged)
      papi.handleMessage data: { event: 'setEditable', data: { editable: true } }
      assert editableChanged.calledWith true

  describe 'futures', ->

    it 'requestAsset emits assetSelected', ->
      papi.requestAsset { type: 'image', attribute: 'foo' }
      assetSelected = sinon.spy()
      papi.on 'assetSelected', assetSelected
      papi.handleMessage data: { event: 'attributesChanged', data: { foo: { id: 1 } } }
      assert assetSelected.calledWith { name: 'foo', asset: { id: 1 }}

    it 'requestAsset triggers a callback', ->
      assetSelected = sinon.spy()
      papi.requestAsset { type: 'image', attribute: 'foo' }, assetSelected
      papi.handleMessage data: { event: 'attributesChanged', data: { foo: { id: 1 } } }
      assert assetSelected.calledWith { id: 1 }
