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
        console.log(value);
        return value.repeat(3);
    });
}
