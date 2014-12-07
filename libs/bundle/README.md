
Bag
=======

Bags are memory chunks. They are mainly used for [distributed objects](http://en.wikipedia.org/wiki/Distributed_object) while message passing.

####Setting up a *Bag*

Bundler
=======

Bundler helps to serialize an object. User may use the Bag to allocate memory for serialization data.

####Setting up a *Bundler*


####Serializing data

Bundler can serialize integer, xtring and binary data. The table below relates the types and serialization functions.

| Type | method | note |
|:---- |:-------|:-----|
| Unsigned Integer(32 bit) | `writeInt(aroop_uword8 key, aroop_uword32 val)` ||
| Embedded xtring | `writeExtring(aroop_uword8 key, extring*val)` | It adds a terminating zero if needed |
| Binary data | `writeBin(aroop_uword8 key, mem val, int len)` ||
| Untouched header space for tagging | `setBagTagLength(uint bagTagLength)` | The space can only be added before serializing any other elaments.|



Examples
=========

#### Setup

FILL ME

#### Serializing

The following code tries to parse out the first line of HTTP request. Suppose the header is 'GET /index.html HTTP/1.1'. The code following parses it into REQUEST\_METHOD, REQUEST\_URL and REQUEST\_VERSION. It tries to keep them in a bag for future use. 

```
extring strtoken = extring();
LineAlign.next_token(cmd, &strtoken);
bndlr.writeEXtring(httpRequest.REQUEST_METHOD, &strtoken);
LineAlign.next_token(cmd, &strtoken);
bndlr.writeEXtring(httpRequest.REQUEST_URL, &strtoken);
bndlr.writeEXtring(httpRequest.REQUEST_VERSION, cmd);
```
The bndlr.writeExtring is used to put the value in the bag. 

#### Deserialize

FILL ME


See also
===========
- [ZeroMQ](http://aosabook.org/en/zeromq.html), is a message passing library that uses less memory copy and less system call. It uses batching and memory pooling.


