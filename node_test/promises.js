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
