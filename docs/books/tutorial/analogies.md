#### Shotodol analogy to super-shop

Suppose a person wants to buy a paper and a pencil. He can do it in the following ways,

- He can go to a provider of paper and buy one. And then he can go to a provider of pencil and buy one. In this case he needs to know about the providers and their addresses. And he needs to go to two places to get them. The service here is oriented to the provider than to the user.
- Again he can go to a super-shop to buy both paper and pencil. In this case he does not know the provider. The provider does not deal numerous clients too. Thus the system is "one-stop". The provider only knows the super-shop. And the user only knows the super-shop. The super-shop makes things simpler.

In shotodol the super-shop and the products can be found in the `PluginManager` as `extensions`. The `PluginManager` provides the "one-stop" solutions to the available products(interfaces) and services(aka hooks). The `extension-point` is the shelf location of the product in the super-shop.

The user can use the super-shop aka `PluginManager` to get both the commodity.

```Vala
	// user asks for paper
	Paper?p = null;
	extring paperPoint = extring.set_static_string("paper");
	PluginManager.acceptVisitor(&paperPoint, (x) => {
		p = (Paper)x.getInterface(null);
	});

	// user asks for pencil
	Pencil?b = null;
	extring pencilPoint = extring.set_static_string("pencil");
	PluginManager.acceptVisitor(&pencilPoint, (x) => {
		b = (Pencil)x.getInterface(null);
	});
```

From the provider's point of view, the `PluginManager` is the place to advertise their products.


```Vala
	// provider provides paper
	Paper?p = null;
	extring paperPoint = extring.set_static_string("paper");
	PluginManager.register(&paperPoint, new AnyInterfaceExtension(new Paper(), this));

	// user asks for pencil
	Pencil?b = null;
	extring pencilPoint = extring.set_static_string("pencil");
	PluginManager.register(&pencilPoint, new AnyInterfaceExtension(new Pencil(), this));
```

There can be another scenario where the user wants to pay gas-bill in super-shop. He may go to super-shop and fill a form of gas-bill and pay the money. This is different from the above example in a way that gas-bill is not product but a service. The service has analogy to a hook. Hook is kind of callback. In the following example, an user pays the gas-bill using a hook.

```Vala
	// user pays the gas-bill 
	extring entry = extring.set_static_string("pay/bill/gas");
	extring id = extring.set_static_string("8800");
	extring receipt = extring();
	PluginManager.swarm(&entry, &id, &receipt);

	// see if the gas-bill is paid successfully
	extring ok = extring.set_static_string("ok");
	if(receipt.equals(&ok))
		print("Successful\n");
```

On the other hand, the service provider can register as gas-bill handler like the following way.

```Vala
	// gas-office
	extring entry = extring.set_static_string("pay/bill/gas");
	PluginManager.register(&entry, new HookExtension(payBill, this));

	// ...
	// ...

	int payBill(extring*id, extring*response) {
		// accept the payment ..
		response.rebuild_and_set_static_string("ok");
		return 0;
	}
```

A service is different from product in a way that the service does not return an object, but the product itself is an object. In the above example the pencil and paste are the objects. And the gas-bill is not an object. Same is true for `hook` and `interface` extension types. `Hook` does not return object while the `Interface` is itself an object.

Again, the decoupling provided by `PluginManager` needs an action to notify the users about their product changes. It is like sending an SMS to the user about the new products or updates. This is equivalent to the `rehash` command. To get the notification from the super-shop the user needs to create an account in that super-shop and provide his mobile number. In the same way, to get the notification from the `PluginManager` the user needs to register to the rehash hook.

```Vala
	// user registers to rehash hook
	extring entry = extring.set_static_string("rehash");
	PluginManager.register(&entry, new HookExtension(rehashHook, this));

	// ....
	// ....
	
	int rehashHook(extring*inmsg, extring*outmsg) {
		// user asks for paper
		Paper?p = null;
		extring paperPoint = extring.set_static_string("paper");
		PluginManager.acceptVisitor(&paperPoint, (x) => {
			p = (Paper)x.getInterface(null);
		});

		// user asks for pencil
		Pencil?b = null;
		extring pencilPoint = extring.set_static_string("pencil");
		PluginManager.acceptVisitor(&pencilPoint, (x) => {
			b = (Pencil)x.getInterface(null);
		});
		return 0;
	}
```

The architecture above hides the provider from the user. It is like hiding the underlying API of the provider of an interface from the user. It makes things simpler.

| metaphor | shotodol |
|-----|-----|
| Super Shop | PluginManager |
| Pencil | Interface Extension |
| Paper | Interface Extension |
| Pencil box/shelf | Extension space |
| pay bill service | Hook extension |
| kids of a school(who uses the pencil/paper) | module |
| Provider group(who provides pencil/paper) | module |

#### Shotodol analogy to functional mathematics

In functional mathematics a function `f(x,y,z)` is defined to be a relation between the _domains_ of _x_,_y_ and _z_ and the range of `f(x,y,z)`. Here shotodol can be defined like the following,

> shotodol = f(x,y,z, ...) where x,y and z are the extension points.

These extension points can be defined by plugins.


