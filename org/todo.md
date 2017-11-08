
##Things to do in the short-term / middle-term :

###This TODO-list is not mandatory, it's just here to have a look at what's done, what's not.

BIG STUFFS TO DO
[ ] List instructions and variants
[ ] Find the association between instruction binary word and associated decoded instruction
    (what bit means what?) (i.e. how DECOD will work?)
[ ] Find the set of asm tests that cover the whole range of quirks and possibilites
[ ] Big scheme that show how entities are wired together
[ ] Table that justifies the existence of each interface signal

LITTLE STUFFS TO DO
[ ] For each EXE input, find an instruction that justifies the existence of that input

SOME SILLY QUESTIONS
- In which stage is data read/written in the register set ?
- It has been said there's no FIFO between DEC and EXE... really?
- What's the stuff about the PC + 4, PC + 8 quirk, why is it bad design ?
- So.. there's only 1 bypass, is it normal? Is it because it's an asynchronous design ?
- Why did the teacher say the FIFO doesn't work, since it seems to work perfectly ?
