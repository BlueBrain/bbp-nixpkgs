let 
	## we create this path on our KNL node to detect KNL platforms
	knl_platform_path = "/etc/nix/platform/knl";
in
{

} 
// 
(if (builtins.pathExists knl_platform_path) then 
	{  }
else 
	{ }
)


