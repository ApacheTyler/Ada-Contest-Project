--------------------------------------------------------------------------------
--Name: Tyler Freeman
--Due 10/5/13
--Project: Program 5
--Name: Contest
--
--Contest takes in a file of contestants containing the contestants name and
--skill level. Contest simulates a double elimination tournament in which
--a winner is determined. Order of rounds is Players arrive and put into
--queue in which they compete. If the player wins or looses they should be
--placed in an appropiate queue. The next round is every one who one in the
--preliminary round competes until one contestant is left. All losers are added
--to the queue to the players who lost in the prelim. Next the losing queue
--competes until only one conestant is left, players who loose in this round
--should be placed into the results stack in the order of which they lost in
--accordance with double elimination. The final round is the last player from
--the winning and losing queues compete to determine the winner.
--
--Matches in the contest are determined by skill level, with-in num of wins,
--with-in num of losses, with-in number in which they arrived in case of ties.
--
--If no players show up contest alerts that no players appeared for the contest
--
--If only one player shows up, contest alerts that player wins by default
--
--Sample input for the program would be
--Person890123456789     500
--Person2                400
--Person3                300
--Person4                200
--Person5                100
--
--The corresponding output would be
--Name                        Skill  Wins  Losses   ArivalNum
--Person890123456789           500     4     0          1
--Person2                      400     2     2		2
--Person3                      300     2     2		3
--Person5                      100     0     2		5
--Person4                      200     0     2		4
--



with QueuePkg2;
with StackPkg2;
With Ada.Text_IO; Use Ada.Text_IO;
With Ada.Integer_Text_IO; Use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; Use Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO; Use Ada.Strings.Unbounded.Text_IO;

