-- This is the generic specification for a dynamic queue abstract data type.

generic

    -- Size: Positive;
    -- Size was included in the array implementations
    --      and is not needed here.

    type ItemType is private;

package QueuePkg2 is

    type Queue is limited private;

    Queue_Empty, Queue_Full: exception;

    function  isEmpty(Q: Queue) return Boolean;
    function  isFull(Q: Queue) return Boolean;

    function  front(Q: Queue) return ItemType;

    procedure enqueue (Item: ItemType; Q: in out Queue);
    procedure dequeue (Q: in out Queue);

private

    type QueueNode;

    type QueueNodePointer is access QueueNode;

    type QueueNode is record
        Data: ItemType;
        Next: QueueNodePointer;
    end record;

    type Queue is record
        Front: QueueNodePointer := NULL;
        Back: QueueNodePointer := NULL;
    end record;

end QueuePkg2;
