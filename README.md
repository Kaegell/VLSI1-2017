
## Branch organization
    1. Each contributor has their own branch (to prevent merge conflicts)
    2. Each commit/merge to the branch 'master' shall be discussed beforehand
    3. Always 'git pull' when checking our on 'master'

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
    - If entity A is instanciated within entity B, the arborescence shall be
      - a/
        - a.vhdl
        - b/
          - b.vhdl

## Long-term workflow

    **Check org/ to have a look at what's already been done and what's yet to do**

