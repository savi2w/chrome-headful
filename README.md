# Chrome Headful

Chrome headful in a lambda function runtime

## Usage

### Development

Try it local by running (in):

```bash
$ curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'
```

or just (out)

```bash
$ npm run build
$ npm run start
```

### Production

Just ship to ECR registry in order to invoke with your lambda function :)

## License

This project is distributed under the [MIT license](LICENSE)
