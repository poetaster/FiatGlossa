# Fiat Glossa

A small translator for Sailfish OS, in the Fiat family. It translates with
DeepL using the user's own API key, so there is no server to run and no
account with me.

## The two Englishes

"English (Traditional)" is British, "English (Simplified)" is American. DeepL
knows the difference and has separate codes for them, so the joke is real
rather than painted on. Between the two, though, the app never calls DeepL at
all: `src/spelling.cpp` holds the word table and converts on the phone, which
costs nothing, answers instantly and works with no signal. Chinese Traditional
and Simplified sit right below them in the list, which is where the joke gets
its straight man.

## Build

Build -> Clean All -> Run qmake -> Build. Deploy, then launch from the app
icon and not from Qt Creator's Run button: only the icon goes through
Sailjail, so only the icon tests the Internet permission.

## The key

Settings has a page explaining where a DeepL key comes from. In short: the
free developer plan on deepl.com, then copy the key into Settings. A free-tier
key ends in `:fx` and the app sends it to `api-free.deepl.com`; anything else
goes to `api.deepl.com`. Nothing else in the app changes.

`Check the key` in the Settings pull-down calls `GET /v2/usage` and shows the
characters used, which is the quickest way to tell a good key from a typo.

## Worth checking on the device

    find /usr/share/themes -name '*swap*'

The swap button uses `icon-m-swap`. If that finds nothing, the icon does not
exist on this release and needs replacing with a drawn shape.

## Icons

`tools/generate_icon.py` renders all four sizes from the tongue traced in
`tools/tongue-alpha.png` and `tools/tongue-shade.png`. The cream field is 80%
of the icon side, the house value Caesar set for the whole family. The tongue
is centred by its mass rather than its bounding box, because the curl reaches
right and the tail reaches down.

    python3 tools/generate_icon.py --preview
