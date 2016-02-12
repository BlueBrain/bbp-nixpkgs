  
  
echo "hello dude! "

mkdir -p $out/nix-support;
echo "Configure environment for BBP viz team cmake externals" > $out/README;
echo "export GIT_SSL_CAINFO=\"${CACERT_DIR}/etc/ssl/certs/ca-bundle.crt\"" >>  $out/nix-support/setup-hook; 

###
###  ugly hack
###
###  viz team softwares use git external / subtree 
###  and consequently require internet connexion even during build phase
###
###  1- nix do not export system env var to builPhase for reproduicibility reasons
###
###  2- BBP VM system do not have internet access without proxy
###  proxy env var
###
###  Test network and force hardcoded proxy if not available
###
echo "** test necessity of proxy ***"
curl http://www.google.com &> /dev/null 
if [[ "$?" != "0" ]]; then
	echo " - ** failure need proxy"
	echo "export https_proxy=http://bbpfe08.epfl.ch:80/" >> $out/nix-support/setup-hook; 
	echo "export http_proxy=http://bbpfe08.epfl.ch:80/" >> $out/nix-support/setup-hook;
	echo "export HTTP_PROXY=http://bbpfe08.epfl.ch:80/" >> $out/nix-support/setup-hook; 
	echo "export ftp_proxy=http://bbpfe08.epfl.ch:80/" >> $out/nix-support/setup-hook;	
	
else
	echo " - ** no proxy needed"
fi
