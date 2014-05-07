sinon = require 'sinon'
assert = require 'assert'
PlayerAPI = require('../index')

describe 'supported commands', ->
  player = null
  postMessage = null

  beforeEach ->
    postMessage = sinon.spy()
    player = new PlayerAPI(eventSource: { postMessage })

  it 'setChallenges', ->
    player.setChallenges [
      {
        prompt: 'Hello'
        answer: 'Answer'
        scoring: 'strict'
      }
    ]

    expectedMessage =
      event: 'setChallenges'
      data: [{
        prompt: 'Hello'
        answer: 'Answer'
        scoring: 'strict'
      }]
    assert postMessage.calledWith expectedMessage, '*'

  it 'scoreChallenges', ->
    player.scoreChallenges [
      'one'
      'two'
      'three'
    ]

    expectedMessage =
      event: 'scoreChallenges'
      data: [
        'one'
        'two'
        'three'
      ]
    assert postMessage.calledWith
