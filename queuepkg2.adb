with Unchecked_Deallocation;

package body queuepkg2 is
--------------------------------------------------------------------------------
   procedure Dispose is
         new Unchecked_Deallocation (Object => QueueNode,
                                     Name   => QueueNodePointer);
--------------------------------------------------------------------------------

--Determines if no elements in queue
--------------------------------------------------------------------------------
   function isEmpty (Q: Queue) return Boolean is
   begin
      return Q.Front = null;
   end isEmpty;
--------------------------------------------------------------------------------

--Determines if queue has any memory to put items onto it
--------------------------------------------------------------------------------
   function  isFull(Q: Queue) return Boolean is
   tmp_Pointer : QueueNodePointer;
   begin
      tmp_Pointer := new QueueNode;
      Dispose(tmp_Pointer);
      return false;

   exception
         when STORAGE_ERROR => return true;
   end isFull;
--------------------------------------------------------------------------------

--Gets the element at the front of the queue and returns it
--------------------------------------------------------------------------------

   function front (Q: Queue) return ItemType is
   begin
      return Q.Front.Data;
   end front;

--------------------------------------------------------------------------------

--Puts an element onto the queue
--------------------------------------------------------------------------------

   procedure enqueue (Item: ItemType; Q: in out Queue) is
     	tmp : QueueNodePointer;
   begin
   	 tmp := new QueueNode'(Item, null);
    if not isFull(Q) then
     	 if isEmpty(Q) then
            Q.Front := tmp;
      	 else
            Q.Back.next := tmp;
         end if;
         Q.Back := tmp;
    end if;
   end enqueue;
--------------------------------------------------------------------------------


--Removes first element on the queue
--------------------------------------------------------------------------------

   procedure dequeue (Q: in out Queue) is
      tmp: QueueNodePointer;
   begin
      if not isEmpty(Q) then
        tmp := Q.Front;
        Q.Front := Q.Front.Next;
        Dispose(tmp);--if front is null
      end if;

      if(Q.Front = null) then
         Q.Back := null;
      end if;


   end dequeue;
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

end queuepkg2;