procedure Contest is
   -----------------------------------------------------------------------------
   --				Data Structures				      --
   -----------------------------------------------------------------------------

   --Used to hold data for contestants read from file
   type Player is record

      Name : String(1..20);
      ArrivalNumber : Integer;
      SkillLevel : Integer;
      NumberOfWins : Integer;
      NumberOfLosses : Integer;

   end record;

   --Used to store the results from contest in descening order from winner
   package playerStack is new StackPkg2(Player);
   use playerStack;

   --Used to store players in appropiate fashion to simulate double elim
   package playerQueue is new queuepkg2(Player);
   use playerQueue;

   -----------------------------------------------------------------------------
   --				End Data Structures			      --
   -----------------------------------------------------------------------------

   -----------------------------------------------------------------------------





   -----------------------------------------------------------------------------
   --Gets standard input, uses it to create a player and creates a Queue
   --with the standard input.
   --If the input contains no player, an error message is printed
   --If only one player shows up, the appropiate message is displayed
   --Begin getInput
   -----------------------------------------------------------------------------
   procedure getInput (arrivalQueue : out Queue; isValid : out boolean) is

      nme : String(1..20);
      arvNum : Integer := 0;
      skllLev : Integer;
      tmpPlayer : Player;

   begin

      while not end_of_file loop--Read file until end

         --Construct a player record
         get(nme);
         tmpPlayer.Name := nme;

         arvNum := arvNum + 1;
         tmpPlayer.ArrivalNumber := arvNum;

         get(skllLev);
         tmpPlayer.SkillLevel := skllLev;

         tmpPlayer.NumberOfWins := 0;
         tmpPlayer.NumberOfLosses := 0;

         --Enqueue player created from file input
         Enqueue(tmpPlayer, arrivalQueue);

      end loop;

      if(isEmpty(arrivalQueue)) then--If file contained no player information
         isValid := false;
         put_line("No one showed up for the contest");
      end if;

      if arvNum = 1 then--If only one player showed up
         isValid := false;
         put_line("Only one contestant showed up");
         put_line("Winner by default " & Front(ArrivalQueue).Name);
      end if;


   end getInput;

   -----------------------------------------------------------------------------
   --end GetInput
   -----------------------------------------------------------------------------

   -----------------------------------------------------------------------------
   --Compare two players to evaluate winners
   --
   --Begin doMatch
   -----------------------------------------------------------------------------
   function doMatch(player1 : in Player; player2 : in Player) return Player is

   begin

      --Return player with highest Skill level
      if player1.SkillLevel /= player2.SkillLevel then

         if player1.SkillLevel > player2.SkillLevel then
            return player1;
         else
            return player2;
         end if;

      --Return player with Highest Number of Wins
      elsif player1.NumberOfWins /= player2.NumberOfWins then

         if player1.NumberOfWins > player2.NumberOfWins then
            return player1;
         else
            return player2;
         end if;

      --Return player with lowest number of losses
      elsif player1.NumberOfLosses /= player2.NumberOfLosses then

         if player1.NumberOfLosses > player2.NumberOfLosses then
            return player2;
         else
            return player1;
         end if;

      --Return player that arrived first
      else

         if player1.ArrivalNumber > player2.ArrivalNumber then
            return player2;
         else
            return player1;
         end if;

      end if;

   end doMatch;

   -----------------------------------------------------------------------------
   --End do match
   -----------------------------------------------------------------------------


   -----------------------------------------------------------------------------
   --Do a match and update player stats and push players onto correct queue
   --Method also updates players stats accordingly to keep track of for double
   --elimination
   --
   --Evaluates: Two Players taken in
   --Mutates: Winner Queue and Loser Queue passed in
   --Begin updateStats
   -----------------------------------------------------------------------------
   procedure updateStats(player1 : in out Player; player2 : in out Player;
                         winQ : out Queue; loseQ : out Queue) is
   begin

      if player1 = doMatch(player1, player2) then

         --Update Stats
         player1.NumberOfWins := player1.NumberOfWins + 1;
         player2.NumberOfLosses := player2.NumberOfLosses + 1;

         --Add player to appropiate queue
         Enqueue(player1, winQ);
         Enqueue(player2, LoseQ);

      else

         player2.NumberOfWins := player2.NumberOfWins + 1;
         player1.NumberOfLosses := player1.NumberOfLosses + 1;

         Enqueue(player2, winQ);
         Enqueue(player1, LoseQ);

      end if;

   end updateStats;
   -----------------------------------------------------------------------------
   --End updateStats
   -----------------------------------------------------------------------------



   -----------------------------------------------------------------------------
   --Does the first round, adds player from arrival queue into approp
   --tournament queue
   --Only executes if the file input was valid
   --
   --If not valid, isValid is passed to calling function in out param
   --Winner and Loser Queue place players on approp Queue
   --
   --begin prelimRound
   -----------------------------------------------------------------------------
   procedure prelimRound (winnerQ : out queue; loserQ : out queue;
                          isValid : out boolean) is
      tmpPlayer1 : Player;
      tmpPlayer2 : Player;
      tmpQueue : Queue;--Mutated from getInput
   begin


      getInput(tmpQueue, isValid);--mutate tmp queue to result of file input

      if isValid then--If not valid dont go furthur
         put("");
      while not isEmpty(tmpQueue) loop --Affects every element in Queue

         tmpPlayer1 := Front(tmpQueue);
         Dequeue(tmpQueue);

         if isEmpty(tmpQueue) then --Checks to see if only one element in queue
            Enqueue(tmpPlayer1, winnerQ);
         else

            tmpPlayer2 := Front(tmpQueue);
            Dequeue(tmpQueue);
            updateStats(tmpPlayer1, tmpPlayer2, winnerQ, loserQ);

         end if;

      end loop;
      end if;

   end prelimRound;
   -----------------------------------------------------------------------------
   --End prelimRound
   -----------------------------------------------------------------------------



   -----------------------------------------------------------------------------
   --Elimination Round loops through the loser Queue and adds players who have
   --two losses to the results stack as to get into the the loser Queue a
   --player must have atleast 1 loss and thus if they loose in this round
   --they should be eliminated
   --
   --Begin eliminationRound
   -----------------------------------------------------------------------------
   procedure eliminationRound(loserQ : in out Queue ; results : out Stack) is
      tmpPlayer : Player;
      tmpOpp : Player;
      tmpQueue : Queue;--Keeps track of winners in this round for re-eval
      finished : boolean := false;--Keeps track of when all players evaluated
   begin

      while not finished loop

         tmpPlayer := Front(loserQ);
         Dequeue(loserQ);

         if isEmpty(loserQ) then--check to see if only one element in queue
            Enqueue(tmpPlayer, tmpQueue);
            finished := true;
         else

            tmpOpp := Front(loserQ);
            Dequeue(loserQ);

            if tmpPlayer = doMatch(tmpPlayer, tmpOpp) then--evaulate win
               tmpPlayer.NumberOfWins := tmpPlayer.NumberOfWins + 1;
               tmpOpp.NumberOfLosses := tmpOpp.NumberOfLosses + 1;
               Enqueue(tmpPlayer, tmpQueue);
               Push(tmpOpp, Results);
            else
               tmpOpp.NumberOfWins := tmpOpp.NumberOfWins + 1;
               tmpPlayer.NumberOfLosses := tmpPlayer.NumberOfLosses + 1;
               Enqueue(tmpOpp, tmpQueue);
               Push(tmpPlayer, Results);
            end if;

         end if;

         while not isEmpty(tmpQueue) loop--Re-add winners to original queue
               tmpPlayer := Front(tmpQueue);
               Enqueue(tmpPlayer, loserQ);
               Dequeue(tmpQueue);
     	 end loop;

      end loop;

   end eliminationRound;

   -----------------------------------------------------------------------------
   --End eliminationRound
   -----------------------------------------------------------------------------


   -----------------------------------------------------------------------------
   --Moves player from the 0 loss queue to the with one loss queue
   --as losing in this round would push player into with one loss queue
   --
   --Winner Queue is queue that was populated in prelim round
   --Loser Queue is queue that was populated in prelim round
   --
   --Winner Round
   -----------------------------------------------------------------------------
   procedure winnerRound(winnerQ : out Queue; loserQ : out Queue) is
      tmpPlayer1: Player;
      tmpPlayer2: Player;
      finished : boolean := false;
   begin

      while not finished loop

         tmpPlayer1 := Front(winnerQ);
         Dequeue(winnerQ);

         if isEmpty(winnerQ) then--Check to see if there is only one player
            Enqueue(tmpPlayer1, winnerQ);
            finished := true;
         else --Put players onto appropiate queue

            tmpPlayer2 := Front(winnerQ);
            Dequeue(winnerQ);
            updateStats(tmpPlayer1, tmpPlayer2, winnerQ, loserQ);

         end if;

      end loop;

   end winnerRound;
   -----------------------------------------------------------------------------
   --End winnerRound
   -----------------------------------------------------------------------------


   -----------------------------------------------------------------------------
   --Compares the last two players left in the competition, at this point only
   --one player should exist in the winner queue, and only one player should
   --exist in the loser queue. The players are pushed onto the stack in the
   --appropiate order in which the winner should be at the top of the stack
   --
   --Begin finalRound
   -----------------------------------------------------------------------------
   procedure finalRound(winnerQ : in Queue; loserQ : out Queue;
                       resultsStack : out Stack) is
      tmpPlayer : Player;
   begin
      tmpPlayer := Front(WinnerQ);
      Enqueue(tmpPlayer, loserQ);
      eliminationRound(loserQ, resultsStack);
      Push(Front(loserQ), resultsStack);
   end finalRound;
   -----------------------------------------------------------------------------
   --End finalRound
   -----------------------------------------------------------------------------



   -----------------------------------------------------------------------------
   --Outputs the results of the competition with Player placement. The player
   --placement is determined by the order of which the players are in, in the
   --stack
   --
   --Begin outputResults
   -----------------------------------------------------------------------------
   procedure outputResults (results : out Stack) is
      tmpPlayer : Player;
      place : Integer := 0;
   begin

      Put_Line("Place  Name                Skill   Wins   Losses   ArrivalNum");

      while not isEmpty(results) loop
         place := place + 1;
         tmpPlayer := top(results);
         put(place, 0);
         put("      ");
         put(tmpPlayer.Name);
         put(tmpPlayer.SkillLevel, 0);
         put(tmpPlayer.NumberOfWins,8);
         put(tmpPlayer.NumberOfLosses, 7);
         put(tmpPlayer.ArrivalNumber, 9);
         new_line;
         Pop(results);
      end loop;

   end outputResults;
   -----------------------------------------------------------------------------
   --End outputResults
   -----------------------------------------------------------------------------



   -----------------------------------------------------------------------------
   --Executes the contest in the specific order specified. Outputs results
   --
   --Begin executeContest
   -----------------------------------------------------------------------------
   procedure executeContest is
      winnerQ :  queue;
      loserQ : queue;
       results : stack;
      isValid : boolean := true;
      tmpQueue : Queue;
   begin

     --checkSpecialCase(specialCase, tmpQueue);

      --if(specialCase = false) then
      prelimRound(winnerQ, loserQ, isValid);
      if isValid = true then
      	winnerRound(winnerQ, loserQ);
     	 eliminationRound(loserQ, results);
     	 finalRound(winnerQ, loserQ, results);
         outputResults(results);
       end if;
      --end if;

   end executeContest;
   -----------------------------------------------------------------------------
   --End executeContest
   -----------------------------------------------------------------------------



   -----------------------------------------------------------------------------
   --
   --***********************Main Procedure**************************************
   --
   -----------------------------------------------------------------------------

begin

   executeContest;

end Contest;
