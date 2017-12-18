function cleanNixStore {
	echo "### Purge nix store"
	# remove all generations but the current
	nix-env --delete-generations `nix-env --list-generations | grep -v "(current)$" | awk '{ print $1 }'`

	# list available gc roots
	nix-store --gc --print-roots

	# remove gc roots outside /nix/
	nix-store --gc --print-roots | grep -v '^/nix/' | awk '{print $1}' | xargs rm -f

	# purge Nix store
	nix-store --gc
}
