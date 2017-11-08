
## Branch organization
    1. Each contributor has their own branch (to prevent merge conflicts)
    2. Each commit/merge to the branch 'master' shall be discussed beforehand
    3. Always `git pull` when checking our on 'master'

## File arborescence

    - build/            Makefiles
    - bin/              Binaries (from VHDL files but also Asm and C test programs)
    - doc/              PDFs (ARM documentation, TMEs recap...)
    - misc/             Miscellaneous files
    - org/              All documents regarging the project's organization and avancement
    - src/              VHDL source code
    - test/             C and Asm test programs' source code

### File arborescence in src/

    The file arborescence shall be equivalent to the entity/instance arborescence,
    that means an imbrication level in the entity/instance arborescence is equivalent
    to an imbrication level within the file arborescence.

    Hence the rules :
    - One entity (and architecture) = one file
    - Each entity foo.vhdl in within an eponyme directory foo/
    - This directory foo/ contains foo.vhdl and also directories of all entites
      instanciated in foo.vhdl
    - If an entity toto is instanciated in several entities a, b and c,
      the toto/ directory shall be in a and there must be symbolic links to toto/
      in b/ and c/
    - If an entity is instanciated in many entities, put it in src/common/ and create
      symbolic links in every directories of the instanciating entities.


    **These rules are necessary for the makefile to run correctly and for the
    arboresence to be consistent.**

    Rq : When you're in foo/, by a simple `ls` you can see all the entities
    that are instanciated in foo.vhdl.

## Long-term workflow

    **Check org/ to have a look at what's already been done and what's yet to do**

