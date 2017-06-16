// Test for the `bang.dart` module.
// 1. Build the module first with `pub build bin`, this puts Js version in 
//    ../build/bin/bang.dart.js
// 2. Run this with 
//    node bin/bang_test.js
// 3. Check the result
const bang = require('../build/bin/bang.dart.js');
console.log(bang.bang('Hi'));
