# Project *Sienna* #

## Controls ##

* Jump: Space
* Slow down: Left shift

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

+----------------+------------------------------------------+
| type           | defined as                               |
|----------------|------------------------------------------|
| player start   | any object with type "start"             |
| rotating spike | gid = 513-514, defined by *OBJ_ROTSPIKE* |
+----------------+------------------------------------------+
