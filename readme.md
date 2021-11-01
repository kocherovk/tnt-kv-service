# Simple tarantool based key value http service

To start the app:
```bash
docker-compose build
docker-compose up
```

then look for api endpoint   
`http://127.0.0.1:8000/kv/some-key`  
or swagger ui  
`http://127.0.0.1:8000/swagger-ui/`


### API reference
Look at `swagger/swagger.json`   
or check out swagger UI [here](http://ec2-13-53-199-37.eu-north-1.compute.amazonaws.com/swagger-ui/)

### Demo
endpoint   
http://ec2-13-53-199-37.eu-north-1.compute.amazonaws.com/kv/some-key


## How to test rate limiter
Run 
```tarantool test-rate-limiter.lua```
see `tnt/test-rate-limiter.lua`
