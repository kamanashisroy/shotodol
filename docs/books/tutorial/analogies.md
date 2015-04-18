#### Shotodol analogy to super-shop

Suppose a person wants to buy a tooth-paste and a brush. He can do it in the following ways,

- He can go to a dealer of tooth-paste and buy one. And then he can go to a dealer of brush and buy one. In this case he needs to know about the dealers and their addresses. And he needs to go to two places to get them. The service here is oriented to the provider than to the user.
- Again he can go to a super-shop to buy both tooth-paste and brush. In this case he does not know the dealer. The dealer does not deal numerous clients too. Thus the system is "one-stop". The dealer only knows the super-shop. And the user only knows the super-shop. The super-shop makes things simpler.

In shotodol the super-shop and the products can be found in the `PluginManager` as `extensions`. The `PluginManager` provides the "one-stop" solutions to the available products(interfaces) and services(aka hooks). The `extension-point` is the shelf location of the product in the super-shop.

The user can use the super-shop aka `PluginManager` to get both the commodity.

```Vala
	// user asks for tooth-paste
	ToothPaste?p = null;
	extring toothPastePoint = extring.set_static_string("tooth-paste");
	PluginManager.acceptVisitor(&toothPastePoint, (x) => {
		p = (ToothPaste)x.getInterface(null);
	});

	// user asks for brush
	ToothBrush?b = null;
	extring toothBrushPoint = extring.set_static_string("tooth-brush");
	PluginManager.acceptVisitor(&toothBrushPoint, (x) => {
		b = (ToothBrush)x.getInterface(null);
	});
```

From the dealer's point of view, the `PluginManager` is the place to advertise their products.


```Vala
	// dealer provides tooth-paste
	ToothPaste?p = null;
	extring toothPastePoint = extring.set_static_string("tooth-paste");
	PluginManager.register(&toothPastePoint, new AnyInterfaceExtension(new ToothPaste(), this));

	// user asks for brush
	ToothBrush?b = null;
	extring toothBrushPoint = extring.set_static_string("tooth-brush");
	PluginManager.register(&toothBrushPoint, new AnyInterfaceExtension(new ToothBrush(), this));
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

Again, the decoupling provided by `PluginManager` needs an action to notify the users about their product changes. It is like sending an SMS to the user about the new products or updates. This is equivalent to the `rehash` command. To get the notification from the super-shop the user needs to create an account in that super-shop and provide his mobile number. In the same way, to get the notification from the `PluginManager` the user needs to register to the rehash hook.

```Vala
	// user registers to rehash hook
	extring entry = extring.set_static_string("rehash");
	PluginManager.register(&entry, new HookExtension(rehashHook, this));

	// ....
	// ....
	
	int rehashHook(extring*inmsg, extring*outmsg) {
		// user asks for tooth-paste
		ToothPaste?p = null;
		extring toothPastePoint = extring.set_static_string("tooth-paste");
		PluginManager.acceptVisitor(&toothPastePoint, (x) => {
			p = (ToothPaste)x.getInterface(null);
		});

		// user asks for brush
		ToothBrush?b = null;
		extring toothBrushPoint = extring.set_static_string("tooth-brush");
		PluginManager.acceptVisitor(&toothBrushPoint, (x) => {
			b = (ToothBrush)x.getInterface(null);
		});
		return 0;
	}
```

The architecture above hides the dealer from the user. It is like hiding the underlying API of the provider of an interface from the user. It makes things simpler.

#### Shotodol analogy to functional mathematics

In functional mathematics a function `f(x,y,z)` is defined to be a relation between the _domains_ of _x_,_y_ and _z_ and the range of `f(x,y,z)`. Here shotodol can be defined like the following,

> shotodol = f(x,y,z, ...) where x,y and z are the extension points.

These extension points can be defined by plugins.


