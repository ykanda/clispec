 (test "echo foo bar baz | cat"
   '((exit-code 0)
     (stdout-contain "foo")
     (stdout-contain "bar")
     (stdout-contain "baz")
     (not (stdout-contain "hoge"))
     (not (stdout-contain "fuga"))
     ))

 (test "echo foo 1>&2"
   '((exit-code 0)
     (stdout-contain "foo")
     (stderr-contain "foo")
     ))
