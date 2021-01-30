LUA_OBJECTS=target/init.lua target/restart.lua target/configuration.lua
NODEMCU_TOOL=./node_modules/nodemcu-tool/bin/nodemcu-tool.js
FENNEL=fennel

default: $(LUA_OBJECTS)

target/configuration.lua: resources/configuration.fnl
	mkdir -p target
	$(FENNEL) --compile $< > $@

target/%.lua: src/%.fnl
	mkdir -p target
	$(FENNEL) --compile $< > $@

upload: $(LUA_OBJECTS)
	$(NODEMCU_TOOL) upload $^

restart:
	$(NODEMCU_TOOL) run restart.lua

repl:
	$(NODEMCU_TOOL) terminal

clean:
	rm $(LUA_OBJECTS)

.PHONY: upload terminal clean default
