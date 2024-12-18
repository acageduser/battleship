# CSC 240 Coursework pt.2

## CSC240 Assignment #10
This week, you guessed it, we are learning a new data structure, DS_Stacks! Stacks are a fantastic
data structure for scenarios where we need to maintain the order of our elements, but only need to
access the last element that was inserted. Stacks follow a Last In, First Out (LIFO) order, meaning the last
element inserted is the first element that can be removed (think of a stack of plates, the last plate you
wash & dry and place in the cupboard is the first one you’ll pick up and use). Stacks have two primary
operations: push(), which adds an element on top of the stack, and pop(), which removes the top
element from the stack and returns it. One other common operation with Stacks is peek() (called top() in
GameMaker cause they always have to try and be unique ), which returns the element on top of the
stack, without actually removing the element from the stack. Of course, other basic operations exist for
checking the number of elements on the stack (size) or if it is empty (empty), but these are the main
methods utilized.<br/><br/>

This week, we are going to utilize DS_Stacks to implement a childhood classic card game, Crazy
Eights! This implementation will follow the rules found here: https://bicyclecards.com/how-to-
play/crazy-eights (I implemented a score limit of 100, since the page does not provide a standard score
limit). With just a few Structs, Stacks are an excellent structure for assisting us in representing a deck of
cards and various play piles in many different card games (only one play pile in Crazy Eights though)!<br/><br/>

For this assignment, just like last time, I have created the UI, Gamemaker Objects, and defined a
few Structs that are used in the implementation. You are responsible for creating the Deck and Pile
(CrazyEightPile) structs, as they will utilize a Stack of Cards in the implementation. The script files
containing the structure of the Deck and Pile Structs are already created for you. Inside of these Structs,
you will find that I have provided for you the following:<br/><br/>

• All attributes as well as brief descriptions of what each of these attributes are used to
represent/control<br/>
• The names and parameters of all of the methods that you must implement. (NOTE: function
names must remain the same, as they are referenced in various areas of the code)<br/>
• Documentation for each function that specifies what that function is to do, what the parameters
represent, and what the return value should represent.<br/><br/>

You are simply responsible for filling in the empty Struct methods with the code that would
perform the specified actions. This time, I have further modularized our code by implementing Structs
for each of the User Interface elements. These Structs are preceded by “ui”. All other Structs are abstract
implementations for storing the Game state (aka the Game Model), as in past projects. I would suggest
porting these Model Structs (mainly the Card, Deck, Hand, and Pile structs) out into a blank project and
testing each of the functions as you write them. You will also notice that this time, the .toString()
methods for Deck and Pile are left empty. You are responsible for writing these .toString() methods for
the Deck and Pile Structs (.toString() for Hand, Card, and Game are still provided to you). Once you
believe that you have the Deck and Pile Structs up and running, paste this into the fully-working project
that I have provided to you and if it works properly, then congratulations, you’ve done it!<br/><br/>

Due Date: 11/11/24 @ 11:59 PM<br/><br/>

Please note: You only need to edit the Deck and Pile Struct script files. There does not need to be
any other changes made to any of the other files or code in the Gamemaker objects, however, I would
highly recommend taking a look at these areas and understanding what they do, as this may make your
implementation a bit easier, as well as thoroughly prepare you for designing your Final Project. I have
made sure to incorporate thorough documentation to guide you through all areas of the program.
When you have completed the assignment, please zip up your Game folder and submit it to the
Week 10 Assignment Dropbox.<br/><br/>

## CSC240 Assignment #9
This week we will be learning a new data structure, DS_Queues! Queues are a great data
structure for when we want to maintain the order of our elements and typically only need to access each
of the elements in the order they were inserted. Queues follow a First In, First Out (FIFO) order, meaning
the first element inserted is the first element that can be removed (think of a line at the grocery store).
Queues essentially have two main operations: enqueue(), which places an element into the queue, and
dequeue(), which removes the first element in the queue from the queue and returns said element.
Other operations exist within queues for checking the number of elements and whether or not the
queue is empty, but these are the two main methods utilized.<br/><br/>

This week, we are going to utilize DS_Queues to implement a classic, the game of Snake! By
using a Queue and some of the structs we utilized last time for Battleship, we can represent the Snake,
like so:

