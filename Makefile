LUA_OBJECTS=target/init.lua
NODEMCU_TOOL=./node_modules/nodemcu-tool/bin/nodemcu-tool.js
FENNEL=fennel

default: $(LUA_OBJECTS)

target/%.lua: src/%.fnl
	mkdir -p target
	$(FENNEL) --compile $< > $@

upload: $(LUA_OBJECTS)
	$(NODEMCU_TOOL) upload $^

terminal:
	$(NODEMCU_TOOL) terminal

clean:
	rm $(LUA_OBJECTS)

.PHONY: upload terminal clean default
