module.exports = {
  // challenges
  setChallenges: function(challenges) {
    this.sendMessage('setChallenges', challenges);
  },

  scoreChallenges: function(responses) {
    this.sendMessage('scoreChallenges', responses);
  }
};
