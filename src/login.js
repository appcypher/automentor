module.exports = {
  'Login': (client) => {
    const fs = require('fs');
    const util = require('util');

    client
      .url('https://www.codementor.io/login')
      // Login and submit manually
      .waitForElementVisible('.header-chat-summary', 240000) // 4 mins max
      .getCookies((cookies) => {
        // Save the cookies to a file.
        fs.writeFileSync('src/cookies.js', 'module.exports = ' + util.inspect(cookies) + ";", 'utf-8')
      });
  },
  after: (client) => {
    client.end();
  },
}
