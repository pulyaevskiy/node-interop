// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
exports.createPromise = function (value) {
    var promise = new Promise((resolve, reject) => {
        setTimeout(() => {
            resolve(value);
        });
    });
    return promise;
};
exports.receivePromise = function (promise) {
    return promise.then((value) => {
        return value.repeat(3);
    }, (error) => {
        throw error.repeat(3);
    });
}
