let slow_pi = require('./../build/node/slow_pi.dart.js');
console.log("slowPi(100):", slow_pi.slowPi(100));
console.log("fastPi:", slow_pi.fastPi);
console.log("defaultAccuracy:", slow_pi.config.defaultAccuracy);
