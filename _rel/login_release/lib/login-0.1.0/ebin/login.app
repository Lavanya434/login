{application, 'login', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['login_app','login_sup','my_handler']},
	{registered, [login_sup]},
	{applications, [kernel,stdlib,epgsql,cowboy,lager]},
	{mod, {login_app, []}},
	{env, []}
]}.