# sayIt

A kind of buggy and bad simplistic messenger

- Single message

```lua
sayIt.New("Some name", {"Message uno...", "Press enter", "Last message"})
```

- Multiple messages

```lua
sayIt.New("Some name", {"Message uno...", "Press enter", "Last message", "\n"})
sayIt.New("Scotch Egg", {"Say...", "This message thing is pretty limited,", "And I'm really bad at programming", "\n" })
sayIt.New("Bill Nye", {"This next segment coming up is really good", "Lots of schmear", "Oy vey!"})
```

An escape character, `\n`, must come after each `sayIt.New()` if multiple messages are being displayed - for reasons.