![image](https://github.com/user-attachments/assets/6ea0d8db-0986-4e9e-b2f1-afb7808beff4)


For this assignment, just like last time, I have created the UI, Gamemaker Objects, and defined a
few Structs that are used in the implementation. You are responsible for creating the Snake struct, as it
will utilize a Queue of Cells as in the diagram. The script file containing the structure of the Snake Struct
is already created for you. Inside of the Snake Struct, you will find that I have provided for you the
following:<br/><br/>

- All attributes for the Snake Struct as well as brief descriptions of what each of these attributes
are used to represent/control<br/>
- The names and parameters of all of the methods that you must implement. (NOTE: function
names must remain the same, as they are referenced in various areas of the code)<br/>
- Documentation for each function that specifies what that function is to do, what the parameters
represent, and what the return value should represent.<br/>
- One singular fully-completed .toString() method for your testing.<br/><br/>

Due Date: 11/4/24 @ 11:59PM<br/><br/>
You are simply responsible for filling in the empty Struct methods with the code that would
perform the specified actions. I would suggest porting all of the Structs (mainly the Cell, Board, and
Snake structs) out into a blank project and testing each of the functions as you write them. Make use of
the .toString() methods for the structs! They will be extremely useful in making sure you are performing
these actions appropriately. Once you believe that you have the Snake Struct up and running, paste this
into the fully-working project that I have provided to you and if it works properly, then congratulations,
you’ve done it!<br/><br/>

Please note: You only need to edit the Snake Struct script file. There does not need to be any
other changes made to any of the other files or code in the Gamemaker objects, however, I would highly
recommend taking a look at these areas and understanding what they do, as this may make your
implementation a bit easier. I have made sure to incorporate thorough documentation to guide you
through all areas of the program.<br/><br/>

When you have completed the assignment, please zip up your Game folder and submit it to the
Assignment 9 Dropbox<br/><br/>

## CSC240 Assignment #8
Now that we have completed our first fully functional game, we are going to switch gears and
start learning about various data structures that are useful in the word of programming and in game
development. Each week, we are going to tackle a different data structure and use it to implement a
classic board/card/video game. This week we will be tackling DS_Grids! DS_Grids are pretty much 2D
arrays, with which you should hopefully be somewhat familiar with already, however, DS_Grids offer a
ton of different functionality that 2D arrays do not in Gamemaker, making it a more viable option for
path-finding and grid-based games. We will not be diving into systems as complex as the
aforementioned, but we should learn the basics, as it may prove extremely useful to us later. For this
week, we are going to be implementing a single-player version of the classic popular board game,
Battleship!<br/><br/>

All of our projects will now be Parson-esque going forward. I will give you the Gamemaker
project for a fully functional implementation of the game, however, I have removed certain elements
from the code that you must complete. For this assignment, I have created the UI, Gamemaker Objects,
and defined a few Structs that are used in the implementation. You are responsible for creating the
Board struct, as it will utilize 1-dimensional arrays and DS_Grids in its implementation. The script file
containing the structure of the Board Struct is already created for you. Inside of the Board Struct, you
will find that I have provided for you the following:<br/><br/>

- All attributes for the Board Struct as well as brief descriptions of what each of these attributes
are used to represent/control<br/>
- The names and parameters of all of the methods that you must implement. (NOTE: function
names must remain the same, as they are referenced in various areas of the code)<br/>
- Documentation for each function that specifies what that function is to do, what the parameters
represent, and what the return value should represent.<br/>
- One singular fully-completed .toString() method for your testing.<br/><br/>

You are simply responsible for filling in the empty Struct methods with the code that would
perform the specified actions. I would suggest porting all of the Structs (mainly the Cell, Ship, and Board
structs) out into a blank project and testing each of the functions as you write them. Make use of the
.toString() methods for the structs! They will be extremely useful in making sure you are performing
these actions appropriately. Once you believe that you have the Board Struct up and running, paste this
into the fully-working project that I have provided to you and if it works properly, then congratulations,
you’ve done it!<br/><br/>

Please note: You only need to edit the Board Struct script file. There does not need to be any
other changes made to any of the other files or code in the Gamemaker objects, however, I would highly
recommend taking a look at these areas and understanding what they do, as this may make your
implementation a bit easier. I have made sure to incorporate thorough documentation to guide you
through all areas of the program.<br/><br/>

When you have completed the assignment, please zip up your Game folder and submit it to the
Week 8 Assignment Dropbox.<br/><br/>
