-- This is the dynamic implementation of the generic specification for a stack
-- abstract data type.

with Unchecked_Deallocation;

package body StackPkg2 is


     procedure priv(s: stack) is
         t: stack := s;
     begin
         null;
     end priv;

     procedure Dispose is
         new Unchecked_Deallocation (Object => StackNode,
                         Name   => Stack);


     --Determines if stack is empty
     function isEmpty (S : Stack) return Boolean is
     begin
         return S = NULL;
     end isEmpty;

     --Determines if there is no more memory for stack
     function isFull (S : Stack) return Boolean is
         Tmp_Pointer : Stack;

     begin
         Tmp_Pointer := new StackNode;
         Dispose (Tmp_Pointer);
         return False;

     exception
         when STORAGE_ERROR =>
             return TRUE;
     end isFull;

     --Adds items into the stack
     procedure Push (Item : ItemType; S : in out Stack) is
     begin
         if isFull (S) then
             raise Stack_Full;
         else
             S := new StackNode'(Item, S);
         end if;
     end Push;

     --Removes items from stack
     procedure Pop (S : in out Stack) is
         Node_Pointer : Stack := S;
     begin
         if isEmpty (S) then
             raise Stack_Empty;
         else
             S := S.Next;
             Dispose (Node_Pointer);
         end if;
     end Pop;

     --Gets the item at the top of the stack
     function Top (S : Stack) return ItemType is
     begin
         if isEmpty (S) then
             raise Stack_Empty;
         else
             return S.Item;
         end if;
     end Top;

end StackPkg2;
