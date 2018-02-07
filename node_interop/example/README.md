## Building examples

From the root of this repository:

```bash
pub run build_runner build --output=build/
```

## Running examples

Look for `build/example/{example_name}.dart.js` file and run it with node:

```bash
node build/example/{example_name}.dart.js
```