exports.asyncFoo = function () {
    var prom = new Promise((resolve, reject) => {
        console.log('Created Promise');
        setTimeout(() => {
            console.log('Resolving promise');
            resolve('Promise resolved in 150 ms');
        }, 150);
    });
    console.log(prom);
    return prom;
};
exports.receiveFoo = function (promise) {
    console.log(promise);
    return promise.then((value) => {
        console.log('Received value from Future on JS side: ' + value);
        return value;
    });
}
