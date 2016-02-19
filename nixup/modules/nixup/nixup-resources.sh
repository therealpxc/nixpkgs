#! @shell@

rmEmptyDirectories () {
	BASE=$1
	DIR=$2
	if [ "$DIR" != "." ] && [ -d "$BASE/$DIR" ]; then
		if [ ! "$(@coreutils@/bin/ls -A "$BASE/$DIR")" ]; then
			@coreutils@/bin/rm -rf "${BASE:?}/$DIR"
			rmEmptyDirectories "$BASE" "$(@coreutils@/bin/dirname "$DIR")"
		fi
	fi
}


unlink () {
	FROM=$1
	LINK=$2
	if [ -L "$FROM/$LINK" ]; then
		rm -r "${FROM:?}/$LINK"
	fi
	rmEmptyDirectories "$FROM" "$(@coreutils@/bin/dirname "$LINK")"
}


link (){
	TO=$1
	FROM=$2
	LINK=$3

	target="$TO/$LINK"
	mkdir -p "$(@coreutils@/bin/dirname "$target")"
	if [ -e "$target" ] && ! [ -L "$target" ]; then
		@coreutils@/bin/mv "$target" "$target.backup"
	fi
	@coreutils@/bin/ln -sf "$FROM/$LINK" "$target"
}


linkHome () {
	home=$1
	resources=$2
	resourceTarget=$3
	while IFS= read -r line; do
		link "$home" "$resources" "$line"
	done < "$resourceTarget"
}

unlinkHome () {
	home=$1
	resourceTarget=$2
	while IFS= read -r line; do
		unlink "$home" "$line"
	done < "$resourceTarget"
}

switchHome () {
	home=$1
	oldResourceTargets=$2
	newResources=$3
	newResourceTargets=$4
	@coreutils@/bin/comm -23 "$oldResourceTargets" "$newResourceTargets" | \
		while IFS= read -r line; do
			unlink "$home" "$line"
		done
	@coreutils@/bin/comm -13 "$oldResourceTargets" "$newResourceTargets" | \
		while IFS= read -r line; do
			link "$home" "$newResources" "$line"
		done
}


showSyntax() {
    echo "\
NixUP Resource Manager commands:
--link <new_nixup_dir>
--unlink <current_nixup_dir>
--switch <current_nixup_dir> <new_nixup_dir>
--home <HOME>
--help"
    exit 1
}


home=$HOME

while [ "$#" -gt 0 ]; do
    i="$1"; shift 1
    case "$i" in
      --help)
        showSyntax
        ;;
      --link|--unlink)
        action="$i"
        nixup_dir="$1"; shift 1
        ;;
      --switch)
        action="$i"
        old_nixup_dir="$1"; shift 1
        new_nixup_dir="$1"; shift 1
        ;;
      --home)
        home=$i
        ;;
      *)
        echo "$0: unknown option \`$i'"
        exit 1
        ;;
    esac
done


if [ -z "$action" ]; then showSyntax; fi


if [ "$action" = "--link" ]; then
	linkHome "$home" "$nixup_dir/resources" "$nixup_dir/resourceTargets"
fi

if [ "$action" = "--unlink" ]; then
	unlinkHome "$home" "$nixup_dir/resourceTargets"
fi

if [ "$action" = "--switch" ]; then
	switchHome "$home" "$old_nixup_dir/resourceTargets" \
		"$new_nixup_dir/resources" "$new_nixup_dir/resourceTargets"
fi

