# Module NETWORK

## What it does

This module generates the network necessaries to deploy web services, this module did not create de aws-ec2 instance.
This module creates:
- Vpc
- Subnet private
- Subnet public
- Security group and open the https, http ports and ssh port
- Security group and open the port for the data base
- Gateway
- Route table
- Network interface

## How to use this module

In the root module, you have to creat a module block :

``` 
module "module-network-linux-web" {
	 source = "./modules/module-network-linux-web"
	 
}
```

If you want, like an argument in the module block, you could set values for the input variables defined in this module (e.g. subnet_prefix), if you don't want to set it, exist default values for all the input except the region one that is mandatory.

### E.g.

```
module "module-network-linux-web" {
	source = "./module-network-linux-web"
     region = "us-east-1"
}
```