PasteRackIt
-----------

#### What is it?

It's a CLI script for [pasterack](http://pasterack.org).

#### Details

I wrote this because I didn't find an existing pastebin script for
[pasterack](http://pasterack.org). It was also a fairly interesting
"Mini-Project" that I attempted as a means to get my feet wet with the
language.

#### Features:

- See Usage function, invoked via `<scriptname>.rkt -h`

- Proxy support exists for simple http proxies, via the `$http_proxy` variable in the environment.
  Proxies that require usernames and passwords are not supported at the moment.
  Other Proxy protocols such as `HTTPS` and `SOCKS` are not supported at the moment, because support
  is lacking in the underlying racket libraries.



#### Bugs/Issues

If you come across any buggy behaviour or would like to request any additional
features please feel free to open a github issue or ping me on the #racket IRC
on freenode.
