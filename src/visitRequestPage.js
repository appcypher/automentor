const cookies = require('./cookies');

module.exports = {
  'Visit Request Page': (client) => {
    // Open codemntor site
    client
      .url('https://www.codementor.io')
      .waitForElementVisible('body', 4000) // 4 secs

    // Save the cookies
    for (let i = 0; i < cookies.value.length; i += 1) {
      const cookie = cookies.value[i];
      client
        .setCookie(cookie);
    }

    // Open request page
    client
      .pause(3000)
      .url('https://www.codementor.io/m/dashboard/open-requests')
      .waitForElementVisible('body', 4000);
  }
};
