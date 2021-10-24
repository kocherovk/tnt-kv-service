FROM tarantool/tarantool:2.6.0

COPY *.lua /opt/tarantool/
EXPOSE 3301
WORKDIR /opt/tarantool

CMD ["tarantool", "service.lua"]