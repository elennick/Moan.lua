```moon
Messenger = Moan.newContainer()

Messenger.createGroup("Player")
with Messenger.groups["Player"]
  \assignAttributes({
    -> setImage("dir/Player.png")
    -> setSpeed(0.2)
  })

with Messenger.new("<wavy>Hi there!</wavy>", "How's it going?")
  \setGroup("Player")
  \setOptions({
    [1]: {"Option 1", -> one()}
    [2]: {"Option 2", -> two()}
    [3]: {"Option 3", -> three()}
    })
  \onStart(-> doSomething())
  \onComplete(-> doSomethingElse())
```
