# Project *Sienna* #

Sienna is a simple, fast-paced platformer currently in development.

You can follow the development of Sienna on my [devlog](http://simonlarsen.blogspot.dk/search/label/sienna).

## Controls ##

Press space to jump or wall jump.
The longer you hold the button the higher you jump. This is crucial to the gameplay.

## Map structure ##

### Tilesets ###
When creating maps in Tiled, the following tile sets should be present:

    +---------+---------+-------+
    | name    | gid     | tiles |
    |---------|---------|-------|
    | fgtiles |   1-256 | 16x16 |
    | bgtiles | 257-512 | 16x16 |
    | objects | 513-658 | 16x16 |
    +---------+---------+-------+

### Layers ###
All maps must contains three layers. Two tile layers, *fg* and *bg*, using tiles from *fgtiles* and *bgtiles* respectively, and an object layer, *obj*, using either regular objects with appropriate type and properties or a tile.

#### *obj* layer ####
Currently added object types

    +----------------+----------------------------------------+-----------------+
    | TYPE           | DEFINED WITH                           | PROPERTIES      |
    |----------------|----------------------------------------|-----------------|
	| CONTROL ENTITIES                                                          |
    |----------------|----------------------------------------|-----------------|
    | player start   | type = "start"                         |                 |
	| trigger        | type = "trigger"                       | action, x, y,   |
	|                |                                        |  cooldown       |
    |----------------|----------------------------------------|-----------------|
	| HOSTILE ENTITIES                                                          |
    |----------------|----------------------------------------|-----------------|
    | rotating spike | OBJ_ROTSPIKE <= gid <= OBJ_ROTSPIKE+1  |                 |
	| bee            | type = "bee"                           | time, dir, yint | 
	| dog            | type = "dog"                           | dir, jump       |
	| mole           | type = "mole"                          | dir             |
	| spider         | type = "spider"                        |                 |
	| stone          | Only created by trigger                | yspeed          |
	| fireball       | Only created by trigger                | top             |
	| turret         | type = "turret"                        | dir, range,     |
	|                |                                        |  cooldown       |
    |----------------|----------------------------------------|-----------------|
	| PICKUPS                                                                   |
    |----------------|----------------------------------------|-----------------|
	| checkpoint     | gid = OBJ_CHECKPOINT                   | dir             |
	| jumppad        | gid = OBJ_JUMPPAD_S - OBJ_JUMPPAD_E    | power           |
    +----------------+----------------------------------------+-----------------+
