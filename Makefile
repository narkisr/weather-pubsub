LUA_OBJECTS=resources/configuration.lua target/init.lua target/restart.lua 
NODEMCU_TOOL=./node_modules/nodemcu-tool/bin/nodemcu-tool.js
FENNEL=fennel

default: $(LUA_OBJECTS)

resources/configuration.lua: resources/configuration.fnl
	mkdir -p target
	$(FENNEL) --compile $< > $@

target/%.lua: src/%.fnl
	mkdir -p target
	$(FENNEL) --compile $< > $@

upload: $(LUA_OBJECTS)
	head -n 1 'resources/configuration.lua' > target/concat.lua
	cat target/init.lua >> target/concat.lua
	mv target/concat.lua target/init.lua
	$(NODEMCU_TOOL) upload target/init.lua target/restart.lua

restart:
	$(NODEMCU_TOOL) run restart.lua

repl:
	$(NODEMCU_TOOL) terminal

clean:
	rm $(LUA_OBJECTS)

.PHONY: upload terminal clean default
